import 'package:provider/provider.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'index.dart';

import 'package:devopsdao/blockchain/task_services.dart';

import 'job_exchange/job_exchange_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterFlowTheme.initialize();

  // runApp(MyApp());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TasksServices()),
        // ChangeNotifierProvider(create: (context) => ExchangeFilterWidget()),
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
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  bool displaySplashImage = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(
        Duration(seconds: 1), () => setState(() => displaySplashImage = false));
  }

  void setLocale(Locale value) => setState(() => _locale = value);
  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'devopsdao',
      localizationsDelegates: [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: _themeMode,
      home: displaySplashImage
          ? Container(
              color: Colors.black,
              child: Center(
                child: Builder(
                  builder: (context) => Image.asset(
                    'assets/images/34.png',
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
  String _currentPage = 'homePage';

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage ?? _currentPage;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'homePage': HomePageWidget(),
      'jobExchange': JobExchangeWidget(),
      'submitterPage': SubmitterPageWidget(),
      'performerPage': PerformerPageWidget(),
      'walletPage': MyWalletPage(title: 'WalletConnect'),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPage);
    return Scaffold(
      body: tabs[_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => _currentPage = tabs.keys.toList()[i]),
        backgroundColor: FlutterFlowTheme.of(context).black600,
        selectedItemColor: Colors.white,
        unselectedItemColor: FlutterFlowTheme.of(context).grayIcon,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
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
              Icons.work_outline_sharp,
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
              FontAwesomeIcons.pen,
              size: 24,
            ),
            label: 'Wallet',
            tooltip: '',
          )
        ],
      ),
    );
  }
}
