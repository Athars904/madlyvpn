import 'dart:async';
import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madlyvpn/controllers/nativeadcontroller.dart';
import 'package:madlyvpn/helpers/messages.dart';
import 'package:madlyvpn/helpers/remoteconfig.dart';

class AdHelper {
  static Future<void> initAds() async {
    await MobileAds.instance.initialize();
    await _precacheAds(); // Pre-cache ads after initialization
  }

  static Future<void> _precacheAds() async {
    await _precacheInterstitialAd();
    await _precacheNativeAd();
    await _precacheAppOpenAd();
  }

  static Future<void> _precacheInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: Config.interstitialAd,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (_) {
          log('Interstitial ad pre-cached.');
        },
        onAdFailedToLoad: (err) {
          log('Failed to pre-cache interstitial ad: $err');
        },
      ),
    );
  }

  static Future<void> _precacheNativeAd() async {
    final nativeAd = NativeAd(
      adUnitId: Config.nativeAd,
      listener: NativeAdListener(
        onAdLoaded: (_) {
          log('Native ad pre-cached.');
        },
        onAdFailedToLoad: (_, error) {
          log('Failed to pre-cache native ad: $error');
        },
      ),
      request: const AdRequest(),
      // Styling
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
      ),
    );

    await nativeAd.load();
  }


  static Future<void> _precacheAppOpenAd() async {
    await AppOpenAd.load(
      adUnitId: Config.openAppAd,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (_) {
          log('App Open ad pre-cached.');
        },
        onAdFailedToLoad: (error) {
          log('Failed to pre-cache app open ad: $error');
        },
      ),
    );
  }

  static void showInterstitialAd({required VoidCallback onComplete}) {
    MyMessages.progress();
    InterstitialAd.load(
      adUnitId: Config.interstitialAd,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              onComplete(); // Call the onComplete callback function
            },
          );
          Get.back();
          ad.show();
        },
        onAdFailedToLoad: (err) {
          Get.back();
        },
      ),
    );
  }

  static NativeAd loadNativeAd(NativeAdController adController) {
    return NativeAd(
        adUnitId: Config.nativeAd,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            log('$NativeAd loaded.');
            adController.adLoaded.value = true;
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            log('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
          templateType: TemplateType.small,
        ))
      ..load();
  }

  static AppOpenAd? loadAppOpen() {
    AppOpenAd? appOpenAd;
    AppOpenAd.load(
      adUnitId: Config.openAppAd,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          ad.show();
          appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          Get.back();
        },
      ),
    );
    return appOpenAd;
  }
}
