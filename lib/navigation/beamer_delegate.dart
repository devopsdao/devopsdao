// import 'dart:ffi';

import 'package:beamer/beamer.dart';
import 'package:devopsdao/auditor_page/auditor_page.dart';
import 'authenticator.dart';
// import '../../screens.dart';
import '../index.dart';

import 'package:flutter/material.dart';

import 'navbar.dart';

// import './screens.dart';

late final BeamerDelegate beamerDelegate;

void createBeamerDelegate() {
  beamerDelegate = BeamerDelegate(
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/home': (context, state, data) => Scaffold(
            body: const HomePageWidget(),
            bottomNavigationBar: NavBarPage(
              initialPage: '/home',
            )),
        '/tasks': (context, state, data) => Scaffold(
              body: const JobExchangeWidget(),
              bottomNavigationBar: NavBarPage(
                initialPage: '/tasks',
              ),
            ),
        '/performer': (context, state, data) => Scaffold(
              body: const PerformerPageWidget(),
              bottomNavigationBar: NavBarPage(
                initialPage: '/performer',
              ),
            ),
        '/customer': (context, state, data) => Scaffold(
              body: const SubmitterPageWidget(),
              bottomNavigationBar: NavBarPage(
                initialPage: '/customer',
              ),
            ),
        '/auditor': (context, state, data) => Scaffold(
              body: const AuditorPageWidget(),
              bottomNavigationBar: NavBarPage(
                initialPage: '/auditor',
              ),
            ),
        '/tasks/:taskId': (context, state, data) {
          String nanoId = state.pathParameters['taskId']!;
          // if (state.pathParameters.containsKey('taskId')) {
          //   // const index = ValueKey('book-${state.pathParameters['bookId']}');

          //   nanoId = state.pathParameters['taskId']!;
          //   // print('nanoId:');

          //   // print(nanoId);
          // }

          return Scaffold(
            body: JobExchangeWidget(nanoId: nanoId),
            bottomNavigationBar: NavBarPage(),
          );
        },
      },
    ),
    updateListenable: authenticator,
    guards: [
      BeamGuard(
        pathPatterns: ['/home1'],
        check: (_, __) => authenticator.isLoading,
        beamToNamed: (_, __, deepLink) =>
            authenticator.isAuthenticated ? (deepLink ?? '/home') : '/home',
      ),
      //   BeamGuard(
      //     pathPatterns: ['/login'],
      //     check: (_, __) => authenticator.isNotAuthenticated,
      //     beamToNamed: (_, __, deepLink) =>
      //         authenticator.isAuthenticated ? (deepLink ?? '/home') : '/splash',
      //   ),
      //   BeamGuard(
      //     pathPatterns: ['/splash', '/login'],
      //     guardNonMatching: true,
      //     check: (_, __) => authenticator.isAuthenticated,
      //     beamToNamed: (context, state, data) =>
      //         authenticator.isNotAuthenticated ? '/login' : '/splash',
      //   ),
    ],
  );
}
