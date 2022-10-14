import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'authenticator.dart';
import 'package:flutter/material.dart';

import 'navbar.dart';
import '../index.dart';

// LOCATIONS
class BooksLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => ['/books/:bookId'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        const BeamPage(
          key: ValueKey('books'),
          title: 'Books',
          type: BeamPageType.noTransition,
          child: JobExchangeWidget(),
        ),
        // if (state.pathParameters.containsKey('bookId'))
        //   const BeamPage(
        //     key: ValueKey('book-1'),
        //     title: 'test',
        //     child: JobExchangeWidget(
        //       index: 1,
        //     ),
        //   ),
      ];
}

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final _beamerKey = GlobalKey<BeamerState>();
  final _routerDelegate = BeamerDelegate(
    locationBuilder: BeamerLocationBuilder(
      beamLocations: [
        BooksLocation(),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Beamer(
        key: _beamerKey,
        routerDelegate: _routerDelegate,
      ),
      bottomNavigationBar: NavBarPage(
          // beamerKey: _beamerKey,
          ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Auto login in progress...'),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => authenticator.login(),
          child: const Text('Login'),
        ),
      ),
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         // body: beamerRouter,
//         bottomNavigationBar: NavBarPage());
//   }
// }

class DeeperScreen extends StatelessWidget {
  const DeeperScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deeper Screen'),
      ),
    );
  }
}
