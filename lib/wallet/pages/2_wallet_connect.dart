import 'package:dodao/wallet/pages/pairings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../blockchain/task_services.dart';
import '../../config/theme.dart';
import '../widgets/network_selection.dart';
import '../widgets/wallet_connect_button.dart';

class WalletConnect extends StatefulWidget {
  final double screenHeightSizeNoKeyboard;
  final double innerPaddingWidth;
  const WalletConnect({
    Key? key,
    required this.screenHeightSizeNoKeyboard,
    required this.innerPaddingWidth,
  }) : super(key: key);

  @override
  _WalletConnectState createState() => _WalletConnectState();
}

class _WalletConnectState extends State<WalletConnect> {
  // late String _displayUri = '';
  int defaultTab = 0;
  final double qrSize = 210;
  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    // _displayUri = tasksServices.walletConnectUri;

    if (tasksServices.walletConnectedWC) {
      tasksServices.walletConnectUri = '';
    }

    if (tasksServices.platform == 'linux') {
      defaultTab = 1;
    } else if (tasksServices.platform == 'web' && tasksServices.browserPlatform != 'android' && tasksServices.browserPlatform != 'ios') {
      defaultTab = 1;
    } else if (tasksServices.platform == 'mobile' || tasksServices.browserPlatform == 'android' || tasksServices.browserPlatform == 'ios') {
      defaultTab = 0;
    }

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


                                // *********** Wallet Connect > Mobile page ************ //
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
                                      WalletConnectButton(
                                        buttonFunction: 'wallet_connect',
                                        buttonName: 'Connect',
                                        callback: () {

                                        },
                                      ),
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
                                      WalletConnectButton(
                                        buttonFunction: 'wallet_connect',
                                        buttonName: 'Connect',
                                        callback: () {  },
                                      ),
                                      const SizedBox(height: 22),
                                    ],
                                  ),
                                // *********** Wallet Connect > QR Code page ************ //
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AnimatedCrossFade(
                                      crossFadeState: tasksServices.walletConnectUri.isNotEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                      duration: const Duration(milliseconds: 500),
                                      sizeCurve: Curves.easeInOutQuart,
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
                                            NetworkSelection(wConnected: false, qrSize: qrSize),
                                            const SizedBox(
                                                height: 8,
                                            ),
                                            if (tasksServices.walletConnectUri.isNotEmpty)
                                              QrImageView(
                                                padding: const EdgeInsets.all(0),
                                                data: tasksServices.walletConnectUri,
                                                size: qrSize,
                                                gapless: false,
                                                backgroundColor: Colors.white,
                                              ),
                                          ],
                                        ),
                                      ),
                                      secondChild: SizedBox(
                                        height: widget.screenHeightSizeNoKeyboard - 190,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if (!tasksServices.validChainIDWC && !tasksServices.walletConnectedWC)
                                              Padding(
                                                padding: const EdgeInsets.all(14.0),
                                                child: RichText(
                                                    text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: const <TextSpan>[
                                                      TextSpan(text: 'QR requested, please wait'),
                                                    ])),
                                              ),
                                            if (!tasksServices.validChainIDWC && !tasksServices.walletConnectedWC)
                                              Shimmer.fromColors(
                                                baseColor: DodaoTheme.of(context).shimmerBaseColor,
                                                highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
                                                child: NetworkSelection(wConnected: false, qrSize: qrSize)
                                              ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            if (!tasksServices.validChainIDWC && !tasksServices.walletConnectedWC)
                                              Shimmer.fromColors(
                                                baseColor: DodaoTheme.of(context).shimmerBaseColor,
                                                highlightColor: DodaoTheme.of(context).shimmerHighlightColor,
                                                child: Container(
                                                  height: qrSize,
                                                  width: qrSize,
                                                  color: Colors.white,
                                                ),
                                              ),

                                            // if (!tasksServices.validChainIDWC && tasksServices.walletConnectedWC)
                                            if (tasksServices.validChainIDWC && tasksServices.walletConnectedWC)
                                              NetworkSelection(wConnected: true, qrSize: qrSize)
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 14.0),
                                      child: Text(
                                        tasksServices.walletConnectedWC ? 'Wallet connected ${tasksServices.allowedChainIds.values.contains(tasksServices.chainId)}' : 'Wallet disconnected',
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    WalletConnectButton(
                                      buttonFunction: 'wallet_connect',
                                      buttonName: 'Refresh QR',
                                      callback: () {
                                        setState(() {
                                          tasksServices.walletConnectUri = ''; // reset _displayUri
                                          // _displayUri = '';
                                          tasksServices.myNotifyListeners();

                                        });
                                      },
                                    ),
                                    const SizedBox(height: 22),
                                  ],
                                ),

                                Column(
                                  children: [
                                    if (tasksServices.walletConnectedWC)
                                      PairingsPage(
                                          web3App: tasksServices.walletConnectClient.walletConnect
                                      ),
                                    if (!tasksServices.walletConnectedWC)
                                      const SizedBox(
                                          height: 150,
                                          child: Center(child: Text('Please connect your wallet'),)),
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
