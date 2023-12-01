import 'dart:core';

import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class ChainInfo {
  final String chainName;
  final String chainId;
  final String chainIdHex;
  final String namespace;
  String? chainIconLocally;
  Map<String, RequiredNamespace> requiredNamespaces;
  Map<String, RequiredNamespace> optionalNamespaces;
  final String rpcUrl;
  BlockExplorer? blockExplorer;
  NativeCurrency? nativeCurrency;
  String? iconUrl;
  ChainInfo({
    required this.chainName,
    required this.chainId,
    required this.chainIdHex,
    required this.namespace,
    this.chainIconLocally,
    required this.requiredNamespaces,
    required this.optionalNamespaces,
    required this.rpcUrl,
    this.blockExplorer,
    this.nativeCurrency,
    this.iconUrl,
  });
}

class BlockExplorer {
  final String name;
  final String url;
  BlockExplorer({
    required this.name,
    required this.url,
  });
}

class NativeCurrency {
  final String name;
  final String symbol;
  final int decimals;
  NativeCurrency({
    required this.name,
    required this.symbol,
    required this.decimals,
  });
}



class ChainPresets {
  static Map<int, ChainInfo> chains = {
    855456: ChainInfo(
      chainName: 'Dodao Tanssi Appchain',
      namespace: 'eip155:855456',
      chainId: '855456',
      chainIdHex: '0xd0da0',
      chainIconLocally: chainImagesId['855456'],
      iconUrl: 'https://ipfs.io/ipfs/bafybeihbpxhz4urjr27gf6hjdmvmyqs36f3yn4k3iuz3w3pb5dd7grdnjy',

        requiredNamespaces: {
      },
      optionalNamespaces: {
        'eip155': const RequiredNamespace(
          methods: [
            'eth_sign',
            'eth_signTransaction',
            'eth_sendTransaction',
            'wallet_switchEthereumChain',
            'wallet_addEthereumChain',
            'eth_chainId'
          ],
          chains: ['eip155:855456'],
          events: [
            'chainChanged',
            'accountsChanged',
          ],
        ),
      },
      rpcUrl: 'https://fraa-dancebox-3041-rpc.a.dancebox.tanssi.network',
      blockExplorer: BlockExplorer(
        name: 'Explorer',
        url: 'https://tanssi-evmexplorer.netlify.app/?rpcUrl=https://fraa-dancebox-3041-rpc.a.dancebox.tanssi.network',
      ),
      nativeCurrency: NativeCurrency(
        name: 'Dodao',
        symbol: 'DODAO',
        decimals: 18,
      )
    ),

    1287: ChainInfo(
        chainName: 'Moonbase Alpha',
        namespace: 'eip155:1287',
        chainId: '1287',
        chainIdHex: '0x507',
        chainIconLocally: chainImagesId['1287'],
        iconUrl: '',

        requiredNamespaces: {
          'eip155': const RequiredNamespace(
            methods: [
              'eth_sign',
              'eth_signTransaction',
              'eth_sendTransaction',
            ],
            chains: ['eip155:1287'],
            events: [
              'chainChanged',
              'accountsChanged',
            ],
          ),
        },
        optionalNamespaces: {
          'eip155': const RequiredNamespace(
            methods: [
              'wallet_switchEthereumChain',
              'wallet_addEthereumChain',
              'eth_chainId'
            ],
            chains: ['eip155:1287'],
            events: [],
          ),
        },
        rpcUrl: 'https://moonbase-alpha.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f',
        blockExplorer: BlockExplorer(
          name: 'Explorer',
          url: 'https://moonbase.moonscan.io/',
        ),
        nativeCurrency: NativeCurrency(
          name: 'Dev',
          symbol: 'DEV',
          decimals: 18,
        )
    ),

    4002: ChainInfo(
        chainName: 'Fantom testnet',
        namespace: 'eip155:4002',
        chainId: '4002',
        chainIdHex: '0xFA2',
        chainIconLocally: chainImagesId['4002'],
        iconUrl: '',

        requiredNamespaces: {
          'eip155': const RequiredNamespace(
            methods: [
              'eth_sign',
              'eth_signTransaction',
              'eth_sendTransaction',
            ],
            chains: ['eip155:4002'],
            events: [
              'chainChanged',
              'accountsChanged',
            ],
          ),
        },
        optionalNamespaces: {
          'eip155': const RequiredNamespace(
            methods: [
              'wallet_switchEthereumChain',
              'wallet_addEthereumChain',
              'eth_chainId'
            ],
            chains: ['eip155:4002'],
            events: [],
          ),
        },
        rpcUrl: 'https://fantom-testnet.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f',
        blockExplorer: BlockExplorer(
          name: 'Explorer',
          url: 'https://testnet.ftmscan.com/',
        ),
        nativeCurrency: NativeCurrency(
          name: 'Fantom',
          symbol: 'FTM',
          decimals: 18,
        )
    ),

    5: ChainInfo(
        chainName: 'Goerli',
        namespace: 'eip155:5',
        chainId: '5',
        chainIdHex: '0x5',
        chainIconLocally: chainImagesId['5'],
        iconUrl: '',

        requiredNamespaces: {
          'eip155': const RequiredNamespace(
            methods: [
              'eth_sign',
              'eth_signTransaction',
              'eth_sendTransaction',
            ],
            chains: ['eip155:5'],
            events: [
              'chainChanged',
              'accountsChanged',
            ],
          ),
        },
        optionalNamespaces: {
          'eip155': const RequiredNamespace(
            methods: [
              'wallet_switchEthereumChain',
              'wallet_addEthereumChain',
              'eth_chainId'
            ],
            chains: ['eip155:5'],
            events: [],
          ),
        },
        rpcUrl: 'https://rpc.goerli.eth.gateway.fm',
        blockExplorer: BlockExplorer(
          name: 'Explorer',
          url: 'https://goerli.etherscan.io/',
        ),
        nativeCurrency: NativeCurrency(
          name: 'Eth',
          symbol: 'ETH',
            decimals: 18,
        )
    ),

    280: ChainInfo(
        chainName: 'zkSync Era testnet',
        namespace: 'eip155:280',
        chainId: '280',
        chainIdHex: '0x118',
        chainIconLocally: chainImagesId['280'],
        iconUrl: '',

        requiredNamespaces: {
          'eip155': const RequiredNamespace(
            methods: [
              'eth_sign',
              'eth_signTransaction',
              'eth_sendTransaction',
            ],
            chains: ['eip155:280'],
            events: [
              'chainChanged',
              'accountsChanged',
            ],
          ),
        },
        optionalNamespaces: {
          'eip155': const RequiredNamespace(
            methods: [
              'wallet_switchEthereumChain',
              'wallet_addEthereumChain',
              'eth_chainId'
            ],
            chains: ['eip155:280'],
            events: [],
          ),
        },
        rpcUrl: 'https://zksync2-testnet.zksync.dev',
        blockExplorer: BlockExplorer(
          name: 'Explorer',
          url: 'https://explorer.zksync.io/',
        ),
        nativeCurrency: NativeCurrency(
          name: 'ETH',
          symbol: 'ETH',
          decimals: 18,
        )
    ),

    80001: ChainInfo(
        chainName: 'Polygon Mumbai',
        namespace: 'eip155:80001',
        chainId: '80001',
        chainIdHex: '0x13881',
        chainIconLocally: chainImagesId['80001'],
        iconUrl: '',

        requiredNamespaces: {
          'eip155': const RequiredNamespace(
            methods: [
              'eth_sign',
              'eth_signTransaction',
              'eth_sendTransaction',
            ],
            chains: ['eip155:80001'],
            events: [
              'chainChanged',
              'accountsChanged',
            ],
          ),
        },
        optionalNamespaces: {
          'eip155': const RequiredNamespace(
            methods: [
              'wallet_switchEthereumChain',
              'wallet_addEthereumChain',
              'eth_chainId'
            ],
            chains: ['eip155:80001'],
            events: [],
          ),
        },
        rpcUrl: 'https://rpc.ankr.com/polygon_mumbai',
        blockExplorer: BlockExplorer(
          name: 'Explorer',
          url: 'https://mumbai.polygonscan.com/',
        ),
        nativeCurrency: NativeCurrency(
          name: 'Matic',
          symbol: 'MATIC',
          decimals: 18,
        )
    ),

    // '250': ChainInfo(
    //   chainName: 'Fantom',
    //   namespace: 'eip155:250',
    //   chainId: '250',
    //   chainIdHex: '',
    //   chainIcon: chainImagesId['250'],
    //   requiredNamespaces: {
    //     'eip155': const RequiredNamespace(
    //       methods: EthConstants.ethRequiredMethods,
    //       chains: ['eip155:250'],
    //       events: EthConstants.ethEvents,
    //     ),
    //   },
    //   optionalNamespaces: {
    //     'eip155': const RequiredNamespace(
    //       methods: EthConstants.ethOptionalMethods,
    //       chains: ['eip155:250'],
    //       events: [],
    //     ),
    //   },
    //   rpcUrl: 'https://rpc.ftm.tools/',
    //   blockExplorer: BlockExplorer(
    //     name: 'FTM Scan',
    //     url: 'https://ftmscan.com',
    //   ),
    //
    // ),
  };

