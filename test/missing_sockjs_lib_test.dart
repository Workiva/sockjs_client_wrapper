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

@TestOn('browser')
library sockjs_client.test.sockjs_client_test;

import 'package:sockjs_client_wrapper/sockjs_client_wrapper.dart';
import 'package:test/test.dart';

import 'package:sockjs_client_wrapper/src/client.dart';

void main() {
  test(
      'new SockJSClient() should throw a MissingSockJSLibError when the '
      'sockjs.js library is missing', () {
    expect(() => SockJSClient(Uri.parse('http://localhost:8000/echo')),
        throwsA(isA<MissingSockJSLibError>()));
  });
}
