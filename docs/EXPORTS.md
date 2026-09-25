# Last Signal — Web + Android

The project intentionally uses one Godot codebase for both targets.

## Web

Open **Project → Export → Add… → Web**, install the matching export templates, and export the project. Publish the generated files to a static host. For browser testing, use Godot's local web export workflow.

## Android

Open **Project → Export → Add… → Android**, configure the Android SDK/JDK and package identifier, install the matching export templates, and export an APK for testing.

## Build rule

Do not fork gameplay logic between Web and Android. Keep platform-specific purchase, notification and permission integrations behind small adapters.
