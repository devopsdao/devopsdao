// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:webthree/webthree.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[{"internalType":"address[]","name":"accounts_","type":"address[]"},{"internalType":"string[]","name":"names_","type":"string[]"}],"name":"balanceOfBatchName","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address[]","name":"accounts_","type":"address[]"},{"internalType":"uint256[]","name":"ids_","type":"uint256[]"}],"name":"balanceOfBatchNfType","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"account_","type":"address"},{"internalType":"string","name":"name_","type":"string"}],"name":"balanceOfName","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"account_","type":"address"},{"internalType":"uint256","name":"id_","type":"uint256"}],"name":"balanceOfNfType","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"id_","type":"uint256"}],"name":"exists","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"string","name":"name_","type":"string"}],"name":"existsName","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"id_","type":"uint256"}],"name":"existsNfType","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getCreatedTokenNames","outputs":[{"internalType":"string[]","name":"","type":"string[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"string","name":"_name","type":"string"}],"name":"getTokenBaseType","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_owner","type":"address"}],"name":"getTokenIds","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_id","type":"uint256"}],"name":"getTokenName","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_owner","type":"address"}],"name":"getTokenNames","outputs":[{"internalType":"string[]","name":"","type":"string[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256[]","name":"_ids","type":"uint256[]"}],"name":"getTokenNames","outputs":[{"internalType":"string[]","name":"","type":"string[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_owner","type":"address"}],"name":"tokensByAccount","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"id_","type":"uint256"}],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256[]","name":"_ids","type":"uint256[]"}],"name":"totalSupplyOfBatch","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"string[]","name":"_names","type":"string[]"}],"name":"totalSupplyOfBatchName","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256[]","name":"_ids","type":"uint256[]"}],"name":"totalSupplyOfBatchNfType","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"string","name":"name_","type":"string"}],"name":"totalSupplyOfName","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"id_","type":"uint256"}],"name":"totalSupplyOfNfType","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"id_","type":"uint256"}],"name":"uri","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256[]","name":"ids_","type":"uint256[]"}],"name":"uriOfBatch","outputs":[{"internalType":"string[]","name":"","type":"string[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"string[]","name":"names_","type":"string[]"}],"name":"uriOfBatchName","outputs":[{"internalType":"string[]","name":"","type":"string[]"}],"stateMutability":"view","type":"function"}]',
  'TokenDataFacet',
);

class TokenDataFacet extends _i1.GeneratedContract {
  TokenDataFacet({
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
  Future<List<BigInt>> balanceOfBatchName(
    List<_i1.EthereumAddress> accounts_,
    List<String> names_, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, '80b20931'));
    final params = [
      accounts_,
      names_,
    ];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<BigInt>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<BigInt>> balanceOfBatchNfType(
    List<_i1.EthereumAddress> accounts_,
    List<BigInt> ids_, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '9cd86c08'));
    final params = [
      accounts_,
      ids_,
    ];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<BigInt>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> balanceOfName(
    _i1.EthereumAddress account_,
    String name_, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, 'cb086f9d'));
    final params = [
      account_,
      name_,
    ];
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
  Future<BigInt> balanceOfNfType(
    _i1.EthereumAddress account_,
    BigInt id_, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, '9fd71bde'));
    final params = [
      account_,
      id_,
    ];
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
  Future<bool> exists(
    BigInt id_, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, '4f558e79'));
    final params = [id_];
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
  Future<bool> existsName(
    String name_, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, 'a1e26093'));
    final params = [name_];
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
  Future<bool> existsNfType(
    BigInt id_, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, '8ac7b7a5'));
    final params = [id_];
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
  Future<List<String>> getCreatedTokenNames({
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, 'adfd07a8'));
    final params = [];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<String>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> getTokenBaseType(
    String _name, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[8];
    assert(checkSignature(function, '4ee52a62'));
    final params = [_name];
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
  Future<List<BigInt>> getTokenIds(
    _i1.EthereumAddress _owner, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[9];
    assert(checkSignature(function, 'd004b036'));
    final params = [_owner];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<BigInt>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<String> getTokenName(
    BigInt _id, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[10];
    assert(checkSignature(function, 'dbe16c07'));
    final params = [_id];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as String);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<String>> getTokenNames(
    _i1.EthereumAddress _owner, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[11];
    assert(checkSignature(function, '01bc466a'));
    final params = [_owner];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<String>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<String>> getTokenNames$2(
    List<BigInt> _ids, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[12];
    assert(checkSignature(function, 'c866dd0b'));
    final params = [_ids];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<String>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<BigInt>> tokensByAccount(
    _i1.EthereumAddress _owner, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[13];
    assert(checkSignature(function, '85bff2e7'));
    final params = [_owner];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<BigInt>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> totalSupply(
    BigInt id_, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[14];
    assert(checkSignature(function, 'bd85b039'));
    final params = [id_];
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
  Future<List<BigInt>> totalSupplyOfBatch(
    List<BigInt> _ids, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[15];
    assert(checkSignature(function, '88ff3907'));
    final params = [_ids];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<BigInt>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<BigInt>> totalSupplyOfBatchName(
    List<String> _names, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[16];
    assert(checkSignature(function, '9af793fb'));
    final params = [_names];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<BigInt>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<BigInt>> totalSupplyOfBatchNfType(
    List<BigInt> _ids, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[17];
    assert(checkSignature(function, '27040961'));
    final params = [_ids];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<BigInt>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> totalSupplyOfName(
    String name_, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[18];
    assert(checkSignature(function, '8d938412'));
    final params = [name_];
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
  Future<BigInt> totalSupplyOfNfType(
    BigInt id_, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[19];
    assert(checkSignature(function, '0fd38d11'));
    final params = [id_];
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
  Future<String> uri(
    BigInt id_, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[20];
    assert(checkSignature(function, '0e89341c'));
    final params = [id_];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as String);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<String>> uriOfBatch(
    List<BigInt> ids_, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[21];
    assert(checkSignature(function, '748937f6'));
    final params = [ids_];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<String>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<String>> uriOfBatchName(
    List<String> names_, {
    _i1.BlockNum? atBlock,
    _i1.EthereumAddress? sender,
  }) async {
    final function = self.abi.functions[22];
    assert(checkSignature(function, '8a31d522'));
    final params = [names_];
    final response = await read(
      sender,
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<String>();
  }
}
