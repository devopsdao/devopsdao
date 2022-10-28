// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:webthree/webthree.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"nanoId","type":"string"},{"indexed":false,"internalType":"address","name":"jobAddress","type":"address"},{"indexed":false,"internalType":"address","name":"jobOwner","type":"address"},{"indexed":false,"internalType":"string","name":"title","type":"string"},{"indexed":false,"internalType":"string","name":"description","type":"string"},{"indexed":false,"internalType":"string","name":"symbol","type":"string"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"JobContractCreated","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"contractAdr","type":"address"},{"indexed":false,"internalType":"uint256","name":"index","type":"uint256"}],"name":"OneEventForAll","type":"event"},{"inputs":[],"name":"countNew","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true},{"inputs":[],"name":"gateway","outputs":[{"internalType":"contract IAxelarGateway","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"jobArray","outputs":[{"internalType":"contract Job","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true},{"inputs":[{"internalType":"string","name":"_nanoId","type":"string"},{"internalType":"string","name":"_title","type":"string"},{"internalType":"string","name":"_description","type":"string"},{"internalType":"string","name":"_symbol","type":"string"},{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"createJobContract","outputs":[],"stateMutability":"payable","type":"function","payable":true},{"inputs":[],"name":"allJobs","outputs":[{"internalType":"contract Job[]","name":"_jobs","type":"address[]"}],"stateMutability":"view","type":"function","constant":true},{"inputs":[{"internalType":"contract Job","name":"job","type":"address"}],"name":"jobParticipate","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"contract Job","name":"job","type":"address"}],"name":"jobAuditParticipate","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"contract Job","name":"job","type":"address"},{"internalType":"uint256","name":"_score","type":"uint256"}],"name":"jobRating","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"contract Job","name":"job","type":"address"},{"internalType":"address payable","name":"_participantAddress","type":"address"},{"internalType":"string","name":"_state","type":"string"}],"name":"jobStateChange","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"contract Job","name":"job","type":"address"},{"internalType":"string","name":"_favour","type":"string"}],"name":"jobAuditStateChange","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"contract Job","name":"job","type":"address"},{"internalType":"address payable","name":"addressToSend","type":"address"}],"name":"transferToaddress","outputs":[],"stateMutability":"payable","type":"function","payable":true},{"inputs":[{"internalType":"contract Job","name":"job","type":"address"},{"internalType":"address payable","name":"addressToSend","type":"address"},{"internalType":"string","name":"chain","type":"string"}],"name":"transferToaddressChain2","outputs":[],"stateMutability":"payable","type":"function","payable":true},{"inputs":[{"internalType":"uint256","name":"_classIndex","type":"uint256"}],"name":"getBalance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true},{"inputs":[{"internalType":"uint256","name":"_classIndex","type":"uint256"}],"name":"getJobInfo","outputs":[{"internalType":"string","name":"","type":"string"},{"internalType":"string","name":"","type":"string"},{"internalType":"address","name":"","type":"address"},{"internalType":"address","name":"","type":"address"},{"internalType":"address","name":"","type":"address"},{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"string","name":"","type":"string"},{"internalType":"address[]","name":"","type":"address[]"},{"internalType":"address","name":"","type":"address"},{"internalType":"string","name":"","type":"string"},{"internalType":"string","name":"","type":"string"},{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"address[]","name":"","type":"address[]"},{"internalType":"string","name":"","type":"string"},{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true}]',
  'Factory',
);

