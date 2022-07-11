import 'package:flutter/foundation.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

var sessionStatus;
var address;
var chainId;
Future<void> connectWallet() async {
  final connector = WalletConnect(
    bridge: 'https://bridge.walletconnect.org',
    clientMeta: const PeerMeta(
      name: 'WalletConnect',
      description: 'WalletConnect Developer App',
      url: 'https://walletconnect.org',
      icons: [
        'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
      ],
    ),
  );

  // Subscribe to events
  connector.on('connect', (session) {
    debugPrint("connect: " + session.toString());

    address = sessionStatus?.accounts[0];
    chainId = sessionStatus?.chainId;

    // debugPrint("Address: " + address!);
    debugPrint("Address: " + address);
    debugPrint("Chain Id: " + chainId.toString());
  });

  connector.on('session_request', (payload) {
    debugPrint("session request: " + payload.toString());
  });

  connector.on('disconnect', (session) {
    debugPrint("disconnect: " + session.toString());
  });

  // Create a new session
  if (!connector.connected) {
    sessionStatus = await connector.createSession(
      chainId: 137, //pass the chain id of a network. 137 is Polygon
      onDisplayUri: (uri) {
        //AppMehtods.openUrl(uri); //call the launchUrl(uri) method
      },
    );
  }
}
