import 'package:dodao/wallet/pages/2_wallet_connect_sections/pairings_section.dart';
import 'package:dodao/wallet/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../blockchain/interface.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../widgets/network_selection.dart';
import '../widgets/wallet_connect_button.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

enum WCStatus {
  wcConnectedNetworkMatch,
  wcConnectedNetworkNotMatch,
  wcConnectedNetworkUnknown,
  wcNotConnected
}

enum WCPlatform {
  done,
  open,
  await
}

class WalletConnect extends StatefulWidget {
  final double screenHeightSizeNoKeyboard;
  final double innerPaddingWidth;
  final Function callConnectWallet;
  final Function callDisconnectWallet;

  const WalletConnect({
    Key? key,
    required this.screenHeightSizeNoKeyboard,
    required this.innerPaddingWidth,
    required this.callConnectWallet,
    required this.callDisconnectWallet,
  }) : super(key: key);

  @override
  _WalletConnectState createState() => _WalletConnectState();
}

class _WalletConnectState extends State<WalletConnect> {
  // late String _displayUri = '';
  int defaultTab = 0;
  final double qrSize = 200;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    WalletProvider walletProvider = context.watch<WalletProvider>();

    // String networkNameOnWallet = tasksServices.allowedChainIds.keys.firstWhere((k) => tasksServices.allowedChainIds[k]==walletProvider.chainIdOnWallet, orElse: () => 'unknown');
    String networkNameOnApp = tasksServices.allowedChainIds.entries.firstWhere((e) => e.key==walletProvider.chainNameOnApp).key;

    late WCStatus wcStatus = WCStatus.wcNotConnected;

    //Network chain matched check:
    bool networkChainsMatched;
    walletProvider.chainNameOnWallet == walletProvider.chainNameOnApp ? networkChainsMatched =true : networkChainsMatched =false;

    if (tasksServices.walletConnectedWC && networkChainsMatched && !walletProvider.unknownChainIdWC) {
      wcStatus = WCStatus.wcConnectedNetworkMatch;
    } else if (tasksServices.walletConnectedWC && networkChainsMatched && !walletProvider.unknownChainIdWC) {
      wcStatus = WCStatus.wcConnectedNetworkNotMatch;
    } else if (walletProvider.unknownChainIdWC) {
      wcStatus = WCStatus.wcConnectedNetworkUnknown;
    } else if (!tasksServices.walletConnectedWC) {
      wcStatus = WCStatus.wcNotConnected;
    }

    if (tasksServices.walletConnectedWC) {
      walletProvider.walletConnectUri = '';
    }

    if (tasksServices.platform == 'linux') {
      defaultTab = 1;
    } else if (tasksServices.platform == 'web' && tasksServices.browserPlatform != 'android' && tasksServices.browserPlatform != 'ios') {
      defaultTab = 1;
    } else if (tasksServices.platform == 'mobile' || tasksServices.browserPlatform == 'android' || tasksServices.browserPlatform == 'ios') {
      defaultTab = 0;
    }

    late String buttonText = '';

