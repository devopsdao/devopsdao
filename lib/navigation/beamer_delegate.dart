// import 'dart:ffi';

import 'package:beamer/beamer.dart';
import 'package:dodao/pages/auditor_page.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:webthree/webthree.dart';
import '../wallet/widgets/main/main.dart';
import 'appbar.dart';
import 'authenticator.dart';
// import '../../screens.dart';
import '../index.dart';

import 'package:flutter/material.dart';

import 'navbar.dart';
import 'navmenu.dart';

// import './screens.dart';

late final BeamerDelegate beamerDelegate;

void createBeamerDelegate() {
  beamerDelegate = BeamerDelegate(
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
    // updateListenable: authenticator,
    // guards: [
    //   // BeamGuard(
    //   //   pathPatterns: ['/home1'],
    //   //   check: (_, __) => authenticator.isLoading,
    //   //   beamToNamed: (_, __, deepLink) => authenticator.isAuthenticated ? (deepLink ?? '/home') : '/home',
    //   // ),
    //   //   BeamGuard(
    //   //     pathPatterns: ['/login'],
    //   //     check: (_, __) => authenticator.isNotAuthenticated,
    //   //     beamToNamed: (_, __, deepLink) =>
    //   //         authenticator.isAuthenticated ? (deepLink ?? '/home') : '/splash',
    //   //   ),
    //   // BeamGuard(
    //   //   pathPatterns: ['/tasks/:taskAddress', '/performer/:taskAddress'],
    //   //   guardNonMatching: true,
    //   //   check: (_, __) => authenticator.isAuthenticated,
    //   //   beamToNamed: (context, state, data) =>
    //   //       authenticator.isNotAuthenticated ? '/home' : '/splash',
    //   // ),
    // ],
  );
}
