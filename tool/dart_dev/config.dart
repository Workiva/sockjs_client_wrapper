// Copyright 2019 Workiva Inc.
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
import 'dart:io';

import 'package:dart_dev/dart_dev.dart';

final config = {
  ...coreConfig,
  'format': FormatTool()..formatter = Formatter.dartFormat,
  'test': CompoundTool()
    ..addTool(DevTool.fromFunction(startTestServer), alwaysRun: true)
    ..addTool(TestTool(), argMapper: takeAllArgs)
    ..addTool(DevTool.fromFunction(stopTestServer), alwaysRun: true),
  'serve': CompoundTool()
    ..addTool(DevTool.fromFunction(startExampleServer), alwaysRun: true)
    ..addTool(WebdevServeTool()..webdevArgs = ['example:8080'])
    ..addTool(DevTool.fromFunction(stopExampleServer), alwaysRun: true),
};

Process _exampleServer;
Process _testServer;

Future<int> startExampleServer(DevToolExecutionContext _) async {
  _exampleServer = await Process.start('node', ['example/server.js'],
      mode: ProcessStartMode.inheritStdio);
  return firstOf([
    // Exit early if it fails to start,
    _exampleServer.exitCode,
    // otherwise just wait a little bit to ensure it starts up completely.
    Future.delayed(Duration(seconds: 2)).then((_) => 0),
  ]);
}

Future<int> stopExampleServer(DevToolExecutionContext _) async {
  _exampleServer?.kill();
  await _exampleServer.exitCode;
  return 0;
}

Future<int> startTestServer(DevToolExecutionContext _) async {
  _testServer = await Process.start('node', ['tool/server.js'],
      mode: ProcessStartMode.inheritStdio);
  return firstOf([
    // Exit early if it fails to start,
    _testServer.exitCode,
    // otherwise just wait a little bit to ensure it starts up completely.
    Future.delayed(Duration(seconds: 2)).then((_) => 0),
  ]);
}

Future<int> stopTestServer(DevToolExecutionContext _) async {
  _testServer?.kill();
  await _testServer.exitCode;
  return 0;
}

Future<T> firstOf<T>(Iterable<Future<T>> futures) {
  final c = Completer<T>();
  for (final future in futures) {
    future.then((v) {
      if (!c.isCompleted) {
        c.complete(v);
      }
    }).catchError(c.completeError);
  }
  return c.future;
}
