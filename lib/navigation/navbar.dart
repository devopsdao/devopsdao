import 'package:flutter/material.dart';
import '../flutter_flow/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../index.dart';

import 'beamer_delegate.dart';

class NavBarPage extends StatefulWidget {
  const NavBarPage({Key? key, this.initialPage}) : super(key: key);

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
      // '/tasks/1': const TasksPageWidget(),
      '/customer': const HomePageWidget(),
      '/performer': const HomePageWidget(),
      '/auditor': const HomePageWidget(),
      '/accounts': const HomePageWidget(),
      // 'walletPage': WalletPageTop(title: 'WalletConnect'),
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
      backgroundColor: Colors.black,
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
          label: 'Tasks',
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
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.peopleGroup,
            size: 24,
          ),
          label: 'Accounts',
          tooltip: '',
        ),
      ],
    );
  }
}
