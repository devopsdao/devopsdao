import 'package:beamer/beamer.dart';
import 'package:devopsdao/auditor_page/auditor_page.dart';
import 'authenticator.dart';
// import '../../screens.dart';
import '../index.dart';

late final BeamerDelegate beamerDelegate;

void createBeamerDelegate() {
  beamerDelegate = BeamerDelegate(
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/home': (_, __, ___) => const HomePageWidget(),
        '/tasks': (_, __, ___) => const JobExchangeWidget(),
        '/performer': (_, __, ___) => const PerformerPageWidget(),
        '/customer': (_, __, ___) => const SubmitterPageWidget(),
        '/auditor': (_, __, ___) => const AuditorPageWidget(),
      },
    ),
    updateListenable: authenticator,
    // guards: [
    //   BeamGuard(
    //     pathPatterns: ['/splash'],
    //     check: (_, __) => authenticator.isLoading,
    //     beamToNamed: (_, __, deepLink) =>
    //         authenticator.isAuthenticated ? (deepLink ?? '/home') : '/login',
    //   ),
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
    //     beamToNamed: (_, __, ___) =>
    //         authenticator.isNotAuthenticated ? '/login' : '/splash',
    //   ),
    // ],
  );
}
