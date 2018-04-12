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

library tool.dev;

import 'dart:async';
import 'package:dart_dev/dart_dev.dart' show dev, config;
import 'package:dart_dev/util.dart' show TaskProcess, reporter;

Future<Null> main(List<String> args) async {
  // https://github.com/Workiva/dart_dev

  final directories = <String>['example/', 'lib/', 'tool/', 'test/'];

  config.analyze.entryPoints = <String>[
    'example/main.dart',
    'lib/sockjs_client_wrapper.dart',
    'tool/dev.dart',
    'test/sockjs_client_wrapper_test.dart',
  ];
  config.format.paths = directories;
  config.copyLicense.directories = directories;

  config.coverage
    ..before = <Function>[_startServer]
    ..after = <Function>[_stopServer]
    ..pubServe = true;
  config.test
    ..before = <Function>[_startServer]
    ..after = <Function>[_stopServer]
    ..unitTests = <String>['test/']
    ..platforms = <String>['chrome']
    ..pubServe = true;

  await dev(args);
}

/// Server needed for integration tests and examples.
TaskProcess _server;

/// Output from the server (only used if caching the output to dump at the end).
List<String> _serverOutput;

/// Start the server needed for integration tests and cache the server output
/// until the task requiring the server has finished. Then, the server output
/// will be dumped all at once.
Future<Null> _startServer() async {
  _serverOutput = <String>[];
  _server = new TaskProcess('node', ['tool/server.js']);
  _server.stdout.listen(_serverOutput.add);
  _server.stderr.listen(_serverOutput.add);
  // todo: wait for server to start
}

/// Stop the server needed for integration tests.
Future<Null> _stopServer() async {
  if (_serverOutput != null) {
    reporter.logGroup('HTTP Server Logs', output: _serverOutput.join('\n'));
  }
  if (_server != null) {
    try {
      _server.kill();
    } catch (_) {} // ignore: avoid_catches_without_on_clauses
  }
}
