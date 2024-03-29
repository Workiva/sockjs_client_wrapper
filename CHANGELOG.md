## 1.3.0

- Add `debugUrl` field to `SockJSOpenEvent`, which will be set to the full
SockJS URL connected to by the underlying transport when using the unminified
`sockjs.js` asset.

## 1.2.0

- Migrate to null safety. SDK constraint raised to 2.12

## 1.1.12

- Update SockJS library to 1.6.1.

## 1.1.9

- CI tweaks.

## 1.1.8

- Dependency upgrades.
- Simplify Github CI workflow.
- Formatting and analysis lints.

## 1.1.6

- Replace deprecated `pub` commands

## 1.1.4 - 1.1.5

- Dependency upgrades.

## 1.1.0

- Update SockJS library to 1.5.0 and add sourcemaps.

## 1.0.14

- Raise Dart SDK minimum to 2.4.0

## 1.06 - 1.0.13

- Internal changes and CI updates.

## 1.0.5

- Dart 2 compatible.

## 1.0.4

- Updated the SockJS library to v1.1.5 to pull in a fix for an issue
  where xhr_streaming loops infinitely after the connection closes.

## 1.0.3

- Compatible with latest Dart 2.x dev channel and Dart Dev Compiler.

## 1.0.2

- Logging was disabled as it was originally too verbose.

## 1.0.1

- Add a version check to CI.

## 1.0.0

- Initial release.
