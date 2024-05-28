// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:webthree/webthree.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[],"name":"contractTaskStatsFacet","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"offset","type":"uint256"},{"internalType":"uint256","name":"limit","type":"uint256"}],"name":"getTaskStatsWithTimestamps","outputs":[{"components":[{"internalType":"uint256","name":"countNew","type":"uint256"},{"internalType":"uint256","name":"countAgreed","type":"uint256"},{"internalType":"uint256","name":"countProgress","type":"uint256"},{"internalType":"uint256","name":"countReview","type":"uint256"},{"internalType":"uint256","name":"countCompleted","type":"uint256"},{"internalType":"uint256","name":"countCanceled","type":"uint256"},{"internalType":"uint256","name":"countPrivate","type":"uint256"},{"internalType":"uint256","name":"countPublic","type":"uint256"},{"internalType":"uint256","name":"countHackaton","type":"uint256"},{"internalType":"uint256","name":"avgTaskDuration","type":"uint256"},{"internalType":"uint256","name":"avgPerformerRating","type":"uint256"},{"internalType":"uint256","name":"avgCustomerRating","type":"uint256"},{"internalType":"string[]","name":"topTags","type":"string[]"},{"internalType":"uint256[]","name":"topTagCounts","type":"uint256[]"},{"internalType":"string[]","name":"topTokenNames","type":"string[]"},{"internalType":"uint256[]","name":"topTokenBalances","type":"uint256[]"},{"internalType":"uint256[]","name":"topETHBalances","type":"uint256[]"},{"internalType":"uint256[]","name":"topETHAmounts","type":"uint256[]"},{"internalType":"uint256[]","name":"createTimestamps","type":"uint256[]"}],"internalType":"struct TaskStatsWithTimestamps","name":"","type":"tuple"}],"stateMutability":"view","type":"function"}]',
  'TaskStatsFacet',
);

class TaskStatsFacet extends _i1.GeneratedContract {
  TaskStatsFacet({
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
  Future<bool> contractTaskStatsFacet({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, '279a0dfc'));
    final params = [];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as bool);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<dynamic> getTaskStatsWithTimestamps(
    BigInt offset,
    BigInt limit, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, 'd4d976c3'));
    final params = [
      offset,
      limit,
    ];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as dynamic);
  }
}