class Factory extends _i1.GeneratedContract {
  Factory({
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

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> countNew({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, 'd69a588e'));
    final params = [];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
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
  Future<_i1.EthereumAddress> jobArray(
    BigInt $param0, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, '8c7bf1a7'));
    final params = [$param0];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as _i1.EthereumAddress);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> createJobContract(
    String _nanoId,
    String _title,
    String _description,
    String _symbol,
    BigInt _amount, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, '7f7d7e6c'));
    final params = [
      _nanoId,
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
  Future<List<_i1.EthereumAddress>> allJobs({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, 'c8d1b6aa'));
    final params = [];
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
  Future<String> jobParticipate(
    _i1.EthereumAddress job, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, 'fcd3f196'));
    final params = [job];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> jobAuditParticipate(
    _i1.EthereumAddress job, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, '8398eff8'));
    final params = [job];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> jobRating(
    _i1.EthereumAddress job,
    BigInt _score, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[8];
    assert(checkSignature(function, '1f04dbc0'));
    final params = [
      job,
      _score,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> jobStateChange(
    _i1.EthereumAddress job,
    _i1.EthereumAddress _participantAddress,
    String _state, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[9];
    assert(checkSignature(function, '527ded4d'));
    final params = [
      job,
      _participantAddress,
      _state,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> jobAuditStateChange(
    _i1.EthereumAddress job,
    String _favour, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[10];
    assert(checkSignature(function, '606f7072'));
    final params = [
      job,
      _favour,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> transferToaddress(
    _i1.EthereumAddress job,
    _i1.EthereumAddress addressToSend, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[11];
    assert(checkSignature(function, '437a4f14'));
    final params = [
      job,
      addressToSend,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> transferToaddressChain2(
    _i1.EthereumAddress job,
    _i1.EthereumAddress addressToSend,
    String chain, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[12];
    assert(checkSignature(function, 'a7e595b8'));
    final params = [
      job,
      addressToSend,
      chain,
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
  Future<BigInt> getBalance(
    BigInt _classIndex, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[13];
    assert(checkSignature(function, '1e010439'));
    final params = [_classIndex];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<GetJobInfo> getJobInfo(
    BigInt _classIndex, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[14];
    assert(checkSignature(function, '7f4497d8'));
    final params = [_classIndex];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return GetJobInfo(response);
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

  /// Returns a live stream of all OneEventForAll events emitted by this contract.
  Stream<OneEventForAll> oneEventForAllEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('OneEventForAll');
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
      return OneEventForAll(decoded);
    });
  }
}

class GetJobInfo {
  GetJobInfo(List<dynamic> response)
      : var1 = (response[0] as String),
        var2 = (response[1] as String),
        var3 = (response[2] as _i1.EthereumAddress),
        var4 = (response[3] as _i1.EthereumAddress),
        var5 = (response[4] as _i1.EthereumAddress),
        var6 = (response[5] as BigInt),
        var7 = (response[6] as BigInt),
        var8 = (response[7] as String),
        var9 = (response[8] as List<dynamic>).cast<_i1.EthereumAddress>(),
        var10 = (response[9] as _i1.EthereumAddress),
        var11 = (response[10] as String),
        var12 = (response[11] as String),
        var13 = (response[12] as BigInt),
        var14 = (response[13] as List<dynamic>).cast<_i1.EthereumAddress>(),
        var15 = (response[14] as String),
        var16 = (response[15] as _i1.EthereumAddress);

  final String var1;

  final String var2;

  final _i1.EthereumAddress var3;

  final _i1.EthereumAddress var4;

  final _i1.EthereumAddress var5;

  final BigInt var6;

  final BigInt var7;

  final String var8;

  final List<_i1.EthereumAddress> var9;

  final _i1.EthereumAddress var10;

  final String var11;

  final String var12;

  final BigInt var13;

  final List<_i1.EthereumAddress> var14;

  final String var15;

  final _i1.EthereumAddress var16;
}

class JobContractCreated {
  JobContractCreated(List<dynamic> response)
      : nanoId = (response[0] as String),
        jobAddress = (response[1] as _i1.EthereumAddress),
        jobOwner = (response[2] as _i1.EthereumAddress),
        title = (response[3] as String),
        description = (response[4] as String),
        symbol = (response[5] as String),
        amount = (response[6] as BigInt);

  final String nanoId;

  final _i1.EthereumAddress jobAddress;

  final _i1.EthereumAddress jobOwner;

  final String title;

  final String description;

  final String symbol;

  final BigInt amount;
}

class OneEventForAll {
  OneEventForAll(List<dynamic> response)
      : contractAdr = (response[0] as _i1.EthereumAddress),
        index = (response[1] as BigInt);

  final _i1.EthereumAddress contractAdr;

  final BigInt index;
}
