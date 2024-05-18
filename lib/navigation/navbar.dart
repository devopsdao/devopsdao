import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../blockchain/task_services.dart';
import '../config/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../index.dart';

import '../wallet/model_view/wallet_model.dart';
import '../widgets/tags/search_services.dart';
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
  bool isTriggered = false;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage ?? _currentPage;
  }

  @override
  Widget build(BuildContext context) {
    var searchServices = context.read<SearchServices>();
    final listenRoleNfts = context.select((TasksServices vm) => vm.roleNfts);

    // // prevent error when switching between auditor/governor accounts:
    // if ((listenRoleNfts['auditor'] == 1 || listenRoleNfts['governor'] == 1) && !isTriggered) {
    //   _currentPage = '/home';
    //   isTriggered = true;
    // }
    final tabs = {
      '/home': const HomePageWidget(),
      '/tasks': const HomePageWidget(),
      // '/tasks/1': const TasksPageWidget(),
      '/customer': const HomePageWidget(),
      '/performer': const HomePageWidget(),
      '/stats': const HomePageWidget(),
      if (listenRoleNfts['auditor'] > 0) '/auditor': const HomePageWidget(),
      if (listenRoleNfts['governor'] > 0) '/accounts': const HomePageWidget(),
      // 'walletPage': WalletPageTop(title: 'WalletConnect'),
      // 'orangePage': MyOrangePage(title: 'WalletConnect'),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPage);

    // final currentPage = beamerDelegate.currentBeamLocation;

    return NavigationBar(
      height: 68,
      elevation: 8,
      selectedIndex: currentIndex,
      onDestinationSelected: (i) => {
        searchServices.searchBarStart.value = false,
        searchServices.searchKeywordController.clear(),
        setState(() => _currentPage = tabs.keys.toList()[i]),
        beamerDelegate.beamToNamed(tabs.keys.toList()[i])
      },
      // onTap: (i) => setState(() => _currentPage = tabs.keys.toList()[i]),
      backgroundColor: DodaoTheme.of(context).background,
      destinations: <Widget>[
        const NavigationDestination(
          icon: Icon(
            Icons.dashboard_rounded,
            size: 24,
          ),
          label: 'Dashboard',
        ),
        const NavigationDestination(
          icon: Icon(
            Icons.list_rounded,
            size: 24,
          ),
          label: 'Tasks',
        ),
        const NavigationDestination(
          icon: Icon(
            Icons.work_rounded,
            size: 24,
          ),
          label: 'Customer',
        ),
        const NavigationDestination(
          // selectedIcon: Icon(Icons.bookmark),
          icon: Icon(
            Icons.engineering_rounded,
            size: 24,
          ),
          label: 'Performer',
        ),
        const NavigationDestination(
          // selectedIcon: Icon(Icons.bookmark),
          icon: Icon(
            Icons.engineering_rounded,
            size: 24,
          ),
          label: 'Stats',
        ),
        if (listenRoleNfts['auditor'] > 0)
          const NavigationDestination(
            icon: FaIcon(
              FontAwesomeIcons.penRuler,
              size: 24,
            ),
            label: 'Auditor',
          ),
        if (listenRoleNfts['governor'] > 0)
          const NavigationDestination(
            icon: FaIcon(
              FontAwesomeIcons.peopleGroup,
              size: 24,
            ),
            label: 'Accounts',
          ),
      ],
      // destinations: <BottomNavigationBarItem>[
      //   const BottomNavigationBarItem(
      //     icon: Icon(
      //       Icons.dashboard_rounded,
      //       size: 24,
      //     ),
      //     label: 'Dashboard',
      //     tooltip: '',
      //   ),
      //   const BottomNavigationBarItem(
      //     icon: Icon(
      //       Icons.list_rounded,
      //       size: 24,
      //     ),
      //     label: 'Tasks',
      //     tooltip: '',
      //   ),
      //   const BottomNavigationBarItem(
      //     icon: Icon(
      //       Icons.work_rounded,
      //       size: 24,
      //     ),
      //     // icon: FaIcon(
      //     //   FontAwesomeIcons.wpforms,
      //     //   size: 24,
      //     // ),
      //     label: 'Customer',
      //     tooltip: '',
      //   ),
      //   const BottomNavigationBarItem(
      //     icon: Icon(
      //       Icons.engineering_rounded,
      //       size: 24,
      //     ),
      //     label: 'Performer',
      //     tooltip: '',
      //   ),
      //   if (tasksServices.roleNfts['auditor'] > 0)
      //     const BottomNavigationBarItem(
      //       icon: FaIcon(
      //         FontAwesomeIcons.penRuler,
      //         size: 24,
      //       ),
      //       label: 'Audit',
      //       tooltip: '',
      //     ),
      //   if(tasksServices.roleNfts['governor'] > 0)
      //     const BottomNavigationBarItem(
      //       icon: FaIcon(
      //         FontAwesomeIcons.peopleGroup,
      //         size: 24,
      //       ),
      //       label: 'Accounts',
      //       tooltip: '',
      //     ),
      // ],
    );

    // return BottomNavigationBar(
    //   currentIndex: currentIndex,
    //   onTap: (i) => {
    //     searchServices.searchBarStart.value = false,
    //     searchServices.searchKeywordController.clear(),
    //     setState(() => _currentPage = tabs.keys.toList()[i]),
    //     beamerDelegate.beamToNamed(tabs.keys.toList()[i])
    //   },
    //   // onTap: (i) => setState(() => _currentPage = tabs.keys.toList()[i]),
    //   backgroundColor:  DodaoTheme.of(context).background,
    //   // selectedItemColor: Colors.white,
    //   // unselectedItemColor: DodaoTheme.of(context).grayIcon,
    //   // showSelectedLabels: true,
    //   // showUnselectedLabels: true,
    //   // useLegacyColorScheme: false,
    //   type: BottomNavigationBarType.fixed,
    //   items: <BottomNavigationBarItem>[
    //     const BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.dashboard_rounded,
    //         size: 24,
    //       ),
    //       label: 'Dashboard',
    //       tooltip: '',
    //     ),
    //     const BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.list_rounded,
    //         size: 24,
    //       ),
    //       label: 'Tasks',
    //       tooltip: '',
    //     ),
    //     const BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.work_rounded,
    //         size: 24,
    //       ),
    //       // icon: FaIcon(
    //       //   FontAwesomeIcons.wpforms,
    //       //   size: 24,
    //       // ),
    //       label: 'Customer',
    //       tooltip: '',
    //     ),
    //     const BottomNavigationBarItem(
    //       icon: Icon(
    //         Icons.engineering_rounded,
    //         size: 24,
    //       ),
    //       // icon: FaIcon(
    //       //   Icons.engineering,
    //       //   // FontAwesomeIcons.pen,
    //       //   size: 24,
    //       // ),
    //       label: 'Performer',
    //       tooltip: '',
    //     ),
    //     if (tasksServices.roleNfts['auditor'] > 0)
    //     const BottomNavigationBarItem(
    //       icon: FaIcon(
    //         FontAwesomeIcons.penRuler,
    //         size: 24,
    //       ),
    //       label: 'Audit',
    //       tooltip: '',
    //     ),
    //     if(tasksServices.roleNfts['governor'] > 0)
    //     const BottomNavigationBarItem(
    //       icon: FaIcon(
    //         FontAwesomeIcons.peopleGroup,
    //         size: 24,
    //       ),
    //       label: 'Accounts',
    //       tooltip: '',
    //     ),
    //   ],
    // );
  }
}
