import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart'; // Import the correct package for VoidCallback
import 'package:get/get.dart';
import 'package:madlyvpn/controllers/nativeadcontroller.dart';
import 'package:madlyvpn/helpers/messages.dart';
class AdHelper {
  static Future<void> initAds() async {
    await MobileAds.instance.initialize();
  }

  static void showInterstitialAd({required VoidCallback onComplete}) {
    MyMessages.progress();
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3084693527380725/7440325873',
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
        adUnitId: 'ca-app-pub-3084693527380725/2449436220',
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            log('$NativeAd loaded.');
            adController.adLoaded.value=true;
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
            templateType: TemplateType.small,))
      ..load();
  }
  static AppOpenAd? loadAppOpen() {
    AppOpenAd? appOpenAd;
    AppOpenAd.load(
      adUnitId: 'ca-app-pub-3084693527380725/7735522110',
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
