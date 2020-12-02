import 'package:flutter/material.dart';
import 'package:maps_app/compass/compass_form.dart';
import 'package:maps_app/map/map_page.dart';

class CompassPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('CompassPage build');
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: WillPopScope(
          onWillPop: () {
            Navigator.of(context)
                ?.pushReplacement(MaterialPageRoute(builder: (_) => MapPage()));
            return Future.value(false);
          },
          child: CompassForm(),
        ),
      ),
    );
  }
}
