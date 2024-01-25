import 'dart:async';
import 'package:webthree/credentials.dart';
import '../../blockchain/classes.dart';

class TaskUpdateService {
  static EthereumAddress _openedTaskAddress = EthereumAddress.fromHex('0x0000000000000000000000000000000000000000');

  static final StreamController<EthereumAddress> _controller = StreamController<EthereumAddress>.broadcast();
  Stream<EthereumAddress> get taskItems => _controller.stream.asBroadcastStream();

  void saveOpenedTaskAddress(taskAddress) {
      _openedTaskAddress = taskAddress;
  }

  Future<void> initCheckingOpenedTask(EthereumAddress taskAddress) async {
    if (taskAddress == _openedTaskAddress) {
      _controller.add(taskAddress);
      return;
    }
  }
}