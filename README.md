# SockJS Client Wrapper

A Dart wrapper around the [SockJS Client][sockjs-client]. Uses the
[`js` Dart package][js-dart-package] to interop with the JS lib.

## Usage

Include the SockJS library in your app's `index.html` prior to the main Dart/JS
script:

```html
<!DOCTYPE html>
<html>
  <head> ... </head>
  <body>
    <!-- For local dev/debugging, use the unminified version: -->
    <script src="/packages/sockjs_client_wrapper/sockjs.js"></script>

    <!-- In production, use the minified version:  -->
    <script src="/packages/sockjs_client_wrapper/sockjs_prod.js"></script>
  </body>
</html>
```

Import `package:sockjs_client_wrapper/sockjs_client_wrapper.dart` and create a
`SockJSClient` instance that will connect to a SockJS server:

```dart
import 'package:sockjs_client_wrapper/sockjs_client_wrapper.dart';

Future<Null> main() async {
  final client = new SockJSClient(Uri.parse('ws://localhost:9000/echo'));
  await client.onOpen.first;
  client.send('Hello!');
  ...
}
```

## Development

**To install dependencies:**
```bash
$ npm install
$ pub get
```

**To run the example:**
```bash
$ node example/server.js
```

```bash
$ pub serve example
```

**To run tests:**
```bash
$ pub run ddev test
```


[js-dart-package]: https://pub.dartlang.org/packages/js
[sockjs-client]: https://github.com/sockjs/sockjs-client
