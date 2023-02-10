// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:webthree/webthree.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"contractAdr","type":"address"},{"indexed":false,"internalType":"string","name":"message","type":"string"},{"indexed":false,"internalType":"uint256","name":"timestamp","type":"uint256"}],"name":"TaskCreated","type":"event"},{"inputs":[{"internalType":"address","name":"taskAddress","type":"address"}],"name":"addTaskToBlacklist","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address[]","name":"accountAddresses","type":"address[]"}],"name":"getAccountData","outputs":[{"components":[{"internalType":"address","name":"accountOwner","type":"address"},{"internalType":"uint256","name":"customerTaskCount","type":"uint256"},{"internalType":"uint256","name":"performerTaskCount","type":"uint256"}],"internalType":"struct Account[]","name":"","type":"tuple[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getAccounts","outputs":[{"internalType":"address[]","name":"","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getTaskContracts","outputs":[{"internalType":"address[]","name":"","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"string","name":"_taskState","type":"string"}],"name":"getTaskContractsByState","outputs":[{"internalType":"address[]","name":"","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"contractOwner","type":"address"}],"name":"getTaskContractsCustomer","outputs":[{"internalType":"address[]","name":"","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"participant","type":"address"}],"name":"getTaskContractsPerformer","outputs":[{"internalType":"address[]","name":"","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"taskAddress","type":"address"}],"name":"removeTaskFromBlacklist","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
  'TaskDataFacet',
);

class TaskDataFacet extends _i1.GeneratedContract {
  TaskDataFacet({
    required _i1.EthereumAddress address,
    required _i1.Web3Client client,
    int? chainId,
  }) : super(
          _i1.DeployedContract(
            _contractAbi,
            address,
          ),
          client,
          chainId,
        );

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> addTaskToBlacklist(
    _i1.EthereumAddress taskAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, '7267a186'));
    final params = [taskAddress];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<dynamic>> getAccountData(
    List<_i1.EthereumAddress> accountAddresses, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, 'b597f75b'));
    final params = [accountAddresses];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<dynamic>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<_i1.EthereumAddress>> getAccounts({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, '8a48ac03'));
    final params = [];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<_i1.EthereumAddress>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<_i1.EthereumAddress>> getTaskContracts({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, 'bbd63456'));
    final params = [];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<_i1.EthereumAddress>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<_i1.EthereumAddress>> getTaskContractsByState(
    String _taskState, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, 'cd8ac8df'));
    final params = [_taskState];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<_i1.EthereumAddress>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<_i1.EthereumAddress>> getTaskContractsCustomer(
    _i1.EthereumAddress contractOwner, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, 'edd2f344'));
    final params = [contractOwner];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<_i1.EthereumAddress>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<_i1.EthereumAddress>> getTaskContractsPerformer(
    _i1.EthereumAddress participant, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, 'eb82e900'));
    final params = [participant];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<_i1.EthereumAddress>();
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> removeTaskFromBlacklist(
    _i1.EthereumAddress taskAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, '4f56bf4b'));
    final params = [taskAddress];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// Returns a live stream of all TaskCreated events emitted by this contract.
  Stream<TaskCreated> taskCreatedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('TaskCreated');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return TaskCreated(decoded);
    });
  }
}

class TaskCreated {
  TaskCreated(List<dynamic> response)
      : contractAdr = (response[0] as _i1.EthereumAddress),
        message = (response[1] as String),
        timestamp = (response[2] as BigInt);

  final _i1.EthereumAddress contractAdr;

  final String message;

  final BigInt timestamp;
}
