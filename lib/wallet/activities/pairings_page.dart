import 'package:flutter/material.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'pairing_item.dart';

class PairingsPage extends StatefulWidget {
  const PairingsPage({
    super.key,
    required this.web3App,
  });

  final Web3App web3App;

  @override
  PairingsPageState createState() => PairingsPageState();
}

class PairingsPageState extends State<PairingsPage> {
  List<PairingInfo> _pairings = [];

  static const String deletePairing = 'Delete Pairing?';

  @override
  void initState() {
    _pairings = widget.web3App.pairings.getAll();
    // widget.web3App.onSessionDelete.subscribe(_onSessionDelete);
    widget.web3App.core.pairing.onPairingDelete.subscribe(_onPairingDelete);
    widget.web3App.core.pairing.onPairingExpire.subscribe(_onPairingDelete);
    super.initState();
  }

  @override
  void dispose() {
    // widget.web3App.onSessionDelete.unsubscribe(_onSessionDelete);
    widget.web3App.core.pairing.onPairingDelete.unsubscribe(_onPairingDelete);
    widget.web3App.core.pairing.onPairingExpire.unsubscribe(_onPairingDelete);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<PairingItem> pairingItems = _pairings
        .map(
          (PairingInfo pairing) => PairingItem(
        key: ValueKey(pairing.topic),
        pairing: pairing,
        onTap: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  deletePairing,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                content: Text(
                  pairing.topic,
                ),
                actions: [
                  TextButton(
                    child: const Text(
                     'Cancel',
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text(
                      'Delete',
                    ),
                    onPressed: () async {
                      try {
                        widget.web3App.core.pairing.disconnect(
                          topic: pairing.topic,
                        );
                        Navigator.of(context).pop();
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    )
        .toList();

    final List<Widget> children = [
      const SizedBox(
        height: 8,
      ),
      const Text(
        'Pairings',
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        height: 8,
      ),
    ];
    children.addAll(pairingItems);

    return Center(
      child: Container(
        // color: StyleConstants.primaryColor,
        padding: const EdgeInsets.all(
          8,
        ),
        constraints: const BoxConstraints(
          maxWidth: 340,
          maxHeight: 400
        ),
        child: ListView(
          children: children,
        ),
      ),
    );
  }

  void _onPairingDelete(PairingEvent? event) {
    setState(() {
      _pairings = widget.web3App.pairings.getAll();
    });
  }
}
