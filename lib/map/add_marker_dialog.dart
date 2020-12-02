import 'package:flutter/material.dart';
import 'package:maps_app/main.dart';
import 'package:maps_app/map/cubit/map_cubit.dart';

class AddMarkerDialog extends StatefulWidget {
  @override
  _AddMarkerDialogState createState() => _AddMarkerDialogState();
}

class _AddMarkerDialogState extends State<AddMarkerDialog> {
  String markerName = "";
  String errorMessage = "Invalid value";
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(16),
            alignment: Alignment.topLeft,
            child: Text(
              "Add marker",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: TextField(
              decoration: InputDecoration(
                  errorText: isError ? errorMessage : null,
                  hintText: "marker name"),
              onChanged: (text) {
                markerName = text;
                setState(() {
                  isError = false;
                });
              },
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8, right: 8),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("CANCEL"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: MaterialButton(
                  onPressed: () {
                    if (markerName.trim().isNotEmpty) {
                      getIt<MapCubit>().addMarker(markerName);
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        isError = true;
                      });
                    }
                  },
                  child: Text("OK"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}