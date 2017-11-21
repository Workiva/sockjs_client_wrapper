import 'dart:async';

import 'dart:js';

import 'package:js/js.dart';
import 'package:logging/logging.dart';
import 'package:w_common/disposable_browser.dart';

import 'package:sockjs_client_wrapper/src/events.dart';
import 'package:sockjs_client_wrapper/src/js_interop.dart' as js_interop;

/// A SockJS Client that acts and looks like a browser WebSocket object.
///
/// See https://github.com/sockjs/sockjs-client for more information on SockJS
/// in general.
///
/// All of the SockJS implementation logic lives in the native SockJS library.
/// This [SockJSClient] class is simply a wrapper that provides a typed API
/// accessible from Dart.
class SockJSClient extends Disposable {
  // The native SockJS client object.
  final js_interop.SockJS _jsClient;

  final _logger = new Logger('SockJSClient');

  // Event stream controllers.
  final StreamController<SockJSCloseEvent> _onCloseController =
      new StreamController<SockJSCloseEvent>.broadcast();
  final StreamController<SockJSMessageEvent> _onMessageController =
      new StreamController<SockJSMessageEvent>.broadcast();
  final StreamController<SockJSOpenEvent> _onOpenController =
      new StreamController<SockJSOpenEvent>.broadcast();

  /// Constructs a new [SockJSClient] that will attempt to connect to a SockJS
  /// server at the given [uri].
  ///
  /// Additional configuration can be provided via [options]:
  ///
  /// - `SockJSOptions.server` - string to append to url for actual data
  ///    connection. Defaults to a random 4 digit number.
  /// - `SockJSOptions.transports` - list of transports that may be used by
  ///   SockJS. By default, all available transports will be used.
  ///
  /// For example, the following would create a client with a whitelist of three
  /// transport protocols:
  ///
  ///     final uri = Uri.parse('ws://example.org/echo');
  ///     final options = new SockJSOptions(
  ///         transports: ['websocket', 'xhr-streaming', 'xhr-polling']);
  ///     final client = new SockJSClient(uri, options: options);
  SockJSClient(Uri uri, {SockJSOptions options})
      : _jsClient =
            new js_interop.SockJS(uri.toString(), null, options?._toJs()) {
    manageStreamController(_onCloseController);
    manageStreamController(_onMessageController);
    manageStreamController(_onOpenController);

    _addManagedEventListenerToJSClient('close', _onClose);
    _addManagedEventListenerToJSClient('message', _onMessage);
    _addManagedEventListenerToJSClient('open', _onOpen);

    // Automatically dispose if this client closes. If this close event is
    // emitted in response to a call to dispose(), then this will effectively be
    // a no-op.
    listenToStream<SockJSCloseEvent>(onClose, (_) => dispose());
  }

  /// A stream that can be listened to in order to know when this SockJS Client
  /// has closed.
  ///
  /// Only a single [SockJSCloseEvent] will be emitted from this stream.
  ///
  /// The event will include the close code and reason, if available.
  Stream<SockJSCloseEvent> get onClose => _onCloseController.stream;

  /// A stream of message events received from the server.
  ///
  /// Each [SockJSMessageEvent] will include the [String] payload.
  Stream<SockJSMessageEvent> get onMessage => _onMessageController.stream;

  /// A stream that can be listened to in order to know when this SockJS Client
  /// has successfully connected to the server.
  ///
  /// Only a single [SockJSOpenEvent] will be emitted from this stream unless a
  /// connection cannot be made, in which case no events will be emitted at all.
  ///
  /// The event will include the selected transport as well as the server URL.
  Stream<SockJSOpenEvent> get onOpen => _onOpenController.stream;

  /// Close this client.
  ///
  /// Optionally, a [closeCode] and [reason] can be provided.
  void close([int closeCode, String reason]) {
    _logger.fine([
      'close()',
      'code: $closeCode',
      'reason: $reason',
    ].join('\n\t'));
    _jsClient.close(closeCode, reason);
  }

  /// Send data to the server.
  void send(String data) {
    _logger.fine([
      'send()',
      'data: $data',
    ].join('\n\t'));
    _jsClient.send(data);
  }

  @override
  Future<Null> onWillDispose() async {
    // If the client is already closed, there is nothing to do.
    if (_jsClient.readyState == 3 /* closed */) {
      return;
    }

    // Close this client. If already closing, this will be a no-op.
    close();

    // Wait for the event to be emitted on the `onClose` stream. This ensures
    // that the underlying StreamController is not disposed too early.
    await onClose.first;
  }

  void _addManagedEventListenerToJSClient(String eventName, Function callback) {
    final interopAllowedCallback = allowInterop(callback);
    _jsClient.addEventListener(eventName, interopAllowedCallback);
    getManagedDisposer(() {
      _jsClient.removeEventListener(eventName, interopAllowedCallback);
    });
  }

  void _onClose(js_interop.SockJSCloseEvent event) {
    _logger.fine([
      'onClose event converted',
      'code: ${event.code}',
      'reason: ${event.reason}',
      'wasClean: ${event.wasClean}',
    ].join('\n\t'));
    _onCloseController.add(new SockJSCloseEvent(
        // ignore: avoid_as
        event.code,
        // ignore: avoid_as
        event.reason,
        // ignore: avoid_as
        wasClean: event.wasClean));
  }

  void _onMessage(js_interop.SockJSMessageEvent event) {
    _logger.fine([
      'onMessage event converted',
      'data: ${event.data}',
    ].join('\n\t'));
    // ignore: avoid_as
    _onMessageController.add(new SockJSMessageEvent(event.data));
  }

  void _onOpen(dynamic _) {
    _logger.fine([
      'onOpen event received',
      'transport: ${_jsClient.transport}',
      'url: ${Uri.parse(_jsClient.url)}',
    ].join('\n\t'));
    _onOpenController.add(
        new SockJSOpenEvent(_jsClient.transport, Uri.parse(_jsClient.url)));
  }
}

/// A configuration object to be used when constructing a [SockJSClient].
class SockJSOptions {
  /// String to append to url for actual data connection.
  ///
  /// Defaults to a random 4 digit number.
  final String server;

  /// A list of transports that may be used by SockJS.
  ///
  /// By default, all available transports will be used. Specifying a whitelist
  /// can be useful if you need to disable certain fallback transports.
  final List<String> transports;

  final _logger = new Logger('SockJSOptions');

  /// Construct a [SockJSOptions] instance to be passed to the [SockJSClient]
  /// constructor.
  SockJSOptions({this.server, this.transports});

  js_interop.SockJSOptions _toJs() {
    _logger.fine([
        'transforming for JS interop',
        'server: $server',
        'transports: $transports',
    ].join('\n\t'));
    return new js_interop.SockJSOptions(server: server, transports: transports);
  }
}
