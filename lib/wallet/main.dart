import 'package:dodao/wallet/widgets/transport_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../blockchain/interface.dart';
import '../config/theme.dart';
import 'algorand_walletconnect_transaction.dart';
import 'ethereum_walletconnect_transaction.dart';
import 'walletconnect_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:provider/provider.dart';
import 'package:dodao/blockchain/task_services.dart';

// void main() {
//   runApp(const MyApp());
// }

enum NetworkType {
  ethereum,
  algorand,
}

enum TransactionState {
  disconnected,
  connecting,
  connected,
  connectionFailed,
  transferring,
  success,
  failed,
}

class WalletPageTop extends StatefulWidget {
  const WalletPageTop({
    Key? key,
  }) : super(key: key);

  @override
  _WalletPageTopState createState() => _WalletPageTopState();
}

class _WalletPageTopState extends State<WalletPageTop> {
  String txId = '';
  String _displayUri = '';
  var session;
  String backgroundPicture = "assets/images/logo_half.png";

  static const _networks = ['Ethereum (Ropsten)', 'Algorand (Testnet)'];
  NetworkType? _network = NetworkType.ethereum;
  // TransactionState _state = TransactionState.disconnected;
  // TransactionState _state2 = TransactionState.disconnected;
  // WallectConnectTransaction? _wallectConnectTransaction = EthereumWallectConnectTransaction();
  late WallectConnectTransaction? _wallectConnectTransaction;

  bool disableBackButton = true;

  @override
  void dispose() {
    super.dispose();
  }

  late String dropdownValue = 'axelar';
  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    if (tasksServices.walletConnectedWC || tasksServices.walletConnectedMM) {
      if (tasksServices.walletConnectedMM) {
        interface.controller = PageController(initialPage: 1);
      } else if (tasksServices.walletConnectedWC) {
        interface.controller = PageController(initialPage: 2);
      }
    } else {
      interface.controller = PageController(initialPage: 0);
    }

    final double borderRadius = interface.borderRadius;

    if (interface.pageWalletViewNumber == 0) {
      disableBackButton = true;
    } else {
      if (tasksServices.walletConnectedMM || tasksServices.walletConnectedWC) {
        disableBackButton = true;
      } else {
        disableBackButton = false;
      }
    }

    _displayUri = tasksServices.walletConnectUri;
    // if (tasksServices.walletConnectUri != '') {
    //   _displayUri = tasksServices.walletConnectUri;
    // }
    if (tasksServices.walletConnectedWC) {
      tasksServices.walletConnectUri = '';
    }

    if (tasksServices.closeWalletDialog) {
      Navigator.pop(context);
      tasksServices.closeWalletDialog = false;
    }

    // int page = interface.pageWalletViewNumber;

