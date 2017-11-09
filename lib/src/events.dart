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
