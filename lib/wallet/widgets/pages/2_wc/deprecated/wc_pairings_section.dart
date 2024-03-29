import 'package:flutter/material.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import '../../../../../config/utils/util.dart';
import '../../../shared/pairing_item.dart';

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

  Map<String, SessionData> _activeSessions = {};
  String _selectedSession = '';

  @override
  void initState() {
    _pairings = widget.web3App.pairings.getAll();
    widget.web3App.core.pairing.onPairingDelete.subscribe(_onPairingDelete);
    widget.web3App.core.pairing.onPairingExpire.subscribe(_onPairingDelete);

    _activeSessions = widget.web3App.getActiveSessions();
    widget.web3App.onSessionDelete.subscribe(_onSessionDelete);
    widget.web3App.onSessionExpire.subscribe(_onSessionExpire);
    super.initState();
  }

  @override
  void dispose() {
    widget.web3App.core.pairing.onPairingDelete.unsubscribe(_onPairingDelete);
    widget.web3App.core.pairing.onPairingExpire.unsubscribe(_onPairingDelete);

    widget.web3App.onSessionDelete.unsubscribe(_onSessionDelete);
    widget.web3App.onSessionExpire.unsubscribe(_onSessionExpire);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<SessionData> sessions = _activeSessions.values.toList();

    final List<ListTile> pairingItems = _pairings.map(
      (PairingInfo pairing) {
        String topic = pairing.topic.toString().substring(pairing.topic.toString().length - 14);
        DateTime expiryDateTime = DateTime.fromMillisecondsSinceEpoch(pairing.expiry * 1000);
        String expiry = DateFormat('dd.MM.yyyy, hh:mm a').format(expiryDateTime);
        return ListTile(
        title: Text(pairing.peerMetadata?.name ?? 'Unknown'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(pairing.peerMetadata?.url ?? 'Unknown'),
            Text('topic: ..$topic'),
            Text('expiry: ${expiry}'),
          ],
        ),
      );
    }).toList();

    final List<Widget> children = [
      // const SizedBox(
      //   height: 30,
      // ),
      Container(
        padding: const EdgeInsets.only(bottom: 10, top: 20),
        child: const Text(
          'Pairings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      // const SizedBox(
      //   height: 8,
      // ),
    ];
    children.addAll(pairingItems);

    return Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListView(
            shrinkWrap: true,
            children: children
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 10, top: 20),
            child: const Text(
              'Sessions:',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              String topic = sessions[index].topic.toString().substring(sessions[index].topic.toString().length - 14);
              String paringTopic = sessions[index].pairingTopic.toString().substring(sessions[index].pairingTopic.toString().length - 14);
              return ListTile(
                title: Text(sessions[index].peer.metadata.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sessions[index].peer.metadata.url),
                    Text(sessions[index].peer.metadata.description),
                    Text('topic: ..$topic'),
                    Text('paring topic: ..$paringTopic'),
                    // Text('${sessions[index].peer.metadata.hashCode.length - 5)}',),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
            itemCount: sessions.length,
          )
        ],
      ),
    );
  }

  void _onPairingDelete(PairingEvent? event) {
    setState(() {
      _pairings = widget.web3App.pairings.getAll();
    });
  }


  void _onSessionDelete(SessionDelete? event) {
    setState(() {
      if (event!.topic == _selectedSession) {
        _selectedSession = '';
      }
      _activeSessions = widget.web3App.getActiveSessions();
    });
  }

  void _onSessionExpire(SessionExpire? event) {
    setState(() {
      if (event!.topic == _selectedSession) {
        _selectedSession = '';
      }
      _activeSessions = widget.web3App.getActiveSessions();
    });
  }

  Widget _buildSessionView() {
    if (_selectedSession == '') {
      return const Center(
        child: Text(
          'No session selected',
          style: TextStyle(
            color: Colors.black,
            fontSize: 40,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    final SessionData session = _activeSessions[_selectedSession]!;

    return Container();

    // return SessionWidget(
    //   web3App: widget.web3App,
    //   session: session,
    // );
  }
}