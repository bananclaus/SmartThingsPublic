# AGENTS.md

## Cursor Cloud specific instructions

### Repository overview
This is the SmartThings Public repository — a collection of Groovy SmartApps and Device Type Handlers (DTH) for the Samsung SmartThings IoT platform. It is **not** a runnable application; these are Groovy scripts that execute on SmartThings' cloud infrastructure.

### Development environment
- **Java 8** is required (Gradle 2.10 is incompatible with newer Java versions)
- **Groovy 2.4.7** is installed at `/opt/groovy-2.4.7` for syntax checking
- Environment variables are configured in `/etc/profile.d/smartthings-dev.sh`
- The git hooks path is set to `.githooks/` (contains a pre-commit syntax checker)

### Lint / Syntax check
The pre-commit hook in `.githooks/pre-commit` runs `groovyc` on staged `.groovy` files. To manually check a file:
```
groovyc path/to/file.groovy
```
Errors containing "unable" are ignored (dependency resolution failures expected without the full SDK).

### Build (requires private credentials)
The full Gradle build requires SmartThings Artifactory credentials (`smartThingsArtifactoryUserName` / `smartThingsArtifactoryPassword`):
```
./gradlew compileSmartappsGroovy compileDevicetypesGroovy \
  -PsmartThingsArtifactoryUserName="$USER" \
  -PsmartThingsArtifactoryPassword="$PASS"
```
Without these credentials, Gradle tasks will fail at dependency resolution. This is expected.

### Key gotchas
- Gradle 2.10 **only works with Java 8**. Do not switch `JAVA_HOME` to Java 11+.
- The `build.gradle` applies proprietary SmartThings plugins that are only available from their private Artifactory. Local builds are limited to `groovyc` syntax checking without those credentials.
- MQ5 files (MetaTrader Expert Advisors) in this repo are standalone trading bot scripts — they cannot be compiled here as they require the MetaTrader 5 IDE/compiler.