    return LayoutBuilder(builder: (context, constraints) {
      return StatefulBuilder(builder: (context, setState) {
        final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
        final double screenHeightSizeNoKeyboard = constraints.maxHeight * .7;
        final double screenHeightSize = screenHeightSizeNoKeyboard - keyboardSize;
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: DodaoTheme.of(context).borderRadius,
          ),
          backgroundColor: DodaoTheme.of(context).walletBackgroundColor,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: DodaoTheme.of(context).borderRadius,
              color: DodaoTheme.of(context).walletBackgroundColor,
            ),
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 10),
                    width: 400,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          child: !disableBackButton
                              ? InkWell(
                                  onTap: () {
                                    interface.controller.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                                  },
                                  borderRadius: DodaoTheme.of(context).borderRadius,
                                  child: Container(
                                    padding: const EdgeInsets.all(0.0),
                                    height: 30,
                                    width: 30,
                                    child: const Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Icon(
                                            Icons.arrow_back,
                                            size: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        const Spacer(),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Connect Wallet',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // InkWell(
                        //   onTap: () {
                        //
                        //     showDialog(context: context, builder: (context) => Dialog(
                        //       shape: const RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        //         child: SizedBox(
                        //           height: 100,
                        //           width: 350,
                        //           child: Padding(
                        //               padding: const EdgeInsets.all(30.0),
                        //             child: DropdownButton(
                        //               isExpanded: true,
                        //               value: dropdownValue,
                        //               hint: Text('Choose transport ($dropdownValue)'),
                        //               items: const [
                        //                 DropdownMenuItem(value: 'axelar', child: Text('axelar')),
                        //                 DropdownMenuItem(value: 'hyperlane', child: Text('hyperlane')),
                        //                 DropdownMenuItem(value: 'layerzero', child: Text('layerzero')),
                        //                 DropdownMenuItem(value: 'wormhole', child: Text('wormhole')),
                        //               ],
                        //               underline: Container(
                        //                 height: 2,
                        //                 color: Colors.black26,
                        //               ),
                        //               onChanged: (String? value) {
                        //                 tasksServices.interchainSelected = value!;
                        //                 setState(() {
                        //                   dropdownValue = value!;
                        //                 });
                        //                 Navigator.pop(context);
                        //
                        //               },
                        //             )
                        //           ),
                        //         )
                        //       )
                        //     );
                        //   },
                        //   borderRadius: BorderRadius.circular(16),
                        //   child: Container(
                        //     padding: const EdgeInsets.all(0.0),
                        //     height: 30,
                        //     width: 30,
                        //     // decoration: BoxDecoration(
                        //     //   borderRadius: BorderRadius.circular(6),
                        //     // ),
                        //     child: Row(
                        //       children: const <Widget>[
                        //
                        //         Expanded(
                        //           child: Icon(
                        //             Icons.info_outline_rounded,
                        //             size: 30,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        InkWell(
                          onTap: () {
                            if (tasksServices.walletConnectedMM) {
                              interface.pageWalletViewNumber = 1;
                            } else if (tasksServices.walletConnectedWC) {
                              interface.pageWalletViewNumber = 2;
                            } else {
                              interface.pageWalletViewNumber = 0;
                            }
                            //
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(0.0),
                            height: 30,
                            width: 30,
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(6),
                            // ),
                            child: Row(
                              children: const <Widget>[
                                Expanded(
                                  child: Icon(
                                    Icons.close,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: screenHeightSize,
                    // width: constraints.maxWidth * .8,
                    // height: 550,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: DodaoTheme.of(context).borderRadius,
                      image: DecorationImage(image: AssetImage(backgroundPicture), fit: BoxFit.cover, opacity: 0.6),
                    ),
                    child: WalletPagesMiddle(
                      borderRadius: borderRadius,
                      screenHeightSize: screenHeightSize,
                      screenHeightSizeNoKeyboard: screenHeightSizeNoKeyboard,
                    ),
                  ),
                  // Container(height: 10),
                ]),
          ),
        );
      });
    });
  }

  void _changeNetworks(String? network) {
    if (network == null) return;
    final newNetworkIndex = _networks.indexOf(network);
    final newNetwork = NetworkType.values[newNetworkIndex];

    switch (newNetwork) {
      case NetworkType.algorand:
        _wallectConnectTransaction = AlgorandWalletConnectTransaction();
        break;
      case NetworkType.ethereum:
        _wallectConnectTransaction = EthereumWallectConnectTransaction();
        break;
    }

    setState(
      () => _network = newNetwork,
    );
  }
}

class WalletPagesMiddle extends StatefulWidget {
  // final String buttonFunction;
  final double borderRadius;
  final double screenHeightSize;
  final double screenHeightSizeNoKeyboard;

  const WalletPagesMiddle({
    Key? key,
    // required this.buttonFunction,
    required this.borderRadius,
    required this.screenHeightSize,
    required this.screenHeightSizeNoKeyboard,
  }) : super(key: key);

  @override
  _WalletPagesMiddleState createState() => _WalletPagesMiddleState();
}

class _WalletPagesMiddleState extends State<WalletPagesMiddle> {
  String _displayUri = '';
  int defaultTab = 0;
  late String dropdownValue = 'axelar';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    var tasksServices = context.watch<TasksServices>();

    _displayUri = tasksServices.walletConnectUri;
    // if (tasksServices.walletConnectUri != '') {
    //   _displayUri = tasksServices.walletConnectUri;
    // }
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

