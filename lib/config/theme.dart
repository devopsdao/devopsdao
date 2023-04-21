// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import 'package:shared_preferences/shared_preferences.dart';

const kThemeModeKey = '__theme_mode__';
SharedPreferences? _prefs;

abstract class DodaoTheme {
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static ThemeMode get themeMode {
    final darkMode = _prefs?.getBool(kThemeModeKey);
    return darkMode == null
        ? ThemeMode.system
        : darkMode
            ? ThemeMode.dark
            : ThemeMode.light;
  }

  static void saveThemeMode(ThemeMode mode) => mode == ThemeMode.system
      ? _prefs?.remove(kThemeModeKey)
      : _prefs?.setBool(kThemeModeKey, mode == ThemeMode.dark);

  static DodaoTheme of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? DarkModeTheme()
          : LightModeTheme();

  late Color transparentCloud;
  late Color background;
  late Color taskBackgroundColor;
  late Color walletBackgroundColor;
  late Color nftInfoBackgroundColor;
  late Color nftCardBackgroundColor;

  late Color primaryText;
  late Color revertedPrimaryTextColor;
  late Color secondaryText;
  late Color tabIndicator;

  late Color chipTextColor;
  late Color chipBodyColor;
  late Color chipBorderColor;
  late Color chipNftColor;
  late Color chipNftMintColor;
  late Color chipSelectedColor;

  late Color iconInitial;
  late Color iconProcess;
  late Color iconDone;
  late Color iconWrong;

  late Color buttonTextColor;
  late Color buttonBackgroundColor;
  late Color buttonDisabledColor;
  late Color buttonDisabledBackgroundColor;

  late Color maximumBlueGreen = const Color(0xFF59C3C3);
  late Color createTaskButton;

  late Image witnetLogo;

  late Color flushTextColor = Colors.white;
  late Color flushForCopyBackgroundColor = Colors.blueAccent;

  final BorderRadius borderRadius = BorderRadius.circular(14.0);
  final double elevation = 7;

  late LinearGradient gradient;

  late GradientBoxBorder borderGradient;
  late GradientBoxBorder pictureBorderGradient;

  late LinearGradient smallButtonGradient = const LinearGradient(
      begin: AlignmentDirectional(1, -1),
      end: AlignmentDirectional(-1, 1),
      colors: [
        Colors.purpleAccent,
        Colors.purple,
      ]
  );


  String get title1Family => typography.title1Family;
  TextStyle get title1 => typography.title1;
  String get title2Family => typography.title2Family;
  TextStyle get title2 => typography.title2;
  String get title3Family => typography.title3Family;
  TextStyle get title3 => typography.title3;
  String get subtitle1Family => typography.subtitle1Family;
  TextStyle get subtitle1 => typography.subtitle1;
  String get subtitle2Family => typography.subtitle2Family;
  TextStyle get subtitle2 => typography.subtitle2;
  String get bodyText1Family => typography.bodyText1Family;
  TextStyle get bodyText1 => typography.bodyText1;
  String get bodyText2Family => typography.bodyText2Family;
  TextStyle get bodyText2 => typography.bodyText2;
  String get bodyText3Family => typography.bodyText3Family;
  TextStyle get bodyText3 => typography.bodyText3;

  Typography get typography => ThemeTypography(this);
}

class LightModeTheme extends DodaoTheme {
  late Color transparentCloud = Colors.black26;
  late Color background = Colors.white;
  late Color taskBackgroundColor = Colors.white;
  late Color walletBackgroundColor = Colors.grey.shade100;
  late Color nftInfoBackgroundColor = Colors.grey.shade200;
  late Color nftCardBackgroundColor = Colors.grey.shade600;

  late Color primaryText = const Color(0xFF101213);
  late Color revertedPrimaryTextColor = Colors.black;
  late Color secondaryText = Colors.grey.shade800;
  late Color tabIndicator = const Color(0xFF47CBE4);

  late Color chipTextColor = Colors.black;
  late Color chipBodyColor = Colors.white;
  late Color chipBorderColor = Colors.grey.shade400;
  late Color chipNftColor = Colors.deepOrange;
  late Color chipNftMintColor = Colors.white;
  late Color chipSelectedColor = Colors.orangeAccent;

  late Color iconInitial = Colors.black12;
  late Color iconProcess = Colors.black54;
  late Color iconDone = Colors.lightGreen;
  late Color iconWrong = Colors.redAccent;

  late Color buttonTextColor = Colors.white;
  late Color buttonBackgroundColor = Colors.lightBlue.shade300;
  late Color buttonDisabledColor = Colors.white;
  late Color buttonDisabledBackgroundColor = Colors.grey.shade300;

  late Color createTaskButton = const Color(0xFFCDBEE4);

  late Image witnetLogo = Image.asset(
    'assets/images/witnet_logo_light.png',
    height: 44,
    filterQuality: FilterQuality.medium,
  );

