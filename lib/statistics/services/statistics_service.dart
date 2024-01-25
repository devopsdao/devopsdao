import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:dodao/wallet/services/wallet_service.dart';
import 'package:webthree/credentials.dart';
import 'package:webthree/webthree.dart';
import '../../../blockchain/abi/IERC1155.g.dart';
import '../../../blockchain/abi/IERC165.g.dart';
import '../../../blockchain/abi/IERC20.g.dart';
import '../../../blockchain/abi/IERC721.g.dart';
import '../../../blockchain/abi/TokenDataFacet.g.dart';
import '../../../blockchain/classes.dart';
import '../../blockchain/chain_presets/get_addresses.dart';

// get -> read ->
// set -> write ->
// on -> init ->
// ... -> check (logic with bool return(not bool stored data))

class StatisticsService {
  //Utils:
  final _getAddresses = GetAddresses();

  List<TokenItem> _tags = [];
  List<TokenItem> get tags => _tags;
  Map<String, Map<String, BigInt>> initialEmptyBalance = {};
  static const String tokenContractKeyName = 'dodao';

  EthereumAddress zeroAddress = GetAddresses.zeroAddress;
  static final StreamController<List<TokenItem>> _controller = StreamController<List<TokenItem>>.broadcast();
  Stream<List<TokenItem>> get statisticsTokenItems => _controller.stream.asBroadcastStream();
  // StatisticsService() {
  //   print('StatisticsService  test');
  //   number.listen((s) {
  //     print('listen');
  //     print(s);
  //   });
  // }

  Future<void> initRequestBalances(int chainId, tasksServices) async {
    EthereumAddress contractAddress = await _getAddresses.requestContractAddress(chainId);
    if (WalletService.walletAddress == null) {
      return;
    }

    Map<String, EthereumAddress> whitelistedContracts = await getWhitelistedContracts(contractAddress, chainId);
    Map<String, Map<String, BigInt>> balances = await getTokenBalances(whitelistedContracts, [WalletService.walletAddress!], chainId, tasksServices);
    _tags = await convertToTokenList(balances);
    _controller.add(_tags);
  }

  Future<Map<String, EthereumAddress>> getWhitelistedContracts(EthereumAddress contractAddress, int chainId) async {
    final Map<int, Map<String, EthereumAddress>> tokenContracts = {
      // hardhat:
      31337: {
        'ETH': zeroAddress,
        // 'USDC': zeroAddress,
        // 'USDT': zeroAddress,
        tokenContractKeyName: contractAddress
      },
      1287: {
        'DEV': zeroAddress,
        // 'USDC': zeroAddress,
        // 'USDT': zeroAddress,
        tokenContractKeyName: contractAddress
      },
      4002: {
        'FTM': zeroAddress,
        // 'USDC': zeroAddress,
        // 'USDT': zeroAddress,
        tokenContractKeyName: contractAddress
      },
      64165: {
        'FTM': zeroAddress,
        // 'USDC': zeroAddress,
        // 'USDT': zeroAddress,
        tokenContractKeyName: contractAddress
      },
      80001: {
        'MATIC': zeroAddress,
        // 'USDC': zeroAddress,
        // 'USDT': zeroAddress,
        tokenContractKeyName: contractAddress
      },
      280: {
        'ETH': zeroAddress,
        // 'USDC': zeroAddress,
        // 'USDT': zeroAddress,
        tokenContractKeyName: contractAddress
      },
      855456: {
        'DODAO': zeroAddress,
        // 'USDC': zeroAddress,
        // 'USDT': zeroAddress,
        tokenContractKeyName: contractAddress
      }
    };
    if (tokenContracts[chainId] != null) {
      return tokenContracts[chainId]!;
    } else {
      return {'ETH': zeroAddress};
    }
  }

