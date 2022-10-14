import 'package:provider/provider.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../auditor_page/auditor_page.dart';
import '../blockchain/interface.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/internationalization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../index.dart';

import 'package:devopsdao/blockchain/task_services.dart';

import '../job_exchange/job_exchange_widget.dart';

import 'authenticator.dart';
import 'beamer_delegate.dart';
import 'package:beamer/beamer.dart';

class NavBarPage extends StatefulWidget {
  NavBarPage({Key? key, this.initialPage}) : super(key: key);

  final String? initialPage;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPage = '/home';

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage ?? _currentPage;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      '/home': const HomePageWidget(),
      '/tasks': const HomePageWidget(),
      // '/tasks/1': const JobExchangeWidget(),
      '/customer': const HomePageWidget(),
      '/performer': const HomePageWidget(),
      '/auditor': const HomePageWidget(),
      // 'walletPage': MyWalletPage(title: 'WalletConnect'),
      // 'orangePage': MyOrangePage(title: 'WalletConnect'),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPage);

    // final currentPage = beamerDelegate.currentBeamLocation;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) => {
        setState(() => _currentPage = tabs.keys.toList()[i]),
        beamerDelegate.beamToNamed(tabs.keys.toList()[i])
      },
      // onTap: (i) => setState(() => _currentPage = tabs.keys.toList()[i]),
      backgroundColor: FlutterFlowTheme.of(context).black600,
      selectedItemColor: Colors.white,
      unselectedItemColor: FlutterFlowTheme.of(context).grayIcon,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_sharp,
            size: 24,
          ),
          label: 'Home',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.compare_arrows,
            size: 24,
          ),
          label: 'Exchange',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.wpforms,
            size: 24,
          ),
          label: 'Customer',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.pen,
            size: 24,
          ),
          label: 'Performer',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.penRuler,
            size: 24,
          ),
          label: 'Audit',
          tooltip: '',
        ),
        // BottomNavigationBarItem(
        //   icon: FaIcon(
        //     FontAwesomeIcons.wallet,
        //     size: 24,
        //   ),
        //   label: 'Wallet',
        //   tooltip: '',
        // ),
      ],
    );
  }
}
