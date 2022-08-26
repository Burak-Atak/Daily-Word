import 'package:firebase_database/firebase_database.dart';
import 'package:first_project/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_update/in_app_update.dart';
import '../ad_helper.dart';
import '../register.dart';
import 'flipCardWidget.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    database = FirebaseDatabase.instance;
    userName = prefs.getString("userName");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (userName == null) {
        await _registerScreen();
      }

      if (!kDebugMode) {
        try {
          AppUpdateInfo isThereUpdate = await InAppUpdate.checkForUpdate();
          if (isThereUpdate.updateAvailability ==
              UpdateAvailability.updateAvailable) {
            InAppUpdate.performImmediateUpdate();
          }
        } catch (e) {}
      }

      BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: AdRequest(),
        size: AdSize(width: (width * 100).round(), height: (height * 9).round()),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              _bannerAd = ad as BannerAd;
            });
          },
          onAdFailedToLoad: (ad, err) {
            ad.dispose();
          },
        ),
      ).load();
    });


  }

  BannerAd? _bannerAd;

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Image(
                      image: AssetImage('assets/images/bgForHomeScreen.png'),
                      alignment: Alignment.center,
                      fit: BoxFit.fill,
                    ),
                  ),
                  if (userName != null)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlipCardWidget(),
                        ],
                      ),
                    ),
                  if (_bannerAd != null)
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: _bannerAd!.size.width.toDouble(),
                          height: _bannerAd!.size.height.toDouble(),
                          child: AdWidget(ad: _bannerAd!),
                        ),
                      ),
                    ),
                ],
              )
            );
  }

  Future<void> _registerScreen() async {
    await showDialog(
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        context: context,
        builder: (context) => AddPlayer());
    return;
  }

}
