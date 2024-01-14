import 'dart:io';
import 'package:browser_detector/browser_detector.dart' hide Platform;
import "package:universal_html/html.dart" hide Platform;
import 'package:webthree/browser.dart';

class PlatformAndBrowser {
  String platform = 'mobile';
  final BrowserDetector browserInfo = BrowserDetector();
  String? browserPlatform;
  bool metamaskAvailable = false;

  PlatformAndBrowser() {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        platform = 'mobile';
      } else if (Platform.isLinux) {
        platform = 'linux';
      }
    } catch (e) {
      platform = 'web';
    }

    if (browserInfo.platform.isAndroid) {
      browserPlatform = 'android';
    }
    if (browserInfo.platform.isIOS) {
      browserPlatform = 'ios';
    }
    if (browserInfo.platform.isLinux) {
      browserPlatform = 'linux';
    }
    if (platform == 'web' && window.ethereum != null && window.ethereum?.isMetaMask == true) {
      metamaskAvailable = true;
    }
  }
}