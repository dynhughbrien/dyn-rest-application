# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Spring Boot REST API demo application (v0.9.5) designed for observability testing with OpenTelemetry, AppDynamics, and Dynatrace. Endpoints intentionally produce errors, delays, and memory pressure to validate monitoring tools. Do not "fix" the intentional chaos.

## Build & Run Commands

```bash
# Full build
./mvnw clean install

# JAR only
./mvnw clean package

# Run all tests
./mvnw test

# Run a single test class
./mvnw test -Dtest=RestApplicationTests

# Run locally (port 8083)
java -jar ./target/rest-application-0.9.5.jar

# Docker (single-arch)
docker build . -t restapplication:latest
docker run -p 8083:8083 restapplication:latest

# Docker (multi-arch push)
docker buildx build --platform linux/amd64,linux/arm64 --push -t hughbrien/rest-application:0.9.5 .
```

## Architecture

All controllers and DTOs live in `com.hugenet.controller`. `Greeting` and `Welcome` are Java records (not classes).

`RestApplication.java` reads `REMOTE_TEST_HOST` and `REMOTE_DEFAULT_PORT` system properties at startup to configure outbound HTTP call targets used by `GreetingController` for distributed tracing demos.

No database — all state is in-memory and resets on restart. `AtomicLong` is used for thread-safe request counters across all controllers.

**Test package mismatch:** Tests live in `com.appdynamics.restappdynamics`, not `com.hugenet.controller`. This is a known legacy artifact — do not rename.

## Intentional Chaos — Never Remove or Fix

- **`BasicController` (`/api/basic/*`):** NullPointerException, ArithmeticException, `@RequestParam` used instead of `@PathVariable`, unhandled RuntimeException, and a method with no `@GetMapping` — all deliberate for error-monitoring demos.
- **`Thread.sleep()` calls** in `GreetingController` and `WelcomeController` — synthetic latency for observability testing.
- **`GreetingController.application()`:** 20% chance of 10–15s delay, capped at 10 per hour. Resets each hour via `currentHour` / `slowDownCount` fields.
- **`GreetingController.check_message()`:** throws `RuntimeException` ~10% of the time.
- **`GreetingController.greeting()`:** slow during the first 5 minutes of each hour.
- **`MemoryController`:** Uses a `LinkedHashMap<String, byte[]>` with insertion-order FIFO eviction. Chunks are filled with `0xAB` to force real JVM allocation (not virtual memory).

## Configuration & Known Inconsistencies

- App listens on port `8083` (`application.properties`), but `Dockerfile` exposes port `8000` — pre-existing, do not change.
- When bumping the version in `pom.xml`, also update the `COPY` path in `Dockerfile` to match the new JAR filename.
- Kubernetes deployment (`manifest/rest-application.yaml`): namespace `rest-application`, 3 replicas, LoadBalancer on port 8083, liveness/readiness probes hit `/actuator`, image `hbrien622/rest-application:0.9.5`.

## CI/CD

`.github/workflows/main.yml` is manually triggered. It POSTs a deployment event JSON to `${{ secrets.ENDPOINT_URL }}` using `${{ secrets.API_TOKEN }}`.