import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:flutter/material.dart';

class InitializeWalletConnect extends StatefulWidget {
  const InitializeWalletConnect({super.key});

  @override
  State<InitializeWalletConnect> createState() => _InitializeWalletConnectState();
}

class _InitializeWalletConnectState extends State<InitializeWalletConnect> {
  bool _initializing = true;

  Web3App? _web3App;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    // try {
    _web3App = await Web3App.createInstance(
      projectId: '98a940d6677c21307eaa65e2290a7882',
      metadata: const PairingMetadata(
        name: 'dodao.dev',
        description: 'Decentralzied marketplace for coders and art-creators',
        url: 'https://walletconnect.com/',
        icons: ['https://walletconnect.com/walletconnect-logo.png'],
      ),
    );

    // Loop through all the chain data
    for (final ChainMetadata chain in ChainData.allChains) {
      // Loop through the events for that chain
      for (final event in getChainEvents(chain.type)) {
        _web3App!.registerEventHandler(chainId: chain.chainId, event: event);
      }
    }

    // Register event handlers
    _web3App!.onSessionPing.subscribe(_onSessionPing);
    _web3App!.onSessionEvent.subscribe(_onSessionEvent);

    setState(() {
      _pageDatas = [
        PageData(
          page: ConnectPage(web3App: _web3App!),
          title: StringConstants.connectPageTitle,
          icon: Icons.home,
        ),
        PageData(
          page: PairingsPage(web3App: _web3App!),
          title: StringConstants.pairingsPageTitle,
          icon: Icons.connect_without_contact_sharp,
        ),
        PageData(
          page: SessionsPage(web3App: _web3App!),
          title: StringConstants.sessionsPageTitle,
          icon: Icons.confirmation_number_outlined,
        ),
        PageData(
          page: AuthPage(web3App: _web3App!),
          title: StringConstants.authPageTitle,
          icon: Icons.lock,
        ),
      ];

      _initializing = false;
    });
    // } on WalletConnectError catch (e) {
    //   print(e.message);
    // }
  }

  @override
  void dispose() {
    _web3App!.onSessionPing.unsubscribe(_onSessionPing);
    _web3App!.onSessionEvent.unsubscribe(_onSessionEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initializing) {
      return const Center(
        child: CircularProgressIndicator(
          color: StyleConstants.primaryColor,
        ),
      );
    }

    final List<Widget> navRail = [];
    if (MediaQuery.of(context).size.width >= Constants.smallScreen) {
      navRail.add(_buildNavigationRail());
    }
    navRail.add(
      Expanded(
        child: Stack(
          children: [
            _pageDatas[_selectedIndex].page,
            Positioned(
              bottom: StyleConstants.magic20,
              right: StyleConstants.magic20,
              child: Row(
                children: [
                  // Disconnect buttons for testing
                  _buildIconButton(
                    Icons.discord,
                        () {
                      _web3App!.core.relayClient.disconnect();
                    },
                  ),
                  const SizedBox(
                    width: StyleConstants.magic20,
                  ),
                  _buildIconButton(
                    Icons.connect_without_contact,
                        () {
                      _web3App!.core.relayClient.connect();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageDatas[_selectedIndex].title),
      ),
      bottomNavigationBar:
      MediaQuery.of(context).size.width < Constants.smallScreen
          ? _buildBottomNavBar()
          : null,
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: navRail,
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.indigoAccent,
      // called when one tab is selected
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      // bottom tab items
      items: _pageDatas
          .map(
            (e) => BottomNavigationBarItem(
          icon: Icon(e.icon),
          label: e.title,
        ),
      )
          .toList(),
    );
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      labelType: NavigationRailLabelType.selected,
      destinations: _pageDatas
          .map(
            (e) => NavigationRailDestination(
          icon: Icon(e.icon),
          label: Text(e.title),
        ),
      )
          .toList(),
    );
  }

  void _onSessionPing(SessionPing? args) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EventWidget(
          title: StringConstants.receivedPing,
          content: 'Topic: ${args!.topic}',
        );
      },
    );
  }

  void _onSessionEvent(SessionEvent? args) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EventWidget(
          title: StringConstants.receivedEvent,
          content:
          'Topic: ${args!.topic}\nEvent Name: ${args.name}\nEvent Data: ${args.data}',
        );
      },
    );
  }

  Widget _buildIconButton(IconData icon, void Function()? onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: StyleConstants.primaryColor,
        borderRadius: BorderRadius.circular(
          StyleConstants.linear48,
        ),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: StyleConstants.titleTextColor,
        ),
        iconSize: StyleConstants.linear24,
        onPressed: onPressed,
      ),
    );
  }
}
