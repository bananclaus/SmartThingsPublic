# AGENTS.md

## Cursor Cloud specific instructions

### Overview

This is the **SmartThingsPublic** repository — a collection of Groovy SmartApps and Device Type Handlers (DTHs) for the Samsung SmartThings IoT platform. It is **not a runnable application**; the Groovy scripts execute on the SmartThings cloud platform. Local development is limited to syntax/compilation checking.

### System Requirements

- **JDK 8** — Gradle 2.10 is incompatible with JDK 9+. The update script installs `openjdk-8-jdk` and sets it as the default via `update-alternatives`.
- **Groovy** — Required for `groovyc` compilation checks (the primary local dev workflow and the pre-commit hook).
- **JAVA_HOME** must be set to `/usr/lib/jvm/java-8-openjdk-amd64`. The update script appends this to `~/.bashrc` if not already present.

### Lint / Compilation Checking

The primary "lint" for this repo is `groovyc` syntax checking. Run it on individual `.groovy` files:

```bash
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
groovyc path/to/file.groovy
```

- **SmartApps** (`smartapps/`) generally compile cleanly.
- **Device Type Handlers** (`devicetypes/`) will produce `unable to resolve class physicalgraph.*` errors — these are **expected** because those classes come from the SmartThings platform SDK (not available locally). The pre-commit hook in `.githooks/pre-commit` filters these out via `grep -v "unable"`.

### Gradle Build

The full Gradle build (`./gradlew compileSmartappsGroovy compileDevicetypesGroovy`) requires **SmartThings Artifactory credentials** (`smartThingsArtifactoryUserName` / `smartThingsArtifactoryPassword`) passed as `-P` flags. These are proprietary Samsung credentials and not available in the public repo. Without them, Gradle will fail at dependency resolution (403 from `smartthings.jfrog.io`).

### Pre-commit Hook

The git pre-commit hook at `.githooks/pre-commit` runs `groovyc` on staged `.groovy` files and rejects commits with real syntax errors (ignoring `unable to resolve` errors from platform classes). To activate it:

```bash
git config core.hooksPath .githooks
```

### Project Structure

- `smartapps/` — SmartApp Groovy scripts organized by contributor
- `devicetypes/` — Device Type Handler Groovy scripts organized by contributor
- `build.gradle` — Gradle build config (requires Artifactory credentials)
- `.githooks/pre-commit` — Pre-commit hook for Groovy syntax checking
- `.circleci/config.yml` — CI configuration
