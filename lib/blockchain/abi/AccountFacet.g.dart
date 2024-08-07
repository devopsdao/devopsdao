// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:webthree/webthree.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"ownerAddr","type":"address"},{"indexed":false,"internalType":"string","name":"message","type":"string"},{"indexed":false,"internalType":"uint256","name":"timestamp","type":"uint256"}],"name":"AccountCreated","type":"event"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"string","name":"identity","type":"string"},{"internalType":"string","name":"about","type":"string"}],"name":"addAccountData","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"accountAddress","type":"address"}],"name":"addAccountToBlacklist","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_performer","type":"address"},{"internalType":"address","name":"taskAddress","type":"address"}],"name":"addAgreedTask","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"taskAddress","type":"address"}],"name":"addAuditAgreedTask","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"taskAddress","type":"address"}],"name":"addAuditCompletedTask","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"taskAddress","type":"address"}],"name":"addAuditParticipantTask","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_performer","type":"address"},{"internalType":"address","name":"_customer","type":"address"},{"internalType":"address","name":"taskAddress","type":"address"}],"name":"addCompletedTask","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"taskAddress","type":"address"}],"name":"addCustomerAgreedTask","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"taskAddress","type":"address"}],"name":"addCustomerAuditedTask","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"taskAddress","type":"address"}],"name":"addCustomerCompletedTask","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"customer","type":"address"},{"internalType":"string[]","name":"tokenNames","type":"string[]"},{"internalType":"uint256[]","name":"tokenBalances","type":"uint256[]"}],"name":"addCustomerEarnedTokens","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_account","type":"address"},{"internalType":"address","name":"taskAddress","type":"address"},{"internalType":"uint256","name":"rating","type":"uint256"}],"name":"addCustomerRating","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"customer","type":"address"},{"internalType":"string[]","name":"tokenNames","type":"string[]"},{"internalType":"uint256[]","name":"tokenBalances","type":"uint256[]"}],"name":"addCustomerSpentTokens","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"taskAddress","type":"address"}],"name":"addParticipantTask","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"taskAddress","type":"address"}],"name":"addPerformerAgreedTask","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"taskAddress","type":"address"}],"name":"addPerformerAuditedTask","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"taskAddress","type":"address"}],"name":"addPerformerCompletedTask","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"performer","type":"address"},{"internalType":"string[]","name":"tokenNames","type":"string[]"},{"internalType":"uint256[]","name":"tokenBalances","type":"uint256[]"}],"name":"addPerformerEarnedTokens","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_account","type":"address"},{"internalType":"address","name":"taskAddress","type":"address"},{"internalType":"uint256","name":"rating","type":"uint256"}],"name":"addPerformerRating","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"performer","type":"address"},{"internalType":"string[]","name":"tokenNames","type":"string[]"},{"internalType":"uint256[]","name":"tokenBalances","type":"uint256[]"}],"name":"addPerformerSpentTokens","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"contractAccountFacet","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"accountAddress","type":"address"}],"name":"removeAccountFromBlacklist","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
  'AccountFacet',
);

