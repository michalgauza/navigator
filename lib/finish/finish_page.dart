import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/compass/cubit/compass_cubit.dart';
import 'package:maps_app/main.dart';
import 'package:maps_app/common/map_type_fab.dart';
import 'package:maps_app/common/my_text_button.dart';
import 'package:maps_app/common/target_list_tile.dart';
import 'package:maps_app/map/cubit/map_cubit.dart';
import 'package:maps_app/map/map_page.dart';

class FinishPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getIt<CompassCubit>().cancelSubs();
    print('FinishPage build');
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    BlocBuilder<MapCubit, MapState>(
                      cubit: getIt<MapCubit>(),
                      buildWhen: (previous, current) =>
                          previous.mapType != current.mapType,
                      builder: (context, state) {
                        return GoogleMap(
                          polylines: {getIt<CompassCubit>().polyLine},
                          zoomControlsEnabled: false,
                          compassEnabled: true,
                          mapToolbarEnabled: false,
                          markers: state.markers.map((m) => m.marker).toSet(),
                          initialCameraPosition: CameraPosition(
                              target: state.markers.last.marker.position,
                              zoom: 11),
                          mapType: state.mapType,
                          onCameraMove: getIt<MapCubit>().onCameraMove,
                          myLocationEnabled: true,
                        );
                      },
                    ),
                    Positioned(
                      bottom: 5,
                      child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: Colors.black,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "TOTAL DISTANCE: ${getIt<CompassCubit>().state.totalDistance / 1000} km",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: MapTypeFab(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: getIt<MapCubit>().state.markers.length,
                    itemBuilder: (context, index) {
                      return TargetListTile(
                          markerInfo: getIt<MapCubit>().state.markers[index]);
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyTextButton(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => MapPage(newTravel: true)));
                      },
                      text: "NEW TRAVEL"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
