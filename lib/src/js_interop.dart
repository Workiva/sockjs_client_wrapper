@JS()
library sockjs_client;

import 'package:js/js.dart';

/// Interface of the external `SockJS` object used for JS interop.
@JS()
class SockJS {
  /// Constructs a SockJS Client.
  external SockJS(String url, [Null _reserved, SockJSOptions options]);

  /// The state of the client.
  ///
  /// - 0: connecting
  /// - 1: open
  /// - 2: closing
  /// - 3: closed
  external int get readyState;

  /// The selected transport protocol.
  ///
  /// E.g. "websocket" or "xhr-polling".
  external String get transport;

  /// The URL of the server to which this client connected.
  external String get url;

  /// Adds an event listener for the given [eventName].
  ///
  /// Use this to listen for `open`, `close`, and `message` events.
  external void addEventListener(String eventName, Function callback);

  /// Closes this client.
  external void close([int closeCode, String reason]);

  /// Removes an event listener that was registered with [addEventListener].
  external void removeEventListener(String eventName, Function callback);

  /// Sends [data] to the server.
  external void send(String data);
}

/// Interface definition for the JS "close" event that is emitted from the
/// SockJS client.
@JS()
@anonymous
class SockJSCloseEvent {
  /// The close code.
  external int get code;

  /// The reason for closing.
  external String get reason;

  /// Whether or not the close was "clean".
  external bool get wasClean;
}

/// Interface definition for the JS "message" event that is emitted from the
/// SockJS client.
@JS()
@anonymous
class SockJSMessageEvent {
  /// The string payload for this message event.
  external String get data;
}

/// Interface definition for an anonymous JS object that represents
/// configuration for a SockJS Client.
@JS()
@anonymous
class SockJSOptions {
  /// Constructs an anonymous JS object with `server` and `transports` fields.
  ///
  /// Example:
  ///
  ///     {server: 'foo', transports: ['websocket', 'xhr-polling']}
  external factory SockJSOptions({String server, List<String> transports});

  /// String to append to url for actual data connection.
  ///
  /// Defaults to a random 4 digit number.
  external String get server;

  /// List of transports that may be used by SockJS.
  ///
  /// By default, all available transports will be used.
  external List<String> get transports;
}
