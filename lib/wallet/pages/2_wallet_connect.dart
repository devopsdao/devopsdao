import 'package:dodao/wallet/pages/2_wallet_connect_sections/pairings_section.dart';
import 'package:dodao/wallet/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../blockchain/interface.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '2_wallet_connect_sections/qr_code.dart';
import '../widgets/wallet_connect_button.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

enum WCPlatform { done, open, await }

class WalletConnect extends StatefulWidget {
  final double screenHeightSizeNoKeyboard;
  final double innerPaddingWidth;
  final Function callConnectWallet;

  const WalletConnect({
    Key? key,
    required this.screenHeightSizeNoKeyboard,
    required this.innerPaddingWidth,
    required this.callConnectWallet,
  }) : super(key: key);

  @override
  _WalletConnectState createState() => _WalletConnectState();
}

class _WalletConnectState extends State<WalletConnect> {
  // late String _displayUri = '';
  int defaultTab = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TasksServices tasksServices = context.read<TasksServices>();
    WalletProvider walletProvider = context.watch<WalletProvider>();

    if (tasksServices.platform == 'linux') {
      defaultTab = 1;
    } else if (tasksServices.platform == 'web' && tasksServices.browserPlatform != 'android' && tasksServices.browserPlatform != 'ios') {
      defaultTab = 1;
    } else if (tasksServices.platform == 'mobile' || tasksServices.browserPlatform == 'android' || tasksServices.browserPlatform == 'ios') {
      defaultTab = 0;
    }

    late String buttonText = '';

    final Widget wcConnectButton = Builder(builder: (context) {
      if (walletProvider.wcCurrentState == WCStatus.loadingQr ||
          walletProvider.wcCurrentState == WCStatus.loadingWc ||
          walletProvider.wcCurrentState == WCStatus.wcConnectedNetworkMatch) {
        buttonText = 'Disconnect';
      } else if (walletProvider.wcCurrentState == WCStatus.wcConnectedNetworkNotMatch ||
          walletProvider.wcCurrentState == WCStatus.wcConnectedNetworkUnknown ||
          walletProvider.wcCurrentState == WCStatus.none) {
        buttonText = 'Switch network';
      } else if (walletProvider.wcCurrentState == WCStatus.wcNotConnectedWithQrReady) {
        buttonText = 'Refresh QR';
      } else if (walletProvider.wcCurrentState == WCStatus.wcNotConnected || walletProvider.wcCurrentState == WCStatus.error) {
        buttonText = 'Connect';
      }
      return WalletConnectButton(
        buttonFunction: 'wallet_connect',
        buttonName: buttonText,
        callback: () async {
          if (walletProvider.initComplete) {
            // walletProvider.walletConnectUri = ''; // reset _displayUri
            if ( // if button Refresh Qr, Connect or disconnect:
                walletProvider.wcCurrentState == WCStatus.wcNotConnected ||
                    walletProvider.wcCurrentState == WCStatus.wcNotConnectedWithQrReady ||
                    walletProvider.wcCurrentState == WCStatus.wcConnectedNetworkMatch ||
                    walletProvider.wcCurrentState == WCStatus.loadingQr ||
                    walletProvider.wcCurrentState == WCStatus.loadingWc ||
                    walletProvider.wcCurrentState == WCStatus.error) {
              await widget.callConnectWallet();
            } else if ( //if chain does not match
                walletProvider.wcCurrentState == WCStatus.none ||
                    walletProvider.wcCurrentState == WCStatus.wcConnectedNetworkNotMatch ||
                    walletProvider.wcCurrentState == WCStatus.wcConnectedNetworkUnknown) {
              await walletProvider.switchNetwork(
                tasksServices,
                // tasksServices.allowedChainIds[walletProvider.chainNameOnWallet]!,
                tasksServices.allowedChainIds[walletProvider.selectedChainNameOnApp]!,
              );
            }
          }
        },
      );
    });

    //// ********************* Wallet Connect > Desktop page ************** ////
    final Widget firstTab = Stack(
      alignment: Alignment.center,
      children: [
        if (tasksServices.platform == 'mobile' || tasksServices.browserPlatform == 'android' || tasksServices.browserPlatform == 'ios')
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 22),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: Text(
                  tasksServices.walletConnectedWC ? 'Wallet connected' : 'Wallet disconnected',
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
            tasksServices.platform == 'web' && tasksServices.browserPlatform != 'android' && tasksServices.browserPlatform != 'ios')
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
        WcQrCode(callConnectWallet: widget.callConnectWallet, screenHeightSizeNoKeyboard: widget.screenHeightSizeNoKeyboard),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Material(
                elevation: DodaoTheme.of(context).elevation,
                borderRadius: DodaoTheme.of(context).borderRadius,
                child: Container(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10, bottom: 10),
                  height: widget.screenHeightSizeNoKeyboard - 36,
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
                                  PairingsPage(web3App: walletProvider.web3App!),
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
    );
  }
}
