import 'dart:developer';

import 'package:firebase_remote_config/firebase_remote_config.dart';
class Config{
  static final _config = FirebaseRemoteConfig.instance;
  static const _defaultValues={
    "openapp_ad": "ca-app-pub-3084693527380725/7735522110",
    "native_ad": "ca-app-pub-3084693527380725/2449436220",
    "interstitial_ad": "ca-app-pub-3084693527380725/7440325873",
    "show_ads": true,
  };
  static Future<void> initConfig() async
  {
    await _config.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 30),
    ));

    await _config.setDefaults(_defaultValues);
    await _config.fetchAndActivate();
    log('Remote Config data: ${_config.getBool('show_ads')}');
    _config.onConfigUpdated.listen((event)async {
      _config.activate();
      log('Updated: ${_config.getBool('show_ads')}');
    });
  }

  static bool get showAd => _config.getBool('show_ads');
  static String get interstitialAd => _config.getString('interstitial_ad');
  static String get nativeAd => _config.getString('native_ad');
  static String get openAppAd => _config.getString('openapp_ad');
  

}