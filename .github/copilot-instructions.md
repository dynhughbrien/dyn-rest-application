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
java -jar ./target/rest-application-1.0.3.jar

# Docker (multi-arch)
docker buildx build --platform linux/amd64,linux/arm64 --push -t hbrien622/rest-application:1.0.3 .
```

No linters or formatters are configured. Follow existing code style.

## Architecture

All controllers live in `com.hugenet.controller`. DTOs (`Greeting`, `Welcome`, `DemoWorld`) are **Java records**. There is no database — all state is in-memory and resets on restart.

`RestApplication.java` reads `REMOTE_TEST_HOST` and `REMOTE_DEFAULT_PORT` system properties at startup (defaults: `localhost` / `8083`). `RestApplication` is annotated with `@EnableScheduling`, though no scheduled tasks are currently active.

**Test package mismatch is intentional:** tests live in `com.appdynamics.restappdynamics`, not `com.hugenet.controller`. This is a legacy artifact — do not rename.

### Controllers & Endpoints

| Controller | Endpoints | Purpose |
|---|---|---|
| `GreetingController` | `/greeting`, `/application`, `/check_message`, `/machine` | Distributed tracing, synthetic latency, random errors |
| `WelcomeController` | `/welcome`, `/applicationx` | Simple responses + synthetic delay |
| `MemoryController` | `/addmemoryusage`, `/reducememoryusage`, `/reportmemoryuse` | JVM heap pressure simulation |
| `BasicController` | `/api/basic/*` | Intentional exceptions for error-monitoring demos |
| `DemoWorldController` | `/demoworld` | Simple health/status endpoint |

`GreetingController.greeting()` makes hardcoded outbound HTTP calls to `www.hughbrien.com` and `www.steelstratus.com` (not configurable via `REMOTE_TEST_HOST`).

## Key Conventions

**Intentional chaos — never remove or fix:**
- `BasicController` (`/api/basic/*`): NullPointerException, ArithmeticException, `@RequestParam` used instead of `@PathVariable`, unhandled RuntimeException, and a method with no `@GetMapping` — all deliberate for error-monitoring demos.
- `Thread.sleep()` calls in `GreetingController` and `WelcomeController` — synthetic latency for observability testing.
- `GreetingController.greeting()`: adds 2–5s delay during the first 5 minutes of each hour.
- `GreetingController.application()`: 20% chance of 10–15s delay, capped at 10 per hour. Resets each hour via `currentHour` / `slowDownCount` fields.
- `GreetingController.check_message()`: throws `RuntimeException` ~10% of the time.
- `WelcomeController.applicationx()`: random 1–5s delay on every request.

**Thread safety:** Use `AtomicLong` for all request counters (see existing controllers).

**Memory simulation:** `MemoryController` uses a `LinkedHashMap<String, byte[]>` with insertion-order FIFO eviction. Chunks are filled with `0xAB` to force real JVM allocation (not just virtual memory).

**Version management:** Version is defined in `pom.xml` (currently `1.0.3`). The `Dockerfile` `COPY` path and the K8s manifest image tag must be updated manually to match when bumping versions. Note: `application.properties` has a separate `version` property that is not auto-synced with `pom.xml`.

**Known inconsistency:** `Dockerfile` exposes port `8000`, but the app listens on `8083` (per `application.properties`). This is a known, pre-existing issue — do not change it.

## Kubernetes

Deployment in `manifest/rest-application.yaml`: namespace `rest-application`, 3 replicas, `LoadBalancer` on port 8083. Liveness/readiness probes hit `/actuator`. Image: `hbrien622/rest-application:1.0.3`.

## CI/CD

Three GitHub Actions workflows:
- `main.yml` — manually triggered; POSTs a deployment event to `${{ secrets.ENDPOINT_URL }}` using `${{ secrets.API_TOKEN }}`.
- `dynatrace-release-event.yml` — fires on GitHub Release created; sends an SDLC `release.created` bizEvent to Dynatrace OpenPipeline. Requires secrets: `DT_TENANT_URL`, `DT_API_TOKEN` (scope: `bizevents.ingest`).
- `test-release-event.yaml` — manual trigger for testing the Dynatrace release event workflow.
