import 'package:dodao/blockchain/empty_classes.dart';
import 'package:dodao/blockchain/notify_listener.dart';
import 'package:dodao/tags_manager/collection_services.dart';
import 'package:dodao/widgets/tags/main.dart';
import 'package:dodao/widgets/tags/search_services.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';
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
        ChangeNotifierProvider(create: (context) => MyNotifyListener()),
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
        ChangeNotifierProxyProvider<TasksServices, SearchServices>(
          create: (_) => SearchServices(),
          update: (_, tasksServices, searchServices) {
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
      create: (_) => ModelTheme(),
      child: Consumer<ModelTheme>(
      builder: (context, ModelTheme themeNotifier, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen.navigate(
            name: 'assets/rive_animations/cat-blinking.riv',
            until: () => Future.delayed(const Duration(seconds: 1)),
            startAnimation: 'Opening one eye',
            width: 210,
            height: 210,

            next: (context) => MaterialApp.router(
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

                    systemOverlayStyle: SystemUiOverlayStyle(
                      // statusBarColor: Colors.white,
                      statusBarIconBrightness: Brightness.dark,
                      statusBarBrightness: Brightness.light,
                      // systemNavigationBarColor: Colors.white,
                    ),
                    color: Colors.white,
                    surfaceTintColor: Colors.white
                ),

                // iconTheme: const IconThemeData(
                //   color: Colors.black,
                // ),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                    selectedItemColor: Colors.black
                ),

                // primaryColor: const Color(0xff31d493),
                // cardColor: Colors.black,
                textTheme: TextTheme(
                    bodyLarge: TextStyle(fontSize: 20, color: DodaoTheme.of(context).secondaryText),
                    bodyMedium: TextStyle(fontSize: 15, color: DodaoTheme.of(context).secondaryText),
                    bodySmall: TextStyle(fontSize: 12, color: DodaoTheme.of(context).secondaryText),
                    titleLarge: const TextStyle(fontSize: 22, color: Colors.black),
                    titleMedium: const TextStyle(fontSize: 18, color: Colors.black)
                ),

                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(155, 40),
                    disabledBackgroundColor: Colors.grey.shade300,
                    backgroundColor: DodaoTheme.of(context).buttonBackgroundColor,
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
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.light,
                    statusBarBrightness: Brightness.dark,
                    // systemNavigationBarColor: Colors.white,
                  ),
                  // backgroundColor: Colors.black,
                  color: Colors.black,
                  surfaceTintColor: Colors.black,
                  // toolbarTextStyle: TextStyle(fontSize: 23, color: Colors.white),
                  // titleTextStyle: TextStyle(fontSize: 23, color: Colors.white),

                ),
                inputDecorationTheme: const InputDecorationTheme(

                  // fillColor: Colors.orange,
                  // labelStyle: TextStyle(fontSize: 23, color: Colors.white),
                  // floatingLabelStyle: TextStyle(fontSize: 23, color: Colors.white),
                  // helperStyle: TextStyle(fontSize: 23, color: Colors.white),
                  // filled: true,
                ),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                    selectedItemColor: Colors.white70
                ),
                // primaryColor: Colors.green,
                // primarySwatch: Colors.green,

                textTheme: const TextTheme(
                  bodyLarge: TextStyle(fontSize: 19, color: Colors.white70),
                  bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
                  bodySmall: TextStyle(fontSize: 12, color: Colors.white70),
                  titleLarge: TextStyle(fontSize: 22, color: Colors.white),
                  titleMedium: TextStyle(fontSize: 18, color: Colors.white),

                ),
                textSelectionTheme: const TextSelectionThemeData(
                  cursorColor: Colors.white70,
                  selectionColor: Colors.white70,
                  selectionHandleColor: Colors.white70,
                ),

                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(155, 40),
                    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    disabledBackgroundColor: Colors.grey.shade800,
                    backgroundColor: DodaoTheme.of(context).buttonBackgroundColor,
                    // textStyle: const TextStyle(
                    //     color: Colors.red,
                    //     fontWeight: FontWeight.w400
                    // )
                  ),
                ),

                // iconTheme: const IconThemeData(
                //   color: Colors.white,
                // ),
              ),
              // Theme mode settings:
              themeMode: themeNotifier.isDark  ? ThemeMode.dark : ThemeMode.light,




              // SplashScreen.navigate(
              //   name: 'intro.riv',
              //   next: (context) => MyHomePage(title: 'Flutter Demo Home Page'),
              //   until: () => Future.delayed(Duration(seconds: 2)),
              //   startAnimation: 'Landing',
              // ),
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
            ),
        )



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
    _isDark = true;
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
