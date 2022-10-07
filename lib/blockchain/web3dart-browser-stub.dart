import 'dart:ffi';
// import "package:universal_html/html.dart" hide Platform;
import "package:universal_html/html.dart";

// import 'package:js/js.dart';
// import 'package:meta/meta.dart';

import 'dart:async';

// import 'package:js/js.dart';
// import 'package:js/js_util.dart';

// import 'package:web3dart/credentials.dart';
import 'package:web3dart/json_rpc.dart';
// import 'package:web3dart/src/browser/credentials.dart';
// import 'package:web3dart/src/browser/javascript.dart';

extension GetEthereum on Window {
  /// Loads the ethereum instance provided by the browser.
  ///
  /// For more information on how to use this object with the web3dart package,
  /// see the methods on [DartEthereum].
  Ethereum? get ethereum => null;
}

extension DartEthereum on Ethereum {
  /// Turns this raw client into an rpc client that can be used to create a
  /// `Web3Client`:
  ///
  /// ```dart
  /// Future<void> main() async {
  ///   final eth = window.ethereum;
  ///   if (eth == null) {
  ///     print('MetaMask is not available');
  ///     return;
  ///   }
  ///
  ///   final client = Web3Client.custom(eth.asRpcService());
  /// }
  /// ```
  RpcService asRpcService() => _MetaMaskRpcService(this);

  /// Sends a raw rpc request using the injected Ethereum client.
  ///
  /// If possible, prefer using [asRpcService] to construct a high-level client
  /// instead.
  ///
  /// See also:
  ///  - the rpc documentation under https://docs.metamask.io/guide/rpc-api.html
  Future<dynamic> rawRequest(String method, {Object? params}) {
    // No, this can't be simplified. Metamask wants `params` to be undefined.
    throw (Error);
  }

  /// Asks the user to select an account and give your application access to it.
  Future<dynamic> requestAccount() {
    throw (Error);
  }

  /// Creates a stream of raw ethereum events.
  ///
  /// The returned stream is a broadcast stream, meaning that it can be listened
  /// to multiple times.
  ///
  /// See also:
  ///  - https://docs.metamask.io/guide/ethereum-provider.html#events
  Stream<dynamic> stream(String eventName) {
    throw (Error);
  }

  /// A broadcast stream emitting values when the selected chain is changed by
  /// the user.
  Stream<int> get chainChanged => stream('chainChanged').cast();
}

class _MetaMaskRpcService extends RpcService {
  final Ethereum _ethereum;

  _MetaMaskRpcService(this._ethereum);

  @override
  Future<RPCResponse> call(String function, [List? params]) {
    throw (Error);
  }
}

class _EventStream extends Stream<dynamic> {
  final Ethereum _client;
  final String _eventName;

  _EventStream(this._client, this._eventName);

  @override
  bool get isBroadcast => true;

  @override
  Stream asBroadcastStream(
      {void Function(StreamSubscription subscription)? onListen,
      void Function(StreamSubscription subscription)? onCancel}) {
    return this;
  }

  @override
  StreamSubscription listen(void Function(dynamic event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    final sub = _EventStreamSubscription(_client, _eventName, onData);
    // onError, onDone and cancelOnErrors are not applicable here because event
    // streams are infinite and don't transport errors.
    return sub;
  }
}

class _EventStreamSubscription extends StreamSubscription<dynamic> {
  final Ethereum _client;
  final String _eventName;
  Function(dynamic)? _onData;

  Function? _jsCallback;
  int _activePauseRequests = 0;
  bool _isCancelled = false;

  _EventStreamSubscription(
      this._client, this._eventName, Function(dynamic)? onData) {}

  @override
  Future<E> asFuture<E>([E? futureValue]) {
    throw (Error);
  }

  @override
  Future<void> cancel() {
    throw (Error);
  }

  @override
  bool get isPaused => _activePauseRequests > 0;

  @override
  void onData(void Function(dynamic data)? handleData) {}

  @override
  void onDone(void Function()? handleDone) {
    // Nothing to do, event streams are never done
  }

  @override
  void onError(Function? handleError) {
    // Nothing to do, event streams don't emit errors
  }

  @override
  void pause([Future<void>? resumeSignal]) {}

  @override
  void resume() {}

  void _resumeIfNecessary() {}

  void _stopListening() {}
}

class Ethereum {}
