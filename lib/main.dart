import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:madlyvpn/helpers/adhelper.dart';
import 'package:madlyvpn/screens/splash_screen.dart';
import 'package:get/get.dart';
import 'package:madlyvpn/helpers/pref.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:madlyvpn/helpers/remoteconfig.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  await Firebase.initializeApp();
  await Config.initConfig();
  await Pref.initializeHive();
  await AdHelper.initAds();
  await AdHelper.loadAppOpen();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value){
    runApp(const MyApp());
  });

}

// Future<void> _showAppOpenAdAfterDelay(BuildContext context) async {
//   // Delay opening the ad by a few seconds
//   await Future.delayed(const Duration(seconds: 3)); // Adjust the delay time as needed
//
//   // Show the app open ad
//   AdHelper.loadAppOpen();
//
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OpenVpn Demo',
      home: SplashScreen(),
    );
  }
}
