// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:webthree/webthree.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"ownerAddr","type":"address"},{"indexed":false,"internalType":"string","name":"message","type":"string"},{"indexed":false,"internalType":"uint256","name":"timestamp","type":"uint256"}],"name":"AccountCreated","type":"event"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"string","name":"nickname","type":"string"},{"internalType":"string","name":"about","type":"string"}],"name":"addAccountData","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"taskAddress","type":"address"}],"name":"addAccountToBlacklist","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"taskAddress","type":"address"}],"name":"addAuditParticipantTask","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"taskAddress","type":"address"},{"internalType":"uint256","name":"rating","type":"uint256"}],"name":"addCustomerRating","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"taskAddress","type":"address"}],"name":"addParticipantTask","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_sender","type":"address"},{"internalType":"address","name":"taskAddress","type":"address"},{"internalType":"uint256","name":"rating","type":"uint256"}],"name":"addPerformerRating","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address[]","name":"accountAddresses","type":"address[]"}],"name":"getAccountsData","outputs":[{"components":[{"internalType":"address","name":"accountOwner","type":"address"},{"internalType":"string","name":"nickname","type":"string"},{"internalType":"string","name":"about","type":"string"},{"internalType":"address[]","name":"ownerTasks","type":"address[]"},{"internalType":"address[]","name":"participantTasks","type":"address[]"},{"internalType":"address[]","name":"auditParticipantTasks","type":"address[]"},{"internalType":"uint256[]","name":"customerRatings","type":"uint256[]"},{"internalType":"uint256[]","name":"performerRatings","type":"uint256[]"}],"internalType":"struct Account[]","name":"","type":"tuple[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getAccountsList","outputs":[{"internalType":"address[]","name":"","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"taskAddress","type":"address"}],"name":"removeAccountFromBlacklist","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
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
    String nickname,
    String about, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, '56fd9644'));
    final params = [
      _sender,
      nickname,
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
    _i1.EthereumAddress taskAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '08f99714'));
    final params = [taskAddress];
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
    final function = self.abi.functions[2];
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
  Future<String> addCustomerRating(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress taskAddress,
    BigInt rating, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, '4bc27b63'));
    final params = [
      _sender,
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
  Future<String> addParticipantTask(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress taskAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[4];
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
  Future<String> addPerformerRating(
    _i1.EthereumAddress _sender,
    _i1.EthereumAddress taskAddress,
    BigInt rating, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, 'f20b7b31'));
    final params = [
      _sender,
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

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<dynamic>> getAccountsData(
    List<_i1.EthereumAddress> accountAddresses, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, '2a13a5e8'));
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
  Future<List<_i1.EthereumAddress>> getAccountsList({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, 'f02e4b04'));
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
  Future<String> removeAccountFromBlacklist(
    _i1.EthereumAddress taskAddress, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[8];
    assert(checkSignature(function, '89a76332'));
    final params = [taskAddress];
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
