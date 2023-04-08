import 'package:dodao/blockchain/empty_classes.dart';
import 'package:dodao/tags_manager/collection_services.dart';
import 'package:dodao/widgets/tags/main.dart';
import 'package:dodao/widgets/tags/search_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'blockchain/interface.dart';
import 'config/theme.dart';
import 'config/internationalization.dart';

import 'package:dodao/blockchain/task_services.dart';

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
  // var taskServices = TasksServices();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TasksServices()),
        ChangeNotifierProvider(create: (context) => InterfaceServices()),
        ChangeNotifierProvider(create: (context) => EmptyClasses()),
        ChangeNotifierProvider(create: (context) => SearchServices()),
        ChangeNotifierProvider(create: (context) => CollectionServices()),
        // ChangeNotifierProxyProvider<TasksServices, SearchServices>(
        //   create: (_) => SearchServices(),
        //   update: (_, tasksServices, searchServices) {
        //     return searchServices!..filterResults = tasksServices.filterResults;
        //   },
        // ),
        // ChangeNotifierProxyProvider<CollectionServices, TasksServices>(
        //   create: (_) => TasksServices(),
        //   update: (_, collectionServices, tasksServices) {
        //     return tasksServices!..resultNftsMap = collectionServices.resultNftsMapReceived;
        //   },
        // )
        // ChangeNotifierProxyProvider<TasksServices , SearchServices>(
        //   create: (_) => SearchServices(),
        //   update: (_,tasksServices , searchServices) {
        //     return searchServices!..nftBalanceMap = tasksServices.resultNftsMap;
        //   },
        // ),
        ChangeNotifierProxyProvider<TasksServices , SearchServices>(
          create: (_) => SearchServices(),
          update: (_,tasksServices , searchServices) {
            searchServices!.nftCollectionMap = tasksServices.resultInitialCollectionMap;
            return searchServices..nftBalanceMap = tasksServices.resultNftsMap;
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
    return ChangeNotifierProvider(
      create: (_) => ModelTheme(),
      child: Consumer<ModelTheme>(
      builder: (context, ModelTheme themeNotifier, child) {
        return MaterialApp.router(
          routerDelegate: beamerDelegate,
          routeInformationParser: BeamerParser(),
          backButtonDispatcher: BeamerBackButtonDispatcher(delegate: beamerDelegate),
          debugShowCheckedModeBanner: false,
          title: 'dodao.dev',
          localizationsDelegates: const [
            FFLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: _locale,
          supportedLocales: const [Locale('en', '')],
          theme:

          // ******************* Light
          ThemeData(
            fontFamily: GoogleFonts.inter().fontFamily,
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            splashFactory: NoSplash.splashFactory,
            useMaterial3: true,

            appBarTheme: const AppBarTheme(
              // backgroundColor: Colors.black,
                color: Colors.white,
                surfaceTintColor: Colors.white
            ),

            // iconTheme: const IconThemeData(
            //   color: Colors.black,
            // ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Colors.black
            ),

            primaryColor: const Color(0xff31d493),
            // cardColor: Colors.black,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(fontSize: 20, color: Colors.white),
              titleLarge: TextStyle(fontFamily: 'Inter', fontSize: 22,)
            ),

            // colorScheme: ColorScheme.light().copyWith(secondary: Colors.black),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(155, 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                disabledBackgroundColor: Colors.grey[800],
                // textStyle: const TextStyle(
                //     color: Colors.red,
                //     fontWeight: FontWeight.w400
                // )
              ),
            ),
          ),

          // ******************* Dark

          darkTheme: ThemeData(

            fontFamily: GoogleFonts.inter().fontFamily,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.black,
            splashFactory: NoSplash.splashFactory,
            useMaterial3: true,

            appBarTheme: const AppBarTheme(
              // backgroundColor: Colors.black,
                color: Colors.black,
                surfaceTintColor: Colors.black
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                selectedItemColor: Colors.white
            ),
            primaryColor: Colors.green,
            primarySwatch: Colors.green,

            // iconTheme: const IconThemeData(
            //   color: Colors.white,
            // ),
          ),
          // Theme mode settings:
          themeMode: themeNotifier.isDark  ? ThemeMode.dark : ThemeMode.light,
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
    ));
  }
}

class MyThemePreferences {
  static const themeKey = "theme_key";

  setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(themeKey, value);
  }

  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(themeKey) ?? false;
  }
}

class ModelTheme extends ChangeNotifier {
  late bool _isDark;
  late MyThemePreferences _preferences;
  bool get isDark => _isDark;

  ModelTheme() {
    _isDark = false;
    _preferences = MyThemePreferences();
    getPreferences();
  }
//Switching the themes
  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }

  getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }
}
