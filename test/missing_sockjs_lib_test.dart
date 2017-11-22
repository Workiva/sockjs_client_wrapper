@TestOn('browser')
library sockjs_client.test.sockjs_client_test;

import 'package:sockjs_client_wrapper/sockjs_client_wrapper.dart';
import 'package:test/test.dart';

import 'package:sockjs_client_wrapper/src/client.dart';

void main() {
  test(
      'new SockJSClient() should throw a MissingSockJSLibError when the '
      'sockjs.js library is missing', () {
    expect(() => new SockJSClient(Uri.parse('http://localhost:8000/echo')),
        throwsA(const isInstanceOf<MissingSockJSLibError>()));
  });
}
