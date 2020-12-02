import 'package:flutter/material.dart';
import 'package:maps_app/main.dart';
import 'package:maps_app/map/cubit/map_cubit.dart';


class MapTypeFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Colors.black,
        heroTag: "map_bttn",
        child: const Icon(Icons.layers_rounded),
        onPressed: () {
          getIt<MapCubit>().changeMapType();
        });
  }
}
