// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:webthree/webthree.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"nanoId","type":"string"},{"indexed":false,"internalType":"address","name":"taskAddress","type":"address"},{"indexed":false,"internalType":"address","name":"taskOwner","type":"address"},{"indexed":false,"internalType":"string","name":"title","type":"string"},{"indexed":false,"internalType":"string","name":"description","type":"string"},{"indexed":false,"internalType":"string","name":"symbol","type":"string"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"JobContractCreated","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"contractAdr","type":"address"},{"indexed":false,"internalType":"string","name":"message","type":"string"},{"indexed":false,"internalType":"uint256","name":"timestamp","type":"uint256"}],"name":"TaskCreated","type":"event"},{"inputs":[{"internalType":"string","name":"_nanoId","type":"string"},{"internalType":"string","name":"_taskType","type":"string"},{"internalType":"string","name":"_title","type":"string"},{"internalType":"string","name":"_description","type":"string"},{"internalType":"string","name":"_symbol","type":"string"},{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"createTaskContract","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"gateway","outputs":[{"internalType":"contract IAxelarGateway","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getTaskContracts","outputs":[{"internalType":"address[]","name":"","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"string","name":"_taskState","type":"string"}],"name":"getTaskContractsbyState","outputs":[{"internalType":"address[]","name":"","type":"address[]"}],"stateMutability":"view","type":"function"}]',
  'TasksFacet',
);

class TasksFacet extends _i1.GeneratedContract {
  TasksFacet({
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
  Future<String> createTaskContract(
    String _nanoId,
    String _taskType,
    String _title,
    String _description,
    String _symbol,
    BigInt _amount, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, 'd06d6da4'));
    final params = [
      _nanoId,
      _taskType,
      _title,
      _description,
      _symbol,
      _amount,
    ];
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
  Future<_i1.EthereumAddress> gateway({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, '116191b6'));
    final params = [];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as _i1.EthereumAddress);
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
  Future<List<_i1.EthereumAddress>> getTaskContractsbyState(
    String _taskState, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, 'bbb0062d'));
    final params = [_taskState];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<_i1.EthereumAddress>();
  }

  /// Returns a live stream of all JobContractCreated events emitted by this contract.
  Stream<JobContractCreated> jobContractCreatedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('JobContractCreated');
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
      return JobContractCreated(decoded);
    });
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

class JobContractCreated {
  JobContractCreated(List<dynamic> response)
      : nanoId = (response[0] as String),
        taskAddress = (response[1] as _i1.EthereumAddress),
        taskOwner = (response[2] as _i1.EthereumAddress),
        title = (response[3] as String),
        description = (response[4] as String),
        symbol = (response[5] as String),
        amount = (response[6] as BigInt);

  final String nanoId;

  final _i1.EthereumAddress taskAddress;

  final _i1.EthereumAddress taskOwner;

  final String title;

  final String description;

  final String symbol;

  final BigInt amount;
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
