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

/// Base event that all SockJS events extend from.
class SockJSEvent {
  /// Event type (e.g. "open").
  final String type;

  SockJSEvent._(this.type);
}

/// Event that represents the closing of a SockJS Client.
class SockJSCloseEvent extends SockJSEvent {
  /// Close code, if provided.
  final int code;

  /// Reason for closing, if provided.
  final String reason;

  /// Whether or not the close was "clean".
  final bool wasClean;

  /// Constructs a [SockJSCloseEvent].
  SockJSCloseEvent(this.code, this.reason, {this.wasClean}) : super._('close');
}

/// Event that represents a message received by a SockJS Client from the server.
class SockJSMessageEvent extends SockJSEvent {
  /// Message payload.
  final String data;

  /// Constructs a [SockJSMessageEvent].
  SockJSMessageEvent(this.data) : super._('message');
}

/// Event that represents the opening (successful connection) of a SockJS
/// Client to the server.
class SockJSOpenEvent extends SockJSEvent {
  /// The transport that was used to successfully connect to the server.
  ///
  /// E.g. "websocket" or "xhr-polling".
  final String transport;

  /// The URL of the server to which the SockJS Client connected.
  final Uri url;

  /// Constructs a [SockJSOpenEvent].
  SockJSOpenEvent(this.transport, this.url) : super._('open');
}
