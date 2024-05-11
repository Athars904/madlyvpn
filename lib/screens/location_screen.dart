import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:madlyvpn/controllers/location_controller.dart';
import 'package:get/get.dart';
import 'package:madlyvpn/controllers/nativeadcontroller.dart';
import 'package:madlyvpn/helpers/adhelper.dart';
import 'package:madlyvpn/widgets/vpncard.dart';

late Size mq;

class LocationScreen extends StatelessWidget {
  LocationScreen({super.key});

  final _controller = LocationController();
  final _adController=NativeAdController();

  @override
  Widget build(BuildContext context) {
    if (_controller.vpnList.isEmpty) _controller.getVPNData();
    mq = MediaQuery.of(context).size;
    _adController.ad=AdHelper.loadNativeAd(_adController);
    return Obx(() => Scaffold(
      bottomNavigationBar:
          _adController.ad!=null&& _adController.adLoaded.isTrue?
      SafeArea(child: SizedBox(height: 80,child: AdWidget(ad: _adController.ad!),)):null,
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _controller.getVPNData(),
        child: const Icon(Icons.refresh),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            image: DecorationImage(
              image: AssetImage('assets/images/dark.jpg'),
              fit: BoxFit.cover,
            )),
        child: Container(
          child: _controller.isLoading.value
              ? _loadingWidget()
              : _controller.vpnList.isEmpty
              ? _noVPNFound()
              : _vpnData(),
        ),
      ),
    ));
  }

  _vpnData() => ListView.builder(
    itemCount: _controller.vpnList.length,
    padding: EdgeInsets.only(
      top: mq.height * .02,
      bottom: mq.height * .1,
      left: mq.width * .04,
      right: mq.width * .04,
    ),
    physics: const BouncingScrollPhysics(),
    itemBuilder: (context, index) =>
        VpnCard(vpn: _controller.vpnList[index]),
  );

  _loadingWidget() => SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              'assets/lottie/lottieanim.json',
              width: 250,
              height: 250,
            ),
            const Text(
              'Getting the best servers for you',
              style: TextStyle(fontSize: 24, color: Colors.white70),
            )
          ],
        ),
      ),
    ),
  );

  _noVPNFound() => const Center(
    child: Text(
      'No VPN Servers Found',
      style: TextStyle(
          color: Colors.black54,
          fontSize: 28,
          fontWeight: FontWeight.bold),
    ),
  );
}