    return LayoutBuilder(builder: (ctx, dialogConstraints) {
      double innerPaddingWidth = dialogConstraints.maxWidth - 60;
      return PageView(
        scrollDirection: Axis.horizontal,
        // pageSnapping: false,
        // physics: BouncingScrollPhysics(),
        physics: const NeverScrollableScrollPhysics(),
        controller: interface.controller,
        onPageChanged: (number) {
          interface.pageWalletViewNumber = number;
          tasksServices.myNotifyListeners();
        },
        children: <Widget>[
          Column(
            children: [
              const SizedBox(height: 30),
              // const Spacer(),
              Material(
                color: DodaoTheme.of(context).walletBackgroundColor,
                elevation: DodaoTheme.of(context).elevation,
                borderRadius: DodaoTheme.of(context).borderRadius,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  // height: MediaQuery.of(context).size.width * .08,
                  // width: MediaQuery.of(context).size.width * .57
                  width: innerPaddingWidth,
                  decoration: BoxDecoration(
                    color: DodaoTheme.of(context).walletBackgroundColor,
                    borderRadius: DodaoTheme.of(context).borderRadius,
                    border: DodaoTheme.of(context).borderGradient,
                  ),
                  child: Text('By connecting a wallet, you agree to Terms of Service and Privacy Policy.',
                      textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
                ),
              ),

              const Spacer(),
              if (tasksServices.platform == 'web' && tasksServices.mmAvailable)
                ChooseWalletButton(
                  active: tasksServices.platform == 'web' && tasksServices.mmAvailable ? true : false,
                  buttonFunction: 'metamask',
                  borderRadius: widget.borderRadius,
                  buttonWidth: innerPaddingWidth,
                ),
              if (tasksServices.platform == 'web' && tasksServices.mmAvailable) const SizedBox(height: 12),
              ChooseWalletButton(
                active: true,
                buttonFunction: 'wallet_connect',
                borderRadius: widget.borderRadius,
                buttonWidth: innerPaddingWidth,
              ),
              const Spacer(),
            ],
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (interface.whichWalletButtonPressed == 'metamask')
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                firstChild: Container(
                  height: 130,
                  width: 130,
                  padding: const EdgeInsets.all(18.0),
                  child: SvgPicture.asset(
                    'assets/images/metamask-icon2.svg',
                  ),
                ),
                secondChild: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Material(
                    elevation: DodaoTheme.of(context).elevation,
                    borderRadius: DodaoTheme.of(context).borderRadius,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      width: innerPaddingWidth,
                      decoration: BoxDecoration(
                        borderRadius: DodaoTheme.of(context).borderRadius,
                      ),
                      child: TransportSelection(
                        screenHeightSizeNoKeyboard: widget.screenHeightSizeNoKeyboard - 100,
                      ),
                    ),
                  ),
                ),
                crossFadeState: !tasksServices.walletConnectedMM ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              ),
            if (tasksServices.walletConnectedMM) const SizedBox(height: 20),
            if (tasksServices.walletConnectedMM)
              Center(
                child: Material(
                  elevation: DodaoTheme.of(context).elevation,
                  borderRadius: DodaoTheme.of(context).borderRadius,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    // height: MediaQuery.of(context).size.width * .08,
                    // width: MediaQuery.of(context).size.width * .57
                    width: innerPaddingWidth,
                    decoration: BoxDecoration(
                      borderRadius: DodaoTheme.of(context).borderRadius,
                    ),
                    child: Row(
                      children: const <Widget>[
                        Expanded(
                          child: Text(
                            'You are now connected to Metamask, to completely disconnect please use Metamask menu --> connected sites.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (interface.whichWalletButtonPressed == 'metamask')
              const WalletConnectButton(
                buttonFunction: 'metamask',
              ),
            const SizedBox(height: 30),
          ]),
          Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  // maxWidth: maxStaticInternalWidth,
                  // maxHeight: widget.screenHeightSizeNoKeyboard,
                  minHeight: widget.screenHeightSizeNoKeyboard - 300,
                  // maxHeight: widget.screenHeightSize
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
                          padding: const EdgeInsets.all(10.0),
                          height: widget.screenHeightSizeNoKeyboard - 40,
                          // width: MediaQuery.of(context).size.width * .57
                          width: innerPaddingWidth,
                          decoration: BoxDecoration(
                            borderRadius: DodaoTheme.of(context).borderRadius,
                            border: DodaoTheme.of(context).borderGradient,
                          ),
                          child: DefaultTabController(
                            length: 2,
                            initialIndex: defaultTab,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: TabBar(
                                    labelColor: DodaoTheme.of(context).secondaryText,
                                    indicatorColor: DodaoTheme.of(context).tabIndicator,
                                    // controller: interface.walletTabController,
                                    // indicatorColor: Colors.black26,
                                    // indicatorWeight: 10,
                                    // indicatorSize: TabBarIndicatorSize.label,
                                    // labelPadding: const EdgeInsets.only(left: 16, right: 16),
                                    // indicator: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(10), // Creates border
                                    //     color: Colors.black26),
                                    // isScrollable: true,
                                    unselectedLabelColor: Colors.grey,
                                    // splashBorderRadius: BorderRadius.circular(10),
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
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 22),
                                            // AnimatedCrossFade(
                                            //   duration: const Duration(milliseconds: 300),
                                            //   firstChild: RichText(
                                            //       text: TextSpan(
                                            //           style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.0),
                                            //           children: const <TextSpan>[
                                            //         TextSpan(
                                            //             text: 'Connect to Mobile Wallet',
                                            //             style:
                                            //                 TextStyle(height: 3, fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black54)),
                                            //       ])),
                                            //   secondChild: TransportSelection(
                                            //     screenHeightSizeNoKeyboard: widget.screenHeightSizeNoKeyboard,
                                            //   ),
                                            //   crossFadeState: _displayUri.isNotEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                            // ),

                                            // if (_displayUri.isNotEmpty)

                                            // if (_displayUri.isEmpty)
                                            // TransportSelection(screenHeightSizeNoKeyboard: widget.screenHeightSizeNoKeyboard,),
                                            // const Spacer(),
                                            // Padding(
                                            //   padding: const EdgeInsets.only(bottom: 14.0),
                                            //   child: Text(
                                            //     tasksServices
                                            //         .walletConnectedWC
                                            //         ? 'Wallet connected'
                                            //         : 'Wallet disconnected',
                                            //     style: const TextStyle(
                                            //         fontWeight:
                                            //         FontWeight.bold,
                                            //         fontSize: 17,
                                            //         color: Colors.black54),
                                            //
                                            //     textAlign: TextAlign.center,
                                            //   ),
                                            // ),
                                            const Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 14.0),
                                              child: Text(
                                                tasksServices.walletConnectedWC ? 'Wallet connected' : 'Wallet disconnected',
                                                style: Theme.of(context).textTheme.bodySmall,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            const WalletConnectButton(
                                              buttonFunction: 'wallet_connect',
                                              buttonName: 'Connect',
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
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 22),
                                            RichText(
                                                text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: const <TextSpan>[
                                              TextSpan(text: 'Connect to Desktop Wallet'),
                                            ])),
                                            const Spacer(),
                                            const WalletConnectButton(
                                              buttonFunction: 'wallet_connect',
                                              buttonName: 'Connect',
                                            ),
                                            const SizedBox(height: 22),
                                          ],
                                        ),

                                      // *********** Wallet Connect > QR Code page ************ //

                                      Column(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 22),
                                          AnimatedCrossFade(
                                            duration: const Duration(milliseconds: 300),
                                            firstChild: SizedBox(
                                              height: widget.screenHeightSizeNoKeyboard - 210,
                                              child: Column(
                                                // crossAxisAlignment:
                                                // CrossAxisAlignment.center,
                                                children: [
                                                  if (_displayUri.isNotEmpty)
                                                    RichText(
                                                        text: TextSpan(style: Theme.of(context).textTheme.bodyMedium, children: const <TextSpan>[
                                                      TextSpan(text: 'Scan QR code'),
                                                    ])),
                                                  const Spacer(),
                                                  if (_displayUri.isNotEmpty)
                                                    QrImageView(
                                                      data: _displayUri,
                                                      size: 230,
                                                      gapless: false,
                                                      backgroundColor: Colors.white,
                                                    ),
                                                  const Spacer(),
                                                  if (!tasksServices.validChainIDWC && tasksServices.walletConnectedWC)
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                        left: 16,
                                                        right: 16,
                                                        bottom: 16,
                                                      ),
                                                      child: Text(
                                                        'Wrong network, please connect to Moonbase Alpha',
                                                        style: Theme.of(context).textTheme.bodyMedium,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    )
                                                ],
                                              ),
                                            ),
                                            secondChild: TransportSelection(
                                              screenHeightSizeNoKeyboard: widget.screenHeightSizeNoKeyboard,
                                            ),
                                            // crossFadeState: _displayUri.isNotEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                            crossFadeState: true ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                          ),
                                          // if (_displayUri.isEmpty)
                                          //
                                          //
                                          //
                                          // // if (_displayUri.isNotEmpty)
                                          // // const Spacer(),
                                          // if (_displayUri.isNotEmpty)
                                          //

                                          // SizedBox(
                                          //   // height: 260,
                                          //   width: 250,
                                          //   child: Column(
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment.center,
                                          //     children: [
                                          //       (_displayUri.isEmpty)
                                          //           ? const Padding(
                                          //               padding:
                                          //                   EdgeInsets.only(
                                          //                 left: 10,
                                          //                 right: 10,
                                          //                 bottom: 10,
                                          //               ),
                                          //             )
                                          //           : QrImage(
                                          //               data: _displayUri,
                                          //               size: 230,
                                          //               gapless: false,
                                          //             ),
                                          //
                                          //
                                          //     ],
                                          //   ),
                                          // ),
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 14.0),
                                            child: Text(
                                              tasksServices.walletConnectedWC ? 'Wallet connected' : 'Wallet disconnected',
                                              style: Theme.of(context).textTheme.bodyMedium,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const WalletConnectButton(
                                            buttonFunction: 'wallet_connect',
                                            buttonName: 'Refresh QR',
                                          ),
                                          // const Spacer(),
                                          const SizedBox(height: 22),
                                        ],
                                      ),
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
          ),
        ],
      );
    });
  }
}

