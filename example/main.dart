// Copyright 2017 Workiva Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';

import 'package:sockjs_client_wrapper/sockjs_client_wrapper.dart';

Future<Null> main() async {
  print('Starting example');
  final echoUri = Uri.parse('http://localhost:9009/echo');
  final options = SockJSOptions(
      transports: ['websocket', 'xhr-streaming', 'xhr-polling'], timeout: 5000);
  final socket = SockJSClient(echoUri, options: options);

  socket.onOpen.listen((event) {
    print('OPEN: ${event.transport} ${event.url} ${event.debugUrl}');
  });

  socket.onMessage.listen((event) {
    print('MSG: ${event.data}');
  });

  socket.onClose.listen((event) {
    print('CLOSE: ${event.code} ${event.reason} (wasClean ${event.wasClean})');
  });

  await Future<Null>.delayed(const Duration(milliseconds: 500));
  socket.send('test');

  await Future<Null>.delayed(const Duration(milliseconds: 500));
  socket.send('test 2');

  await Future<Null>.delayed(const Duration(seconds: 5));

  socket.close(4002);
}