  static Map<String, String> chainImagesId = {
    // Ethereum
    '855456': '692ed6ba-e569-459a-556a-776476829e00',
    // Arbitrum
    '42161': '600a9a04-c1b9-42ca-6785-9b4b6ff85200',
    // Avalanche
    '43114': '30c46e53-e989-45fb-4549-be3bd4eb3b00',
    // Binance Smart Chain
    '56': '93564157-2e8e-4ce7-81df-b264dbee9b00',
    // Fantom
    '250': '06b26297-fe0c-4733-5d6b-ffa5498aac00',
    // Optimism
    '10': 'ab9c186a-c52f-464b-2906-ca59d760a400',
    // Polygon
    '137': '41d04d42-da3b-4453-8506-668cc0727900',
    // Gnosis
    '100': '02b53f6a-e3d4-479e-1cb4-21178987d100',
    // EVMos
    '9001': 'f926ff41-260d-4028-635e-91913fc28e00',
    // ZkSync
    '324': 'b310f07f-4ef7-49f3-7073-2a0a39685800',
    // Filecoin
    '314': '5a73b3dd-af74-424e-cae0-0de859ee9400',
    // Iotx
    '4689': '34e68754-e536-40da-c153-6ef2e7188a00',
    // Metis,
    '1088': '3897a66d-40b9-4833-162f-a2c90531c900',
    // Moonbeam
    '1284': '161038da-44ae-4ec7-1208-0ea569454b00',
    // Moonriver
    '1285': 'f1d73bb6-5450-4e18-38f7-fb6484264a00',
    // Zora
    '7777777': '845c60df-d429-4991-e687-91ae45791600',
    // Celo
    '42220': 'ab781bbc-ccc6-418d-d32d-789b15da1f00',
    // Base
    '8453': '7289c336-3981-4081-c5f4-efc26ac64a00',
    // Aurora
    '1313161554': '3ff73439-a619-4894-9262-4470c773a100'
  };
}