class ChooseWalletButton extends StatefulWidget {
  final double buttonWidth;
  final bool active;
  final String buttonFunction;
  final double borderRadius;
  const ChooseWalletButton({Key? key, required this.active, required this.buttonFunction, required this.borderRadius, required this.buttonWidth})
      : super(key: key);

  @override
  _ChooseWalletButtonState createState() => _ChooseWalletButtonState();
}

class _ChooseWalletButtonState extends State<ChooseWalletButton> {
  // TransactionState _state2 = TransactionState.disconnected;

  late String assetName;
  late Color buttonColor = Colors.grey.shade600;
  late int page = 0;
  late Widget customIcon;
  late Color textColor;

  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    var tasksServices = context.watch<TasksServices>();
    late String name;
    if (widget.buttonFunction == 'metamask') {
      name = 'Metamask';
      assetName = 'assets/images/metamask-icon2.svg';
      buttonColor = Colors.teal.shade700;
      page = 1;
    } else if (widget.buttonFunction == 'wallet_connect') {
      name = 'Wallet Connect';
      assetName = 'assets/images/wc_logo.svg';
      buttonColor = Colors.purple.shade700;
      page = 2;
    }
    if (widget.active) {
      customIcon = SvgPicture.asset(
        assetName,
      );
    } else {
      buttonColor = Colors.grey.shade700;
      customIcon = SvgPicture.asset(
        assetName,
        color: Colors.black54,
      );
    }

