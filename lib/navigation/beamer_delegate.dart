// import 'dart:ffi';

import 'package:beamer/beamer.dart';
import 'package:dodao/pages/auditor_page.dart';
import 'package:dodao/pages/stats_page.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:webthree/webthree.dart';
import '../wallet/widgets/main/main.dart';
import 'appbar.dart';
// import '../../screens.dart';
import '../index.dart';

import 'package:flutter/material.dart';

import 'navbar.dart';
import 'navmenu.dart';

late final BeamerDelegate beamerDelegate;
final parser = BeamerParser();

void createBeamerDelegate() {
  beamerDelegate = BeamerDelegate(
    // initialPath: '/home',
    transitionDelegate: const NoAnimationTransitionDelegate(),
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/home': (context, state, data) => const Scaffold(
            body: HomePageWidget(),
            bottomNavigationBar: NavBarPage(
              initialPage: '/home',
            )),
        '/tasks': (context, state, data) => const Scaffold(
              body: TasksPageWidget(),
              bottomNavigationBar: NavBarPage(
                initialPage: '/tasks',
              ),
            ),
        '/performer': (context, state, data) => const Scaffold(
              body: PerformerPageWidget(),
              bottomNavigationBar: NavBarPage(
                initialPage: '/performer',
              ),
            ),
        '/customer': (context, state, data) => const Scaffold(
              body: CustomerPageWidget(),
              bottomNavigationBar: NavBarPage(
                initialPage: '/customer',
              ),
            ),
        '/auditor': (context, state, data) => const Scaffold(
              body: AuditorPageWidget(),
              bottomNavigationBar: NavBarPage(
                initialPage: '/auditor',
              ),
            ),
        '/accounts': (context, state, data) => const Scaffold(
              body: AccountsPage(),
              bottomNavigationBar: NavBarPage(
                initialPage: '/accounts',
              ),
            ),
        '/stats': (context, state, data) => const Scaffold(
              body: StatisticsPage(),
              bottomNavigationBar: NavBarPage(
                initialPage: '/stats',
              ),
            ),
        '/wallet': (context, state, data) => showDialog(
              context: context,
              builder: (context) => const WalletDialog(),
            ),
        '/tasks/:taskAddress': (context, state, data) {
          EthereumAddress taskAddress = EthereumAddress.fromHex(state.pathParameters['taskAddress']!);
          return Scaffold(
            body: TasksPageWidget(taskAddress: taskAddress),
            bottomNavigationBar: const NavBarPage(
              initialPage: '/tasks',
            ),
          );
        },
        '/customer/:taskAddress': (context, state, data) {
          EthereumAddress taskAddress = EthereumAddress.fromHex(state.pathParameters['taskAddress']!);
          return Scaffold(
            body: CustomerPageWidget(taskAddress: taskAddress),
            bottomNavigationBar: const NavBarPage(
              initialPage: '/customer',
            ),
          );
        },
        '/performer/:taskAddress': (context, state, data) {
          EthereumAddress taskAddress = EthereumAddress.fromHex(state.pathParameters['taskAddress']!);
          return Scaffold(
            body: PerformerPageWidget(taskAddress: taskAddress),
            bottomNavigationBar: const NavBarPage(
              initialPage: '/performer',
            ),
          );
        },
        '/auditor/:taskAddress': (context, state, data) {
          EthereumAddress taskAddress = EthereumAddress.fromHex(state.pathParameters['taskAddress']!);
          return Scaffold(
            body: AuditorPageWidget(taskAddress: taskAddress),
            bottomNavigationBar: const NavBarPage(
              initialPage: '/auditor',
            ),
          );
        },
        '/accounts/:taskAddress': (context, state, data) {
          EthereumAddress taskAddress = EthereumAddress.fromHex(state.pathParameters['taskAddress']!);
          return Scaffold(
            body: AuditorPageWidget(taskAddress: taskAddress),
            bottomNavigationBar: const NavBarPage(
              initialPage: '/accounts',
            ),
          );
        },
      },
    ),
  );
}
