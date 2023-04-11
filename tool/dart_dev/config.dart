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

import 'package:dart_dev/dart_dev.dart';

final Map<String, DevTool> config = {
  ...coreConfig,
  'format': FormatTool()..formatter = Formatter.dartFormat,
  'test': CompoundTool()
    ..addTool(_testServer.starter, alwaysRun: true)
    ..addTool(TestTool(), argMapper: takeAllArgs)
    ..addTool(_testServer.stopper, alwaysRun: true),
  'serve': CompoundTool()
    ..addTool(_exampleServer.starter, alwaysRun: true)
    ..addTool(WebdevServeTool()..webdevArgs = ['example:8080'])
    ..addTool(_exampleServer.stopper, alwaysRun: true),
};

final _exampleServer = ProcessTool('node', ['example/server.js'])
    .backgrounded(startAfterDelay: Duration(seconds: 2));
final _testServer = ProcessTool('node', ['tool/server.js'])
    .backgrounded(startAfterDelay: Duration(seconds: 2));