    return Material(
      elevation: DodaoTheme.of(context).elevation,
      borderRadius: DodaoTheme.of(context).borderRadius,
      child: InkWell(
        onTap: () {
          if (widget.active) {
            interface.whichWalletButtonPressed = widget.buttonFunction;
            // tasksServices.myNotifyListeners();
            // controller.jumpToPage(page);
            interface.controller.animateToPage(page, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
            if (widget.buttonFunction == 'metamask') {
              tasksServices.initComplete ? tasksServices.connectWalletMM() : null;
            } else if (widget.buttonFunction == 'wallet_connect') {
              tasksServices.initComplete ? tasksServices.connectWalletWCv2(false) : null;
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(0.0),
          height: 50.0, //MediaQuery.of(context).size.width * .08,
          width: widget.buttonWidth,
          decoration: BoxDecoration(
            borderRadius: DodaoTheme.of(context).borderRadius,
            color: DodaoTheme.of(context).walletBackgroundColor,
          ),
          child: Row(
            children: <Widget>[
              LayoutBuilder(builder: (context, constraints) {
                // print(constraints);
                return Container(
                    height: constraints.maxHeight,
                    width: constraints.maxHeight,
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.only(
                        topLeft: DodaoTheme.of(context).borderRadius.topLeft,
                        bottomLeft: DodaoTheme.of(context).borderRadius.bottomLeft,
                      ),
                    ),
                    child: Container(padding: const EdgeInsets.all(9.0), child: customIcon));
              }),
              Expanded(
                child: Text(name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.apply(
                          color: DodaoTheme.of(context).secondaryText,
                        )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WalletConnectButton extends StatefulWidget {
  final String buttonFunction;
  final String buttonName;

  // final double borderRadius;
  const WalletConnectButton({
    Key? key,
    required this.buttonFunction,
    this.buttonName = '',
    // required this.borderRadius
  }) : super(key: key);

  @override
  _WalletConnectButtonState createState() => _WalletConnectButtonState();
}

class _WalletConnectButtonState extends State<WalletConnectButton> {
  // late String assetName;
  // late Color buttonColor = Colors.black26;
  // late int page = 0;

  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    var tasksServices = context.watch<TasksServices>();
    late String buttonText = 'name not set';

    if (tasksServices.walletConnectedWC && tasksServices.validChainIDWC && widget.buttonFunction == 'wallet_connect') {
      buttonText = 'Disconnect';
    } else if (tasksServices.walletConnectedWC && !tasksServices.validChainIDWC && widget.buttonFunction == 'wallet_connect') {
      buttonText = 'Switch network';
    } else if (!tasksServices.walletConnectedWC && widget.buttonFunction == 'wallet_connect' && (widget.buttonName == 'Refresh QR')) {
      buttonText = 'Refresh QR';
    } else if (!tasksServices.walletConnectedWC && widget.buttonFunction == 'wallet_connect' && (widget.buttonName == 'Connect')) {
      buttonText = 'Connect';
    } else if (tasksServices.walletConnectedMM && tasksServices.validChainIDMM && widget.buttonFunction == 'metamask') {
      buttonText = 'Disconnect';
    } else if (tasksServices.walletConnectedMM && !tasksServices.validChainIDMM && widget.buttonFunction == 'metamask') {
      buttonText = 'Switch network';
    } else if (!tasksServices.walletConnectedMM && widget.buttonFunction == 'metamask') {
      buttonText = 'Connect';
    }

    return Material(
      elevation: DodaoTheme.of(context).elevation,
      borderRadius: DodaoTheme.of(context).borderRadius,
      color: Colors.blueAccent,
      child: InkWell(
        onTap: () async {
          // controller.jumpToPage(page);
          // interface.controller.animateToPage(page,
          //     duration: const Duration(milliseconds: 300),
          //     curve: Curves.easeIn);
          if (widget.buttonFunction == 'metamask') {
            if (!tasksServices.walletConnectedMM) {
              tasksServices.initComplete ? await tasksServices.connectWalletMM() : null;
            } else if (tasksServices.walletConnectedMM && !tasksServices.validChainIDMM) {
              tasksServices.initComplete ? await tasksServices.switchNetworkMM() : null;
            } else if (tasksServices.walletConnectedMM && tasksServices.validChainIDMM) {
              tasksServices.initComplete ? await tasksServices.disconnectMM() : null;
              buttonText = 'Connect';
            }
          } else if (widget.buttonFunction == 'wallet_connect') {
            if (!tasksServices.walletConnectedWC) {
              tasksServices.initComplete ? await tasksServices.connectWalletWCv2(false) : null;
            } else if (tasksServices.walletConnectedWC && !tasksServices.validChainIDWC) {
              tasksServices.initComplete
                  ? await tasksServices.switchNetworkWC()
                  // ? null
                  : null;
            } else if (tasksServices.walletConnectedWC && tasksServices.validChainIDWC) {
              tasksServices.initComplete ? {await tasksServices.disconnectWCv2()} : null;
              // buttonName = 'Refresh QR';
            }
            // if(buttonText == 'Disconnect') {
            //   tasksServices.myNotifyListeners();
            // }
            // if (tasksServices.walletConnected) {
            //   await tasksServices.wallectConnectTransaction?.disconnect();
            // } else {
            //   tasksServices.initComplete
            //       ? tasksServices.connectWalletWC()
            //       : null;
            // }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(0.0),
          height: 38.0,
          width: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
