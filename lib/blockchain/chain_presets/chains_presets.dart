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
  ChainInfo readChainInfo(int chainId) {
    ChainInfo networkParams = ChainPresets.chains.entries.firstWhere((element) {
      return element.key == chainId;
    }).value;
    return networkParams;
  }

  static Map<int, ChainInfo> chains = {
    855456: ChainInfo(
        chainName: 'Dodao Tanssi Appchain',
        namespace: 'eip155:855456',
        chainId: '855456',
        chainIdHex: '0xd0da0',
        chainIconLocally: chainImagesPath['855456'],
        iconUrl: 'https://ipfs.io/ipfs/bafybeihbpxhz4urjr27gf6hjdmvmyqs36f3yn4k3iuz3w3pb5dd7grdnjy',
        requiredNamespaces: {},
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
        rpcUrl: 'https://fraa-flashbox-2804-rpc.a.stagenet.tanssi.network',
        blockExplorer: BlockExplorer(
          name: 'Explorer',
          url: 'https://evmexplorer.tanssi-chains.network/?rpcUrl=https://fraa-flashbox-2804-rpc.a.stagenet.tanssi.network',
        ),
        nativeCurrency: NativeCurrency(
          name: 'Dodao',
          symbol: 'DODAO',
          decimals: 18,
        )),
    // 855456: ChainInfo(
    //     chainName: 'Dodao Tanssi Appchain',
    //     namespace: 'eip155:855456',
    //     chainId: '855456',
    //     chainIdHex: '0xd0da0',
    //     chainIconLocally: chainImagesPath['855456'],
    //     iconUrl: 'https://ipfs.io/ipfs/bafybeihbpxhz4urjr27gf6hjdmvmyqs36f3yn4k3iuz3w3pb5dd7grdnjy',
    //     requiredNamespaces: {},
    //     optionalNamespaces: {
    //       'eip155': const RequiredNamespace(
    //         methods: [
    //           'eth_sign',
    //           'eth_signTransaction',
    //           'eth_sendTransaction',
    //           'wallet_switchEthereumChain',
    //           'wallet_addEthereumChain',
    //           'eth_chainId'
    //         ],
    //         chains: ['eip155:855456'],
    //         events: [
    //           'chainChanged',
    //           'accountsChanged',
    //         ],
    //       ),
    //     },
    //     rpcUrl: 'https://fraa-dancebox-3041-rpc.a.dancebox.tanssi.network',
    //     blockExplorer: BlockExplorer(
    //       name: 'Explorer',
    //       url: 'https://tanssi-evmexplorer.netlify.app/?rpcUrl=https://fraa-dancebox-3041-rpc.a.dancebox.tanssi.network',
    //     ),
    //     nativeCurrency: NativeCurrency(
    //       name: 'Dodao',
    //       symbol: 'DODAO',
    //       decimals: 18,
    //     )),
    1287: ChainInfo(
        chainName: 'Moonbase Alpha',
        namespace: 'eip155:1287',
        chainId: '1287',
        chainIdHex: '0x507',
        chainIconLocally: chainImagesPath['1287'],
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
            methods: ['wallet_switchEthereumChain', 'wallet_addEthereumChain', 'eth_chainId'],
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
        )),
    4002: ChainInfo(
        chainName: 'Fantom testnet',
        namespace: 'eip155:4002',
        chainId: '4002',
        chainIdHex: '0xFA2',
        chainIconLocally: chainImagesPath['4002'],
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
            methods: ['wallet_switchEthereumChain', 'wallet_addEthereumChain', 'eth_chainId'],
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
        )),
    64165: ChainInfo(
        chainName: 'Fantom sonic',
        namespace: 'eip155:64165',
        chainId: '64165',
        chainIdHex: '0xFAA5',
        chainIconLocally: chainImagesPath['64165'],
        iconUrl: '',
        requiredNamespaces: {
          'eip155': const RequiredNamespace(
            methods: [
              'eth_sign',
              'eth_signTransaction',
              'eth_sendTransaction',
            ],
            chains: ['eip155:64165'],
            events: [
              'chainChanged',
              'accountsChanged',
            ],
          ),
        },
        optionalNamespaces: {
          'eip155': const RequiredNamespace(
            methods: ['wallet_switchEthereumChain', 'wallet_addEthereumChain', 'eth_chainId'],
            chains: ['eip155:64165'],
            events: [],
          ),
        },
        rpcUrl: 'https://rpc.sonic.fantom.network/',
        blockExplorer: BlockExplorer(
          name: 'Explorer',
          url: 'https://public-sonic.fantom.network',
        ),
        nativeCurrency: NativeCurrency(
          name: 'Fantom',
          symbol: 'FTM',
          decimals: 18,
        )),
    11155111: ChainInfo(
        chainName: 'Sepolia',
        namespace: 'eip155:11155111',
        chainId: '11155111',
        chainIdHex: '0xaa36a7',
        chainIconLocally: chainImagesPath['11155111'],
        iconUrl: '',
        requiredNamespaces: {
          'eip155': const RequiredNamespace(
            methods: [
              'eth_sign',
              'eth_signTransaction',
              'eth_sendTransaction',
            ],
            chains: ['eip155:11155111'],
            events: [
              'chainChanged',
              'accountsChanged',
            ],
          ),
        },
        optionalNamespaces: {
          'eip155': const RequiredNamespace(
            methods: ['wallet_switchEthereumChain', 'wallet_addEthereumChain', 'eth_chainId'],
            chains: ['eip155:11155111'],
            events: [],
          ),
        },
        rpcUrl: 'https://rpc2.sepolia.org/',
        blockExplorer: BlockExplorer(
          name: 'Explorer',
          url: 'https://sepolia.etherscan.io/',
        ),
        nativeCurrency: NativeCurrency(
          name: 'Eth',
          symbol: 'ETH',
          decimals: 18,
        )),
    280: ChainInfo(
        chainName: 'zkSync Era testnet',
        namespace: 'eip155:280',
        chainId: '280',
        chainIdHex: '0x118',
        chainIconLocally: chainImagesPath['280'],
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
            methods: ['wallet_switchEthereumChain', 'wallet_addEthereumChain', 'eth_chainId'],
            chains: ['eip155:280'],
            events: [],
          ),
        },
        rpcUrl: '{"jsonrpc":"2.0","id":null,"error":{"code":-32700,"message":"Parse error"}}',
        blockExplorer: BlockExplorer(
          name: 'Explorer',
          url: 'https://explorer.zksync.io/',
        ),
        nativeCurrency: NativeCurrency(
          name: 'ETH',
          symbol: 'ETH',
          decimals: 18,
        )),
    80001: ChainInfo(
        chainName: 'Polygon Mumbai',
        namespace: 'eip155:80001',
        chainId: '80001',
        chainIdHex: '0x13881',
        chainIconLocally: chainImagesPath['80001'],
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
            methods: ['wallet_switchEthereumChain', 'wallet_addEthereumChain', 'eth_chainId'],
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
        )),
    168587773: ChainInfo(
        chainName: 'Blast Sepolia',
        namespace: 'eip155:168587773',
        chainId: '168587773',
        chainIdHex: '0xA0C71FD',
        chainIconLocally: chainImagesPath['168587773'],
        iconUrl: '',
        requiredNamespaces: {
          'eip155': const RequiredNamespace(
            methods: [
              'eth_sign',
              'eth_signTransaction',
              'eth_sendTransaction',
            ],
            chains: ['eip155:168587773'],
            events: [
              'chainChanged',
              'accountsChanged',
            ],
          ),
        },
        optionalNamespaces: {
          'eip155': const RequiredNamespace(
            methods: ['wallet_switchEthereumChain', 'wallet_addEthereumChain', 'eth_chainId'],
            chains: ['eip155:168587773'],
            events: [],
          ),
        },
        rpcUrl: 'https://sepolia.blast.io',
        blockExplorer: BlockExplorer(
          name: 'Explorer',
          url: 'https://testnet.blastscan.io/',
        ),
        nativeCurrency: NativeCurrency(
          name: 'Eth',
          symbol: 'ETH',
          decimals: 18,
        )),
    534351: ChainInfo(
        chainName: 'Scroll Sepolia',
        namespace: 'eip155:534351',
        chainId: '534351',
        chainIdHex: '0x8274f',
        chainIconLocally: chainImagesPath['534351'],
        iconUrl: '',
        requiredNamespaces: {
          'eip155': const RequiredNamespace(
            methods: [
              'eth_sign',
              'eth_signTransaction',
              'eth_sendTransaction',
            ],
            chains: ['eip155:534351'],
            events: [
              'chainChanged',
              'accountsChanged',
            ],
          ),
        },
        optionalNamespaces: {
          'eip155': const RequiredNamespace(
            methods: ['wallet_switchEthereumChain', 'wallet_addEthereumChain', 'eth_chainId'],
            chains: ['eip155:534351'],
            events: [],
          ),
        },
        rpcUrl: 'https://scroll-sepolia.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f',
        blockExplorer: BlockExplorer(
          name: 'Explorer',
          url: 'https://sepolia.scrollscan.com/',
        ),
        nativeCurrency: NativeCurrency(
          name: 'Eth',
          symbol: 'ETH',
          decimals: 18,
        )),
    3441005: ChainInfo(
        chainName: 'Manta testnet',
        namespace: 'eip155:3441005',
        chainId: '3441005',
        chainIdHex: '0x34816D',
        chainIconLocally: chainImagesPath['3441005'],
        iconUrl: '',
        requiredNamespaces: {
          'eip155': const RequiredNamespace(
            methods: [
              'eth_sign',
              'eth_signTransaction',
              'eth_sendTransaction',
            ],
            chains: ['eip155:3441005'],
            events: [
              'chainChanged',
              'accountsChanged',
            ],
          ),
        },
        optionalNamespaces: {
          'eip155': const RequiredNamespace(
            methods: ['wallet_switchEthereumChain', 'wallet_addEthereumChain', 'eth_chainId'],
            chains: ['eip155:3441005'],
            events: [],
          ),
        },
        rpcUrl: 'https://pacific-rpc.testnet.manta.network/http',
        blockExplorer: BlockExplorer(
          name: 'Explorer',
          url: 'https://pacific-explorer.testnet.manta.network',
        ),
        nativeCurrency: NativeCurrency(
          name: 'Eth',
          symbol: 'ETH',
          decimals: 18,
        )),
    1442: ChainInfo(
        chainName: 'zkEVM Polygon',
        namespace: 'eip155:1442',
        chainId: '1442',
        chainIdHex: '0x5A2',
        chainIconLocally: chainImagesPath['1442'],
        iconUrl: '',
        requiredNamespaces: {
          'eip155': const RequiredNamespace(
            methods: [
              'eth_sign',
              'eth_signTransaction',
              'eth_sendTransaction',
            ],
            chains: ['eip155:1442'],
            events: [
              'chainChanged',
              'accountsChanged',
            ],
          ),
        },
        optionalNamespaces: {
          'eip155': const RequiredNamespace(
            methods: ['wallet_switchEthereumChain', 'wallet_addEthereumChain', 'eth_chainId'],
            chains: ['eip155:1442'],
            events: [],
          ),
        },
        rpcUrl: 'https://polygon-zkevm-testnet.blastapi.io/5adb17c5-f79f-4542-b37c-b9cf98d6b28f',
        blockExplorer: BlockExplorer(
          name: 'Explorer',
          url: 'https://explorer.public.zkevm-test.net',
        ),
        nativeCurrency: NativeCurrency(
          name: 'Eth',
          symbol: 'ETH',
          decimals: 18,
        )),
    3110: ChainInfo(
        chainName: 'satoshiVM',
        namespace: 'eip155:3110',
        chainId: '3110',
        chainIdHex: '0xC26',
        chainIconLocally: chainImagesPath['3110'],
        iconUrl: '',
        requiredNamespaces: {
          'eip155': const RequiredNamespace(
            methods: [
              'eth_sign',
              'eth_signTransaction',
              'eth_sendTransaction',
            ],
            chains: ['eip155:3110'],
            events: [
              'chainChanged',
              'accountsChanged',
            ],
          ),
        },
        optionalNamespaces: {
          'eip155': const RequiredNamespace(
            methods: ['wallet_switchEthereumChain', 'wallet_addEthereumChain', 'eth_chainId'],
            chains: ['eip155:3110'],
            events: [],
          ),
        },
        rpcUrl: 'https://test-rpc-node-http.svmscan.io',
        blockExplorer: BlockExplorer(
          name: 'Explorer',
          url: 'https://testnet.svmscan.io/',
        ),
        nativeCurrency: NativeCurrency(
          name: 'Eth',
          symbol: 'ETH',
          decimals: 18,
        )),
    1029: ChainInfo(
        chainName: 'BTTC',
        namespace: 'eip155:1029',
        chainId: '1029',
        chainIdHex: '0x405',
        chainIconLocally: chainImagesPath['1029'],
        iconUrl: '',
        requiredNamespaces: {
          'eip155': const RequiredNamespace(
            methods: [
              'eth_sign',
              'eth_signTransaction',
              'eth_sendTransaction',
            ],
            chains: ['eip155:1029'],
            events: [
              'chainChanged',
              'accountsChanged',
            ],
          ),
        },
        optionalNamespaces: {
          'eip155': const RequiredNamespace(
            methods: ['wallet_switchEthereumChain', 'wallet_addEthereumChain', 'eth_chainId'],
            chains: ['eip155:1029'],
            events: [],
          ),
        },
        rpcUrl: 'https://pre-rpc.bt.io',
        blockExplorer: BlockExplorer(
          name: 'Explorer',
          url: 'https://testscan.bt.io/',
        ),
        nativeCurrency: NativeCurrency(
          name: 'Eth',
          symbol: 'ETH',
          decimals: 18,
        )),
  };

  static Map<String, String> chainImagesPath = {
    // Dodao Tanssi
    '855456': 'assets/images/logo.png',
    // Moonbase,
    '1287': 'assets/images/net_icon_moonbeam.png',
    // Fantom testnet
    '4002': 'assets/images/net_icon_fantom.png',
    // Fantom sonic
    '64165': 'assets/images/net_icon_fantom_sonic.png',
    // Goerli
    '5': 'assets/images/net_icon_eth.png',
    // zkSync
    '280': 'assets/images/zksync.png',
    // Polygon Mumbai
    '80001': 'assets/images/net_icon_mumbai_polygon.png',
    // Sepolia
    '11155111': 'assets/images/net_icon_sepolia.png',
    // Blast Sepolia
    '': 'assets/images/net_icon_blast.png',
    // Scroll Sepolia
    '534351': 'assets/images/net_icon_scroll.png',
    // Manta Testnet
    '3441005': 'assets/images/net_icon_manta.png',
    // zkEVM Polygon
    '1442': 'assets/images/net_icon_zkevm.png',
    // Scroll Sepolia
    '3110': 'assets/images/net_icon_satoshivm.png',
  };
}
