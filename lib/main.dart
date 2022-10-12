import 'package:provider/provider.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'auditor_page/auditor_page.dart';
import 'blockchain/interface.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'index.dart';

import 'package:devopsdao/blockchain/task_services.dart';

import 'job_exchange/job_exchange_widget.dart';

import '../beamer/authenticator.dart';
import '../beamer/beamer_delegate.dart';
import 'package:beamer/beamer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterFlowTheme.initialize();

  createAuthenticator();
  createBeamerDelegate();
  beamerDelegate.setDeepLink('/home');
  beamerDelegate.beamToNamed('/tasks/1');

  // runApp(MyApp());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TasksServices()),
        ChangeNotifierProvider(create: (context) => InterfaceServices()),
      ],
      child: MyApp(),
    ),
    // ChangeNotifierProvider(
    //   create: (context) => TasksServices(),
    //   child: MyApp(),
    // ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;

  // Widget build(BuildContext context) {
  //   return MaterialApp.router(
  //     routerDelegate: beamerDelegate,
  //     routeInformationParser: BeamerParser(),
  //   );
  // }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  bool displaySplashImage = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1),
        () => setState(() => displaySplashImage = false));
  }

  void setLocale(Locale value) => setState(() => _locale = value);
  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'devopsdao',
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      // Theme mode settings:
      // themeMode: _themeMode,
      themeMode: ThemeMode.light,
      home: displaySplashImage
          ? Container(
              color: Colors.black,
              child: Center(
                child: Builder(
                  builder: (context) => Image.asset(
                    'assets/images/logo.png',
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.6,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            )
          : NavBarPage(),
    );
  }
}

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
      '/tasks': const JobExchangeWidget(),
      '/tasks/1': const JobExchangeWidget(),
      '/customer': const SubmitterPageWidget(),
      '/performer': const PerformerPageWidget(),
      '/auditor': const AuditorPageWidget(),
      // 'walletPage': MyWalletPage(title: 'WalletConnect'),
      // 'orangePage': MyOrangePage(title: 'WalletConnect'),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPage);

    // final currentPage = beamerDelegate.currentBeamLocation;
    final beamerRouter = MaterialApp.router(
        routerDelegate: beamerDelegate, routeInformationParser: BeamerParser());
    return Scaffold(
      body: beamerRouter,
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }
}
