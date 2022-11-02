import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../blockchain/interface.dart';
import 'algorand_transaction_tester.dart';
import 'ethereum_transaction_tester.dart';
import 'transaction_tester.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:provider/provider.dart';
import 'package:devopsdao/blockchain/task_services.dart';

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

class MyWalletPage extends StatefulWidget {
  const MyWalletPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyWalletPageState createState() => _MyWalletPageState();
}

class _MyWalletPageState extends State<MyWalletPage> {
  String txId = '';
  String _displayUri = '';
  var session;
  String backgroundPicture = "assets/images/logo_half.png";

  static const _networks = ['Ethereum (Ropsten)', 'Algorand (Testnet)'];
  NetworkType? _network = NetworkType.ethereum;
  // TransactionState _state = TransactionState.disconnected;
  // TransactionState _state2 = TransactionState.disconnected;
  // TransactionTester? _transactionTester = EthereumTransactionTester();
  late TransactionTester? _transactionTester;

  bool disableBackButton = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tasksServices = context.watch<TasksServices>();
    var interface = context.watch<InterfaceServices>();

    if (tasksServices.walletConnectedWC || tasksServices.walletConnectedMM) {
      if (tasksServices.walletConnectedMM) {
        // interface.pageWalletViewNumber = 1;
        interface.controller = PageController(initialPage: 1);
      } else if (tasksServices.walletConnectedWC) {
        // interface.pageWalletViewNumber = 2;
        interface.controller = PageController(initialPage: 2);
      }
    } else {
      // interface.pageWalletViewNumber = 0;
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
    print(disableBackButton);

    _displayUri = tasksServices.walletConnectUri;
    // if (tasksServices.walletConnectUri != '') {
    //   _displayUri = tasksServices.walletConnectUri;
    // }
    if (tasksServices.walletConnectedWC) {
      tasksServices.walletConnectUri = '';
    }

    // int page = interface.pageWalletViewNumber;

    return LayoutBuilder(builder: (context, constraints) {
      return StatefulBuilder(builder: (context, setState) {
        return Dialog(
          insetPadding: const EdgeInsets.all(30),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  width: 400,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: !disableBackButton
                            ? InkWell(
                                onTap: () {
                                  interface.controller.animateToPage(0,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.ease);
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.all(0.0),
                                  height: 30,
                                  width: 30,
                                  child: Row(
                                    children: const <Widget>[
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
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Connect Wallet',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
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
                  height: constraints.maxHeight * .7 > 580
                      ? 580
                      : constraints.maxHeight * .7,
                  // width: constraints.maxWidth * .8,
                  // height: 550,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    image: DecorationImage(
                      image: AssetImage(backgroundPicture),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: WalletPages(
                    borderRadius: borderRadius,
                  ),
                ),
                // Container(height: 10),
              ]),
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
        _transactionTester = AlgorandTransactionTester();
        break;
      case NetworkType.ethereum:
        _transactionTester = EthereumTransactionTester();
        break;
    }

    setState(
      () => _network = newNetwork,
    );
  }
}

class WalletPages extends StatefulWidget {
  // final String buttonName;
  final double borderRadius;

  const WalletPages(
      {Key? key,
      // required this.buttonName,
      required this.borderRadius})
      : super(key: key);

  @override
  _WalletPagesState createState() => _WalletPagesState();
}

class _WalletPagesState extends State<WalletPages> {
  String _displayUri = '';
  int defaultTab = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    var tasksServices = context.watch<TasksServices>();

    // print(interface.pageWalletViewNumber);
    // interface.pageWalletViewNumber = 0;

    _displayUri = tasksServices.walletConnectUri;
    // if (tasksServices.walletConnectUri != '') {
    //   _displayUri = tasksServices.walletConnectUri;
    // }
    if (tasksServices.walletConnectedWC) {
      tasksServices.walletConnectUri = '';
    }

    if (tasksServices.platform == 'linux') {
      defaultTab = 1;
    } else if (tasksServices.platform == 'web' &&
        tasksServices.browserPlatform != 'android') {
      defaultTab = 1;
    } else if (tasksServices.platform == 'mobile' ||
        tasksServices.browserPlatform == 'android') {
      defaultTab = 0;
    }

    return LayoutBuilder(builder: (ctx, dialogConstraints) {
      double innerWidth = dialogConstraints.maxWidth - 50;
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
              const SizedBox(height: 50),
              Center(
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    // height: MediaQuery.of(context).size.width * .08,
                    // width: MediaQuery.of(context).size.width * .57
                    width: innerWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                    child: Row(
                      children: const <Widget>[
                        Expanded(
                          child: Text(
                            'By connecting a wallet, you agree to Terms of Service and Privacy Policy.',
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
              const Spacer(),
              ChooseWalletButton(
                active:
                    tasksServices.platform == 'web' && tasksServices.mmAvailable
                        ? true
                        : false,
                buttonName: 'metamask',
                borderRadius: widget.borderRadius,
                buttonWidth: innerWidth,
              ),
              const SizedBox(height: 12),
              ChooseWalletButton(
                active: true,
                buttonName: 'wallet_connect',
                borderRadius: widget.borderRadius,
                buttonWidth: innerWidth,
              ),
              const Spacer(),
            ],
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (interface.whichWalletButtonPressed == 'metamask')
              Column(children: [
                Container(
                  height: 130,
                  width: 130,
                  padding: const EdgeInsets.all(18.0),
                  child: SvgPicture.asset(
                    'assets/images/metamask-icon2.svg',
                  ),
                ),
                const SizedBox(height: 60),
                if (tasksServices.walletConnectedMM)
                  Center(
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        // height: MediaQuery.of(context).size.width * .08,
                        // width: MediaQuery.of(context).size.width * .57
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(widget.borderRadius),
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
                const WalletConnectButton(
                  buttonName: 'metamask',
                ),
              ]),
          ]),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 480,
                    // width: MediaQuery.of(context).size.width * .57
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: DefaultTabController(
                            length: 2,
                            initialIndex: defaultTab,
                            child: Column(
                              children: [
                                Container(
                                  height: 30,
                                  child: TabBar(
                                    labelColor: Colors.black,
                                    // controller: interface.walletTabController,
                                    // indicatorColor: Colors.black26,
                                    // indicatorWeight: 10,
                                    // indicatorSize: TabBarIndicatorSize.label,
                                    // labelPadding: const EdgeInsets.only(left: 16, right: 16),
                                    indicator: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            4), // Creates border
                                        color: Colors.black26),
                                    // isScrollable: true,
                                    tabs: [
                                      Container(
                                        color: Colors.transparent,
                                        width: 120,
                                        child: Tab(
                                            child: Text(tasksServices
                                                            .platform ==
                                                        'mobile' ||
                                                    tasksServices
                                                            .browserPlatform ==
                                                        'android'
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
                                      if (tasksServices.platform == 'mobile' ||
                                          tasksServices.browserPlatform ==
                                              'android')
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            RichText(
                                                text: TextSpan(
                                                    style: DefaultTextStyle.of(
                                                            context)
                                                        .style
                                                        .apply(
                                                            fontSizeFactor:
                                                                1.0),
                                                    children: const <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                          'Connect to Mobile Wallet',
                                                      style: TextStyle(
                                                          height: 3,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17,
                                                          color:
                                                              Colors.black54)),
                                                ])),
                                            const WalletConnectButton(
                                              buttonName: 'wallet_connect',
                                            ),
                                            const SizedBox(height: 12),
                                          ],
                                        ),
                                      if (tasksServices.platform == 'linux' ||
                                          tasksServices.platform == 'web' &&
                                              tasksServices.browserPlatform !=
                                                  'android')
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            RichText(
                                                text: TextSpan(
                                                    style: DefaultTextStyle.of(
                                                            context)
                                                        .style
                                                        .apply(
                                                            fontSizeFactor:
                                                                1.0),
                                                    children: const <TextSpan>[
                                                  TextSpan(
                                                      text:
                                                          'Connect to Desktop Wallet',
                                                      style: TextStyle(
                                                          height: 3,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17,
                                                          color:
                                                              Colors.black54)),
                                                ])),
                                            const WalletConnectButton(
                                              buttonName: 'wallet_connect',
                                            ),
                                            const SizedBox(height: 12),
                                          ],
                                        ),
                                      Column(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          RichText(
                                              text: TextSpan(
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style
                                                      .apply(
                                                          fontSizeFactor: 1.0),
                                                  children: const <TextSpan>[
                                                TextSpan(
                                                    text: 'Scan QR code',
                                                    style: TextStyle(
                                                        height: 3,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17,
                                                        color: Colors.black54)),
                                              ])),
                                          SizedBox(
                                            height: 320,
                                            width: 300,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                (_displayUri.isEmpty)
                                                    ? const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          bottom: 10,
                                                        ),
                                                      )
                                                    : QrImage(
                                                        data: _displayUri,
                                                        size: 280,
                                                        gapless: false,
                                                      ),
                                                Text(
                                                  tasksServices
                                                          .walletConnectedWC
                                                      ? 'Wallet connected'
                                                      : 'Wallet disconnected',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline6,
                                                  textAlign: TextAlign.center,
                                                ),
                                                if (!tasksServices
                                                        .validChainIDWC &&
                                                    tasksServices
                                                        .walletConnectedWC)
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 16,
                                                      right: 16,
                                                      bottom: 16,
                                                    ),
                                                    child: Text(
                                                      'Wrong network, please connect to Moonbase Alpha',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.redAccent,
                                                          fontSize: 20),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          const WalletConnectButton(
                                            buttonName: 'wallet_connect',
                                          ),
                                          const Spacer(),
                                          const SizedBox(height: 12),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class ChooseWalletButton extends StatefulWidget {
  final double buttonWidth;
  final bool active;
  final String buttonName;
  final double borderRadius;
  const ChooseWalletButton(
      {Key? key,
      required this.active,
      required this.buttonName,
      required this.borderRadius,
      required this.buttonWidth})
      : super(key: key);

  @override
  _ChooseWalletButtonState createState() => _ChooseWalletButtonState();
}

class _ChooseWalletButtonState extends State<ChooseWalletButton> {
  // TransactionState _state2 = TransactionState.disconnected;

  late String assetName;
  late Color buttonColor = Colors.black26;
  late int page = 0;
  late Widget customIcon;
  late Color textColor;

  @override
  Widget build(BuildContext context) {
    var interface = context.watch<InterfaceServices>();
    var tasksServices = context.watch<TasksServices>();
    late String name;
    if (widget.buttonName == 'metamask') {
      name = 'Metamask';
      assetName = 'assets/images/metamask-icon2.svg';
      buttonColor = Colors.teal.shade900;
      page = 1;
    } else if (widget.buttonName == 'wallet_connect') {
      name = 'Wallet Connect';
      assetName = 'assets/images/wc_logo.svg';
      buttonColor = Colors.purple.shade900;
      page = 2;
    }
    if (widget.active) {
      textColor = Colors.black87;
      customIcon = SvgPicture.asset(
        assetName,
      );
    } else {
      textColor = Colors.black26;
      buttonColor = Colors.black54;
      customIcon = SvgPicture.asset(
        assetName,
        color: Colors.black54,
      );
    }

    return Material(
      elevation: 9,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: InkWell(
        onTap: () {
          if (widget.active) {
            interface.whichWalletButtonPressed = widget.buttonName;
            // tasksServices.myNotifyListeners();
            // controller.jumpToPage(page);
            interface.controller.animateToPage(page,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn);
            if (widget.buttonName == 'metamask') {
              tasksServices.initComplete
                  ? tasksServices.connectWalletMM()
                  : null;
            } else if (widget.buttonName == 'wallet_connect') {
              tasksServices.initComplete
                  ? tasksServices.connectWalletWC(false)
                  : null;
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(0.0),
          height: 50.0, //MediaQuery.of(context).size.width * .08,
          width: widget.buttonWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
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
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                      ),
                    ),
                    child: Container(
                        padding: const EdgeInsets.all(9.0), child: customIcon));
              }),
              Expanded(
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
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

class WalletConnectButton extends StatefulWidget {
  final String buttonName;
  // final double borderRadius;
  const WalletConnectButton({
    Key? key,
    required this.buttonName,
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
    late String buttonText;

    if (tasksServices.walletConnectedWC &&
        tasksServices.validChainIDWC &&
        widget.buttonName == 'wallet_connect') {
      buttonText = 'Disconnect';
    } else if (tasksServices.walletConnectedWC &&
        !tasksServices.validChainIDWC &&
        widget.buttonName == 'wallet_connect') {
      buttonText = 'Switch network';
    } else if (!tasksServices.walletConnectedWC &&
        widget.buttonName == 'wallet_connect' &&
        (interface.pageWalletViewNumber == 2)) {
      buttonText = 'Refresh QR';
    } else if (!tasksServices.walletConnectedWC &&
        widget.buttonName == 'wallet_connect' &&
        (interface.pageWalletViewNumber == 1)) {
      buttonText = 'Connect';
    } else if (tasksServices.walletConnectedMM &&
        tasksServices.validChainIDMM &&
        widget.buttonName == 'metamask') {
      buttonText = 'Disconnect';
    } else if (tasksServices.walletConnectedMM &&
        !tasksServices.validChainIDMM &&
        widget.buttonName == 'metamask') {
      buttonText = 'Switch network';
    } else if (!tasksServices.walletConnectedMM &&
        widget.buttonName == 'metamask') {
      buttonText = 'Connect';
    }

    return Material(
      elevation: 9,
      borderRadius: BorderRadius.circular(6),
      color: Colors.blueAccent,
      child: InkWell(
        onTap: () async {
          // controller.jumpToPage(page);
          // interface.controller.animateToPage(page,
          //     duration: const Duration(milliseconds: 300),
          //     curve: Curves.easeIn);
          if (widget.buttonName == 'metamask') {
            if (!tasksServices.walletConnectedMM) {
              tasksServices.initComplete
                  ? await tasksServices.connectWalletMM()
                  : null;
            } else if (tasksServices.walletConnectedMM &&
                !tasksServices.validChainIDMM) {
              tasksServices.initComplete
                  ? await tasksServices.switchNetworkMM()
                  : null;
            } else if (tasksServices.walletConnectedMM &&
                tasksServices.validChainIDMM) {
              tasksServices.initComplete
                  ? await tasksServices.disconnectMM()
                  : null;
              buttonText = 'Connect';
            }
          } else if (widget.buttonName == 'wallet_connect') {
            if (!tasksServices.walletConnectedWC) {
              tasksServices.initComplete
                  ? await tasksServices.connectWalletWC(false)
                  : null;
            } else if (tasksServices.walletConnectedWC &&
                !tasksServices.validChainIDWC) {
              tasksServices.initComplete
                  ? await tasksServices.switchNetworkWC()
                  // ? null
                  : null;
            } else if (tasksServices.walletConnectedWC &&
                tasksServices.validChainIDWC) {
              tasksServices.initComplete
                  ? {await tasksServices.disconnectWC()}
                  : null;
              // buttonName = 'Refresh QR';
            }
            // if(buttonText == 'Disconnect') {
            //   tasksServices.myNotifyListeners();
            // }
            // if (tasksServices.walletConnected) {
            //   await tasksServices.transactionTester?.disconnect();
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
            borderRadius: BorderRadius.circular(6),
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