  late LinearGradient gradient = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
    Colors.green.shade800,
    Colors.yellow.shade600,
  ]);

  late GradientBoxBorder borderGradient = const GradientBoxBorder(
    gradient: LinearGradient(
      colors: [Color(0xFFE8E8E8), Color(0xFFE8E8E8)],
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
    ),
    width: 1,
  );

  late GradientBoxBorder pictureBorderGradient = GradientBoxBorder(
    gradient: LinearGradient(
      colors: [Colors.grey.shade900, Color(0xFF6E6E6E)],
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
    ),
    width: 2,
  );
}

abstract class Typography {
  String get title1Family;
  TextStyle get title1;
  String get title2Family;
  TextStyle get title2;
  String get title3Family;
  TextStyle get title3;
  String get subtitle1Family;
  TextStyle get subtitle1;
  String get subtitle2Family;
  TextStyle get subtitle2;
  String get bodyText1Family;
  TextStyle get bodyText1;
  String get bodyText2Family;
  TextStyle get bodyText2;
  String get bodyText3Family;
  TextStyle get bodyText3;
}

class ThemeTypography extends Typography {
  ThemeTypography(this.theme);

  final DodaoTheme theme;

  String get title1Family => 'Inter';
  TextStyle get title1 => GoogleFonts.getFont(
        'Inter',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 24,
      );
  String get title2Family => 'Inter';
  TextStyle get title2 => GoogleFonts.getFont(
        'Inter',
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 22,
      );
  String get title3Family => 'Inter';
  TextStyle get title3 => GoogleFonts.getFont(
        'Inter',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      );
  String get subtitle1Family => 'Inter';
  TextStyle get subtitle1 => GoogleFonts.getFont(
        'Inter',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      );
  String get subtitle2Family => 'Inter';
  TextStyle get subtitle2 => GoogleFonts.getFont(
        'Inter',
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      );
  String get bodyText1Family => 'Inter';
  TextStyle get bodyText1 => GoogleFonts.getFont(
        'Inter',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      );
  String get bodyText2Family => 'Inter';
  TextStyle get bodyText2 => GoogleFonts.getFont(
        'Inter',
        color: theme.secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      );
  String get bodyText3Family => 'Inter';
  TextStyle get bodyText3 => GoogleFonts.getFont(
    'Inter',
    color: theme.secondaryText,
    fontWeight: FontWeight.w400,
    fontSize: 13,
  );
}

class DarkModeTheme extends DodaoTheme {
  late Color transparentCloud = Colors.white12;
  late Color background = Colors.black;
  late Color taskBackgroundColor = const Color(0xFF1D1B20);
  late Color walletBackgroundColor = const Color(0xFF302D34);
  late Color nftInfoBackgroundColor = const Color(0xFF302D34);
  late Color nftCardBackgroundColor = Colors.grey.shade700;

  late Color primaryText = const Color(0xFFFFFFFF);
  late Color revertedPrimaryTextColor = Colors.white;
  late Color secondaryText = Colors.grey.shade300;

  late Color chipTextColor = Colors.grey.shade300;
  late Color chipBodyColor = Colors.grey.shade800;
  late Color chipBorderColor = Colors.grey.shade800;
  late Color chipNftColor = Colors.deepOrange;
  late Color chipNftMintColor = Colors.white;
  late Color chipSelectedColor = Colors.orange.shade900;

  late Color iconInitial = Colors.white24;
  late Color iconProcess = Colors.white70;
  late Color iconDone = Colors.lightGreen;
  late Color iconWrong = Colors.redAccent;

  late Color tabIndicator = const Color(0xFF47CBE4);

  late Color buttonTextColor = Colors.white;
  late Color buttonBackgroundColor = Colors.lightBlue.shade300;
  late Color buttonDisabledColor = Colors.white;
  late Color buttonDisabledBackgroundColor = Colors.grey.shade800;

  late Image witnetLogo = Image.asset(
    'assets/images/witnet_logo_dark.png',
    height: 44,
    filterQuality: FilterQuality.medium,
  );

  late Color createTaskButton = const Color(0xFF4E378C);

  late LinearGradient gradient = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
    Colors.green.shade800,
    Colors.yellow.shade600,
  ]);

  late GradientBoxBorder borderGradient = const GradientBoxBorder(
    gradient: LinearGradient(
      colors: [Color(0xFF5B5B5B), Color(0xFF1D1B20)],
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
    ),
    width: 1,
  );

  late GradientBoxBorder pictureBorderGradient = const GradientBoxBorder(
    gradient: LinearGradient(
      colors: [Color(0xFFD0D0D0), Color(0xFF6E6E6E)],
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
    ),
    width: 2,
  );
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily!,
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              letterSpacing: letterSpacing ?? this.letterSpacing,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
              decoration: decoration,
              height: lineHeight,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              letterSpacing: letterSpacing,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              decoration: decoration,
              height: lineHeight,
            );
}
