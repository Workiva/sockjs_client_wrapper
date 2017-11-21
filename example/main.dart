import 'dart:async';

import 'package:sockjs_client_wrapper/sockjs_client_wrapper.dart';

Future<Null> main() async {
  print('Starting example');
  final echoUri = Uri.parse('http://localhost:9999/echo');
  final options = new SockJSOptions(
      transports: ['websocket', 'xhr-streaming', 'xhr-polling']);
  final socket = new SockJSClient(echoUri, options: options);

  socket.onOpen.listen((event) {
    print('OPEN: ${event.transport} ${event.url}');
  });

  socket.onMessage.listen((event) {
    print('MSG: ${event.data}');
  });

  socket.onClose.listen((event) {
    print('CLOSE: ${event.code} ${event.reason} (wasClean ${event.wasClean})');
  });

  await new Future<Null>.delayed(const Duration(milliseconds: 500));
  socket.send('test');

  await new Future<Null>.delayed(const Duration(milliseconds: 500));
  socket.send('test 2');

  await new Future<Null>.delayed(const Duration(seconds: 5));

  socket.close(4002);
}
