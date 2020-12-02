import 'package:flutter/material.dart';
import 'package:maps_app/main.dart';
import 'package:maps_app/map/cubit/map_cubit.dart';
import 'dart:math' as math;

class TargetsIcons extends StatelessWidget {
  final double direction;
  final double scale;

  const TargetsIcons({@required this.direction, this.scale = 1})
      : assert(direction != null);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: getIt<MapCubit>().state.markers.reversed.map(
        (markerInfo) {
          Color color;
          getIt<MapCubit>().state.markers.first == markerInfo
              ? color = Colors.white
              : markerInfo.isDone
                  ? color = Color(0x3399FF99)
                  : color = Color(0x33FFFFFF);
          return Transform.translate(
            offset: Offset(0, -140 * scale),
            child: Transform.rotate(
              origin: Offset(0, 140 * scale),
              angle: direction != null && markerInfo.bearing != null
                  ? ((direction - markerInfo.bearing) * (math.pi / 180) * -1)
                  : 0,
              child: Transform.rotate(
                angle: direction != null && markerInfo.bearing != null
                    ? ((direction - markerInfo.bearing) * (math.pi / 180))
                    : 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${markerInfo.marker.infoWindow.title}",
                      style: TextStyle(
                        fontSize: 18,
                        color: color,
                      ),
                    ),
                    Icon(
                      Icons.place,
                      color: color,
                      size: 40,
                    ),
                    Text(
                      markerInfo.currentDistance > 1000
                          ? "${markerInfo.currentDistance.toDouble() / 1000} km"
                          : "${markerInfo.currentDistance} m",
                      style: TextStyle(
                        fontSize: 18,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
