import 'package:devopsdao/blockchain/empty_classes.dart';
import 'package:devopsdao/widgets/tags/main.dart';
import 'package:devopsdao/widgets/tags/search_services.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'blockchain/interface.dart';
import 'flutter_flow/theme.dart';
import 'flutter_flow/internationalization.dart';

import 'package:devopsdao/blockchain/task_services.dart';

import 'navigation/authenticator.dart';
import 'navigation/beamer_delegate.dart';
import 'package:beamer/beamer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DodaoTheme.initialize();

  createAuthenticator();
  createBeamerDelegate();
  beamerDelegate.setDeepLink('/home');
  // beamerDelegate.beamToNamed('/tasks/1');

  // runApp(MyApp());
  var taskServices = TasksServices();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TasksServices()),
        ChangeNotifierProvider(create: (context) => InterfaceServices()),
        ChangeNotifierProvider(create: (context) => EmptyClasses()),
        ChangeNotifierProvider(create: (context) => SearchServices()),
        // ChangeNotifierProxyProvider<TasksServices, SearchServices>(
        //   create: (_) => SearchServices(),
        //   update: (_, tasksServices, searchServices) {
        //     return searchServices!..filterResults = tasksServices.filterResults;
        //   },
        // ),
        ChangeNotifierProxyProvider<SearchServices, TasksServices>(
          create: (_) => TasksServices(),
          update: (_, searchServices, tasksServices) {
            return tasksServices!..tagsList = searchServices.tagsListToPass;
          },
        )
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

  static _MyAppState of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>()!;

  // Widget build(BuildContext context) {
  //   return MaterialApp.router(
  //     routerDelegate: beamerDelegate,
  //     routeInformationParser: BeamerParser(),
  //   );
  // }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  bool displaySplashImage = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () => setState(() => displaySplashImage = false));
  }

  void setLocale(Locale value) => setState(() => _locale = value);
  void setThemeMode(ThemeMode mode) => setState(() {
        DodaoTheme.saveThemeMode(mode);
      });

  // final beamerRouter = MaterialApp.router(
  //     routerDelegate: beamerDelegate, routeInformationParser: BeamerParser());

  @override
  Widget build(BuildContext context) {
    // return MaterialApp.router(
    //   routerDelegate: beamerDelegate,
    //   routeInformationParser: BeamerParser(),
    // );
    return MaterialApp.router(
      routerDelegate: beamerDelegate,
      routeInformationParser: BeamerParser(),
      backButtonDispatcher: BeamerBackButtonDispatcher(delegate: beamerDelegate),
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
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        // useMaterial3: true,
        brightness: Brightness.light,
        splashFactory: NoSplash.splashFactory,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),

        // primaryColor: const Color(0xff31d493),
        // cardColor: Colors.black,
        // textTheme: const TextTheme(
        //     bodyText1: TextStyle(fontSize: 20, color: Colors.white)),
        // colorScheme: ColorScheme.light().copyWith(secondary: Colors.black),
      ),
      darkTheme: ThemeData(brightness: Brightness.dark, splashFactory: NoSplash.splashFactory),
      // Theme mode settings:
      // themeMode: _themeMode,
      themeMode: ThemeMode.light,
      // home: displaySplashImage
      //     ? Container(
      //         color: Colors.black,
      //         child: Center(
      //           child: Builder(
      //             builder: (context) => Image.asset(
      //               'assets/images/logo.png',
      //               width: MediaQuery.of(context).size.width * 0.6,
      //               height: MediaQuery.of(context).size.height * 0.6,
      //               fit: BoxFit.fitWidth,
      //             ),
      //           ),
      //         ),
      //       )
      //     : NavBarPage(),
    );
  }
}