  Future<List<TokenItem>> convertToTokenList(Map<String, Map<String, BigInt>> balance) async {
    List<TokenItem> convertedTags = [];
    late bool nft = false;

    for (var element in balance.entries) {
      if (element.key == tokenContractKeyName) {
        nft = true;
      }
      element.value.forEach((k, v) {
        final double myBalance;
        if (nft) {
          myBalance = v.toDouble();
        } else {
          final ethBalancePrecise = v.toDouble() / pow(10, 18);
          myBalance = (((ethBalancePrecise * 10000).floor()) / 10000).toDouble();
        }
        convertedTags.add(TokenItem(collection: true, name: k.toString(), balance: myBalance, nft: nft));
      });
    }
    return convertedTags;
  }

  Future<Map<String, Map<String, BigInt>>> getTokenBalances(
      Map<String, EthereumAddress> tokenContracts, List<EthereumAddress> addresses, int chainId, tasksServices) async {
    Map<String, Map<String, BigInt>> balances = {};
    for (final key in tokenContracts.keys) {
      if (tokenContracts[key] == zeroAddress) {
        for (var idx = 0; idx < addresses.length; idx++) {
          final EtherAmount balance = await tasksServices.web3GetBalance(addresses[idx]);
          final BigInt weiBalance = balance.getInWei;
          balances[key] = {key: weiBalance};
        }
        // for (var idx in tokenContracts.keys) {
        //   final EtherAmount balance = await web3GetBalance(addresses[i]);
        //   final BigInt weiBalance = balance.getInWei;
        //   balances[i][idx] = weiBalance;
        // }
      } else {
        var ierc165 = IERC165(address: tokenContracts[key]!, client: tasksServices.web3client, chainId: chainId);
        //check if ERC-1155
        var erc1155InterfaceID = Uint8List.fromList(hex.decode('4e2312e0'));
        var erc20InterfaceID = Uint8List.fromList(hex.decode('36372b07'));
        var erc721InterfaceID = Uint8List.fromList(hex.decode('80ac58cd'));
        bool resultIerc = await ierc165.supportsInterface(Uint8List.fromList(erc1155InterfaceID));
        if (resultIerc == true) {
          var ierc1155 = IERC1155(address: tokenContracts[key]!, client: tasksServices.web3client, chainId: chainId);
          var tokenDataFacet = TokenDataFacet(address: tokenContracts[key]!, client: tasksServices.web3client, chainId: chainId);
          for (int i = 0; i < addresses.length; i++) {
            final List<BigInt> tokenIds = await tokenDataFacet.getTokenIds(addresses[i]);
            final List<String> tokenNames = await tokenDataFacet.getTokenNames(addresses[i]);
            final Map<BigInt, String> resultCombined = Map.fromIterables(tokenIds, tokenNames);

            if (resultCombined.isNotEmpty) {
              final List<EthereumAddress> filledAddressesList = List<EthereumAddress>.filled(resultCombined.length, addresses.first);
              final balanceOf = await ierc1155.balanceOfBatch(filledAddressesList, resultCombined.keys.toList());
              late Map<String, BigInt> combined = {};
              for (int idx = 0; idx < resultCombined.length; idx++) {
                final BigInt num = balanceOf[idx];
                if (num != BigInt.from(0)) {
                  if (!combined.containsKey(resultCombined.values.toList()[idx])) {
                    combined[resultCombined.values.toList()[idx]] = num;
                  } else {
                    combined[resultCombined.values.toList()[idx]] = num + combined[resultCombined.values.toList()[idx]]!;
                  }
                }
              }
              balances[key] = combined;
            }
          }
        } else if (await ierc165.supportsInterface(Uint8List.fromList(erc20InterfaceID)) == true) {
          var ierc20 = IERC20(address: tokenContracts[key]!, client: tasksServices.web3client, chainId: WalletService.chainId);
          for (int idx = 0; idx < addresses.length; idx++) {
            // balances[i][idx] = await ierc20.balanceOf(addresses[i]);
          }
        } else if (await ierc165.supportsInterface(Uint8List.fromList(erc721InterfaceID)) == true) {
          var ierc721 = IERC721(address: tokenContracts[key]!, client: tasksServices.web3client, chainId: WalletService.chainId);
          for (int idx = 0; idx < addresses.length; idx++) {
            // balances[i][idx] = await ierc721.balanceOf(addresses[i]);
          }
        }
      }
    }
    initialEmptyBalance = balances;
    return balances;
  }
}
