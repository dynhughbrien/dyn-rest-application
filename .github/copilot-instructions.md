# Copilot Instructions

This is a Spring Boot REST API designed for **observability testing** — endpoints intentionally produce errors, delays, and memory pressure to validate monitoring tools (Dynatrace, AppDynamics, OpenTelemetry). Do not "fix" the intentional chaos.

## Build & Test

```bash
./mvnw clean install          # full build
./mvnw clean package          # JAR only
./mvnw test                   # all tests

# Run a single test class
./mvnw test -Dtest=RestApplicationTests

# Run locally (port 8083)
java -jar ./target/rest-application-0.9.5.jar

# Docker (multi-arch)
docker buildx build --platform linux/amd64,linux/arm64 --push -t hughbrien/rest-application:0.9.5 .
```

No linters or formatters are configured. Follow existing code style.

## Architecture

All controllers live in `com.hugenet.controller`. DTOs (`Greeting`, `Welcome`) are **Java records**. There is no database — all state is in-memory and resets on restart.

`RestApplication.java` reads `REMOTE_TEST_HOST` and `REMOTE_DEFAULT_PORT` system properties at startup to configure outbound HTTP call targets (used by `GreetingController` for distributed tracing demos).

**Test package mismatch is intentional:** tests live in `com.appdynamics.restappdynamics`, not `com.hugenet.controller`. This is a legacy artifact — do not rename.

## Key Conventions

**Intentional chaos — never remove or fix:**
- `BasicController` (`/api/basic/*`): NullPointerException, ArithmeticException, `@RequestParam` used instead of `@PathVariable`, unhandled RuntimeException, and a method with no `@GetMapping` — all deliberate for error-monitoring demos.
- `Thread.sleep()` calls in `GreetingController` and `WelcomeController` — synthetic latency for observability testing.
- `GreetingController.application()`: 20% chance of 10–15s delay, capped at 10 per hour. Resets each hour via `currentHour` / `slowDownCount` fields.
- `GreetingController.check_message()`: throws `RuntimeException` ~10% of the time.

**Thread safety:** Use `AtomicLong` for all request counters (see existing controllers).

**Memory simulation:** `MemoryController` uses a `LinkedHashMap<String, byte[]>` with insertion-order FIFO eviction. Chunks are filled with `0xAB` to force real JVM allocation (not just virtual memory).

**Version management:** Version is defined in `pom.xml`. The Dockerfile `COPY` path must be updated manually to match the JAR name when bumping versions.

**Known inconsistency:** `Dockerfile` exposes port `8000`, but the app listens on `8083` (per `application.properties`). This is a known, pre-existing issue.

## Kubernetes

Deployment in `manifest/rest-application.yaml`: namespace `rest-application`, 3 replicas, `LoadBalancer` on port 8083. Liveness/readiness probes hit `/actuator`. Image: `hbrien622/rest-application:0.9.5`.

## CI/CD

`.github/workflows/main.yml` is a manually triggered workflow that POSTs a deployment event JSON to `${{ secrets.ENDPOINT_URL }}` using `${{ secrets.API_TOKEN }}`.