class AccountFacet extends _i1.GeneratedContract {
  AccountFacet({
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
  Future<String> addAccountData(
    _i1.EthereumAddress _sender,
    String identity,
    String about, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, '56fd9644'));
    final params = [
      _sender,
      identity,
      about,
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
  Future<String> addAccountToBlacklist(
    _i1.EthereumAddress accountAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '08f99714'));
    final params = [accountAddress];
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
  Future<String> addAgreedTask(
    _i1.EthereumAddress _performer,
    _i1.EthereumAddress taskAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, 'a543bc4b'));
    final params = [
      _performer,
      taskAddress,
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
  Future<String> addAuditAgreedTask(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress taskAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, '4401d409'));
    final params = [
      _sender,
      taskAddress,
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
  Future<String> addAuditCompletedTask(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress taskAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, 'fedb41e2'));
    final params = [
      _sender,
      taskAddress,
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
  Future<String> addAuditParticipantTask(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress taskAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, '402bdf6e'));
    final params = [
      _sender,
      taskAddress,
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
  Future<String> addCompletedTask(
    _i1.EthereumAddress _performer,
    _i1.EthereumAddress _customer,
    _i1.EthereumAddress taskAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, '21f753fa'));
    final params = [
      _performer,
      _customer,
      taskAddress,
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
  Future<String> addCustomerAgreedTask(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress taskAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, 'cd6a7e91'));
    final params = [
      _sender,
      taskAddress,
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
  Future<String> addCustomerAuditedTask(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress taskAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[8];
    assert(checkSignature(function, '1819f275'));
    final params = [
      _sender,
      taskAddress,
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
  Future<String> addCustomerCompletedTask(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress taskAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[9];
    assert(checkSignature(function, 'c23e3be0'));
    final params = [
      _sender,
      taskAddress,
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
  Future<String> addCustomerEarnedTokens(
    _i1.EthereumAddress customer,
    List<String> tokenNames,
    List<BigInt> tokenBalances, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[10];
    assert(checkSignature(function, 'c30081f4'));
    final params = [
      customer,
      tokenNames,
      tokenBalances,
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
  Future<String> addCustomerRating(
    _i1.EthereumAddress _account,
    _i1.EthereumAddress taskAddress,
    BigInt rating, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[11];
    assert(checkSignature(function, '4bc27b63'));
    final params = [
      _account,
      taskAddress,
      rating,
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
  Future<String> addCustomerSpentTokens(
    _i1.EthereumAddress customer,
    List<String> tokenNames,
    List<BigInt> tokenBalances, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[12];
    assert(checkSignature(function, 'fee61bea'));
    final params = [
      customer,
      tokenNames,
      tokenBalances,
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
  Future<String> addParticipantTask(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress taskAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[13];
    assert(checkSignature(function, '3c8b0dcb'));
    final params = [
      _sender,
      taskAddress,
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
  Future<String> addPerformerAgreedTask(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress taskAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[14];
    assert(checkSignature(function, '2ba6fc52'));
    final params = [
      _sender,
      taskAddress,
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
  Future<String> addPerformerAuditedTask(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress taskAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[15];
    assert(checkSignature(function, 'c37d4f73'));
    final params = [
      _sender,
      taskAddress,
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
  Future<String> addPerformerCompletedTask(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress taskAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[16];
    assert(checkSignature(function, '30033f1b'));
    final params = [
      _sender,
      taskAddress,
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
  Future<String> addPerformerEarnedTokens(
    _i1.EthereumAddress performer,
    List<String> tokenNames,
    List<BigInt> tokenBalances, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[17];
    assert(checkSignature(function, 'ac336a60'));
    final params = [
      performer,
      tokenNames,
      tokenBalances,
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
  Future<String> addPerformerRating(
    _i1.EthereumAddress _account,
    _i1.EthereumAddress taskAddress,
    BigInt rating, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[18];
    assert(checkSignature(function, 'f20b7b31'));
    final params = [
      _account,
      taskAddress,
      rating,
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
  Future<String> addPerformerSpentTokens(
    _i1.EthereumAddress performer,
    List<String> tokenNames,
    List<BigInt> tokenBalances, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[19];
    assert(checkSignature(function, 'df6062f8'));
    final params = [
      performer,
      tokenNames,
      tokenBalances,
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
  Future<bool> contractAccountFacet({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[20];
    assert(checkSignature(function, '4bf83d01'));
    final params = [];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as bool);
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> removeAccountFromBlacklist(
    _i1.EthereumAddress accountAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[21];
    assert(checkSignature(function, '89a76332'));
    final params = [accountAddress];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// Returns a live stream of all AccountCreated events emitted by this contract.
  Stream<AccountCreated> accountCreatedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('AccountCreated');
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
      return AccountCreated(decoded);
    });
  }
}

class AccountCreated {
  AccountCreated(List<dynamic> response)
      : ownerAddr = (response[0] as _i1.EthereumAddress),
        message = (response[1] as String),
        timestamp = (response[2] as BigInt);

  final _i1.EthereumAddress ownerAddr;

  final String message;

  final BigInt timestamp;
}
