import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/common/common.dart';
import 'package:maps_app/compass/compass_page.dart';
import 'package:maps_app/main.dart';
import 'package:maps_app/map/add_marker_fab.dart';
import 'package:maps_app/map/cubit/map_cubit.dart';

class MapPageForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = getIt<MapCubit>().state;
    state.initialCameraPosition ?? getIt<MapCubit>().setupCameraPosition();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: state.initialCameraPosition != null
          ? Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GoogleMap(
                        zoomControlsEnabled: false,
                        compassEnabled: true,
                        mapToolbarEnabled: false,
                        markers: state.markers.map((m) => m.marker).toSet(),
                        initialCameraPosition: CameraPosition(
                            target: state.initialCameraPosition, zoom: 11),
                        mapType: state.mapType,
                        onCameraMove: getIt<MapCubit>().onCameraMove,
                        onMapCreated: getIt<MapCubit>().onCameraCreated,
                        myLocationEnabled: true,
                      ),
                      Icon(Icons.add),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AddMarkerFab(),
                            const SizedBox(height: 12),
                            MapTypeFab(),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10,
                        child: AddressSearch(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TargetsList(),
                ),
                MyTextButton(
                  onTap: () {
                    Navigator.of(context)?.pushReplacement(
                        MaterialPageRoute(builder: (_) => CompassPage()));
                  },
                  text: "START",
                  isActive: state.markers.isNotEmpty,
                ),
              ],
            )
          : LoadingIndicator(),
    );
  }
}

class AddressSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(200),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          maxLines: 1,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            border: UnderlineInputBorder(),
            hintText: "Find location",
            hintStyle: TextStyle(color: Colors.white70),
            suffixIcon: Icon(Icons.search, color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
          onSubmitted: (text) {
            getIt<MapCubit>().moveCameraToLocation(text);
          },
        ),
      ),
    );
  }
}