    final Widget shimmer = Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: RichText(
              text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: const <TextSpan>[
                TextSpan(text: 'QR requested, please wait'),
              ])),
        ),
        Shimmer.fromColors(
            baseColor: DodaoTheme.of(context).shimmerBaseColor,
            highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
            child: NetworkSelection(
              qrSize: qrSize,
              callConnectWallet: (){},
            )
        ),
        const SizedBox(
          height: 8,
        ),
        Shimmer.fromColors(
          baseColor: DodaoTheme.of(context).shimmerBaseColor,
          highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
          child: Container(
            height: qrSize,
            width: qrSize,
            color: Colors.white,
          ),
        ),
      ],
    );

    final Widget wcConnectButton = Builder(
      builder: (context) {
        if (wcStatus == WCStatus.wcConnectedNetworkMatch || wcStatus == WCStatus.wcConnectedNetworkUnknown) {
          buttonText = 'Disconnect';
        } else if (wcStatus == WCStatus.wcConnectedNetworkNotMatch)  {
          buttonText = 'Switch network';
        } else if (wcStatus == WCStatus.wcNotConnected) {
          // buttonText = 'Connect';
          buttonText = 'Refresh QR';
        }
        return WalletConnectButton(
          buttonFunction: 'wallet_connect',
          buttonName: buttonText,
          callback: () async {
            if (walletProvider.initComplete) {
              if (wcStatus == WCStatus.wcConnectedNetworkMatch) {
                await widget.callDisconnectWallet();
              } else if (wcStatus == WCStatus.wcConnectedNetworkNotMatch) {
                await walletProvider.switchNetwork(tasksServices,tasksServices.allowedChainIds[walletProvider.chainNameOnWallet]!, tasksServices.allowedChainIds[walletProvider.chainNameOnApp]!,
                );
              } else if (wcStatus == WCStatus.wcNotConnected) {
                walletProvider.walletConnectUri = ''; // reset _displayUri
                await widget.callConnectWallet();
                tasksServices.myNotifyListeners();
              }
            }
          },
        );
      }
    );


    //// ********************* Wallet Connect > Desktop page ************** ////
    final Widget firstTab = Stack(
      alignment: Alignment.center,
      children: [
        if (tasksServices.platform == 'mobile' ||
            tasksServices.browserPlatform == 'android' ||
            tasksServices.browserPlatform == 'ios')
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 22),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: Text(
                  tasksServices.walletConnectedWC ? 'Wallet connected to ${tasksServices.allowedChainIds.values.contains(tasksServices.chainId)}' : 'Wallet disconnected',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
              /// wcConnectButton
              wcConnectButton,
              const SizedBox(height: 22),
            ],
          ),
        // *********** Wallet Connect > Desktop page ************ //
        if (tasksServices.platform == 'linux' ||
            tasksServices.platform == 'web' &&
                tasksServices.browserPlatform != 'android' &&
                tasksServices.browserPlatform != 'ios')
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 22),
              RichText(
                  text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: const <TextSpan>[
                    TextSpan(text: 'Connect to Desktop Wallet'),
                  ])),
              const Spacer(),
              /// wcConnectButton
              wcConnectButton,
              const SizedBox(height: 22),
            ],
          ),
      ],
    );


    //// ********************* Wallet Connect > QR Code page ************** ////
    final Widget secondTab = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedCrossFade(
          crossFadeState: walletProvider.walletConnectUri.isNotEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 200),
          sizeCurve: Curves.easeInOutQuart,

          /////// *********** Has URL ************ /////////
          firstChild: SizedBox(
            height: widget.screenHeightSizeNoKeyboard - 190,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: RichText(
                      text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: const <TextSpan>[
                        TextSpan(text: 'Scan QR or select network'),
                      ])),
                ),
                // const Spacer(),
                NetworkSelection(
                  qrSize: qrSize,
                  callConnectWallet: widget.callConnectWallet,
                ),
                const SizedBox(
                  height: 8,
                ),
                if (walletProvider.walletConnectUri.isNotEmpty)
                QrImageView(
                  padding: const EdgeInsets.all(0),
                  data: walletProvider.walletConnectUri,
                  size: qrSize,
                  gapless: false,
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),


          /////// *********** NO URL ************ /////////
          secondChild: SizedBox(
            height: widget.screenHeightSizeNoKeyboard - 190,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (wcStatus == WCStatus.wcNotConnected)
                  shimmer,
                if (wcStatus == WCStatus.wcConnectedNetworkNotMatch)
                  Text(
                    'Switch on your wallet ${walletProvider.chainNameOnWallet} '
                        ' network to ${networkNameOnApp}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                if (wcStatus == WCStatus.wcConnectedNetworkUnknown)
                  Text(
                    'Unfortunately, network is not supported',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                // if (!tasksServices.unknownChainIdWC && tasksServices.walletConnectedWC)
                if (wcStatus == WCStatus.wcConnectedNetworkNotMatch)
                  Container(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: NetworkSelection(
                      qrSize: qrSize,
                      callConnectWallet: widget.callConnectWallet,
                    ),
                  ),
                if (tasksServices.walletConnectedWC && wcStatus == WCStatus.wcConnectedNetworkMatch)
                  Column(
                    children: [
                      Text(
                        'Current network: \n ${networkNameOnApp}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      Container(
                          padding: const EdgeInsets.all(15.0),
                          height: 140,
                          child: walletProvider.networkLogo(tasksServices.allowedChainIds[walletProvider.chainNameOnApp], Colors.white, 80)
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 14.0),
          child: Text(
            tasksServices.walletConnectedWC ? 'Wallet connected' : 'Wallet disconnected',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
        wcConnectButton,
        const SizedBox(height: 22),
      ],
    );






    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: widget.screenHeightSizeNoKeyboard - 300,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Material(
                  elevation: DodaoTheme.of(context).elevation,
                  borderRadius: DodaoTheme.of(context).borderRadius,
                  child: Container(
                    padding: const EdgeInsets.only(left: 26.0, right: 26.0, top: 10, bottom: 10),
                    height: widget.screenHeightSizeNoKeyboard - 40,
                    width: widget.innerPaddingWidth,
                    decoration: BoxDecoration(
                      borderRadius: DodaoTheme.of(context).borderRadius,
                      border: DodaoTheme.of(context).borderGradient,
                    ),
                    child: DefaultTabController(
                      length: 3,
                      initialIndex: defaultTab,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                            child: TabBar(
                              labelColor: DodaoTheme.of(context).secondaryText,
                              indicatorColor: DodaoTheme.of(context).tabIndicator,
                              unselectedLabelColor: Colors.grey,
                              tabs: [
                                Container(
                                  color: Colors.transparent,
                                  width: 120,
                                  child: Tab(
                                      child: Text(tasksServices.platform == 'mobile' ||
                                          tasksServices.browserPlatform == 'android' ||
                                          tasksServices.browserPlatform == 'ios'
                                          ? 'Mobile'
                                          : 'Desktop')),
                                ),
                                const SizedBox(
                                  width: 120,
                                  child: Tab(child: Text('QR Code')),
                                ),
                                const SizedBox(
                                  width: 120,
                                  child: Icon(Icons.settings),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                // *********** Wallet Connect > Mobile tab ************ //
                                firstTab,
                                // *********** Wallet Connect > QR Code tab  ************ //
                                secondTab,
                                // *********** Wallet Connect > System info tab ************ //
                                Column(
                                  children: [
                                      PairingsPage(
                                          web3App: walletProvider.web3App!
                                      ),
                                    // if (!tasksServices.walletConnectedWC)
                                    //   const SizedBox(
                                    //       height: 150,
                                    //       child: Center(child: Text('Please connect your wallet'),)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );





  }
}
