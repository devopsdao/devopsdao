// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:webthree/webthree.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[],"name":"getAccountsBlacklist","outputs":[{"internalType":"address[]","name":"","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address[]","name":"accountAddresses","type":"address[]"}],"name":"getAccountsData","outputs":[{"components":[{"internalType":"address","name":"accountOwner","type":"address"},{"internalType":"string","name":"nickname","type":"string"},{"internalType":"string","name":"about","type":"string"},{"internalType":"address[]","name":"ownerTasks","type":"address[]"},{"internalType":"address[]","name":"participantTasks","type":"address[]"},{"internalType":"address[]","name":"auditParticipantTasks","type":"address[]"},{"internalType":"address[]","name":"agreedTasks","type":"address[]"},{"internalType":"address[]","name":"auditAgreedTasks","type":"address[]"},{"internalType":"address[]","name":"completedTasks","type":"address[]"},{"internalType":"address[]","name":"auditCompletedTasks","type":"address[]"},{"internalType":"uint256[]","name":"customerRatings","type":"uint256[]"},{"internalType":"uint256[]","name":"performerRatings","type":"uint256[]"},{"internalType":"address[]","name":"customerAgreedTasks","type":"address[]"},{"internalType":"address[]","name":"performerAuditedTasks","type":"address[]"},{"internalType":"address[]","name":"customerAuditedTasks","type":"address[]"},{"internalType":"address[]","name":"customerCompletedTasks","type":"address[]"},{"internalType":"string[]","name":"spentTokenNames","type":"string[]"},{"internalType":"uint256[]","name":"spentTokenBalances","type":"uint256[]"},{"internalType":"string[]","name":"earnedTokenNames","type":"string[]"},{"internalType":"uint256[]","name":"earnedTokenBalances","type":"uint256[]"}],"internalType":"struct AccountData[]","name":"","type":"tuple[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getAccountsList","outputs":[{"internalType":"address[]","name":"","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"string[]","name":"identities","type":"string[]"}],"name":"getIdentitiesAddresses","outputs":[{"internalType":"address[]","name":"","type":"address[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getRawAccountsCount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getRawAccountsList","outputs":[{"internalType":"address[]","name":"","type":"address[]"}],"stateMutability":"view","type":"function"}]',
  'AccountDataFacet',
);

class AccountDataFacet extends _i1.GeneratedContract {
  AccountDataFacet({
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
  Future<List<_i1.EthereumAddress>> getAccountsBlacklist({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, '5587b594'));
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
  Future<List<dynamic>> getAccountsData(
    List<_i1.EthereumAddress> accountAddresses, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[1];
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
    final function = self.abi.functions[2];
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

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<_i1.EthereumAddress>> getIdentitiesAddresses(
    List<String> identities, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, '815707e5'));
    final params = [identities];
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
  Future<BigInt> getRawAccountsCount({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, 'a601d46a'));
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
  Future<List<_i1.EthereumAddress>> getRawAccountsList({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, 'c6a8ade3'));
    final params = [];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<_i1.EthereumAddress>();
  }
}
