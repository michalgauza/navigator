import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:maps_app/common/common.dart';
import 'package:maps_app/main.dart';
import 'package:maps_app/map/cubit/map_cubit.dart';
import 'dart:math' as math;

import 'package:maps_app/map/map_page.dart';

class HomePage extends StatelessWidget {
  BannerAd createBannerAd() {
    return BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-2007717172579041/4388043825",
      targetingInfo: MobileAdTargetingInfo(testDevices: ["2138D9D62C2EF37AA72E98CC0BC93FA5"],
        keywords: ["travel"],
        nonPersonalizedAds: false,
      ),
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    createBannerAd()..load()..show();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ArrowWidget(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyTextButton(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => MapPage(
                                  newTravel: true,
                                )));
                      },
                      text: "NEW TRAVEL"),
                  MyTextButton(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => MapPage()));
                    },
                    text: "CONTINUE",
                    isActive: getIt<MapCubit>().state.markers.isNotEmpty,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArrowWidget extends StatefulWidget {
  @override
  _ArrowWidgetState createState() => _ArrowWidgetState();
}

class _ArrowWidgetState extends State<ArrowWidget> {
  StreamSubscription<double> _compassSub;
  double _north = 0;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _north * (math.pi / 180) * -1,
      child: Icon(
        Icons.north,
        color: Colors.white,
        size: 400,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _compassSub = FlutterCompass.events.listen((n) async {
      setState(() {
        _north = n;
      });
    });
  }

  @override
  void dispose() {
    _compassSub.cancel();
    super.dispose();
  }
}
