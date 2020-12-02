import 'package:flutter/material.dart';
import 'package:maps_app/map/add_marker_dialog.dart';

class AddMarkerFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Colors.black,
        heroTag: "marker_bttn",
        child: const Icon(Icons.add_location_alt),
        onPressed: () {
          showMarkerDialog(context);
        });
  }
}

void showMarkerDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => Dialog(child: AddMarkerDialog()),
  );
}
