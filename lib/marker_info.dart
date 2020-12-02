import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerInfo {
  final int initialDistance;
  int currentDistance;
  double bearing;
  bool isDone = false;
  final Marker marker;


  MarkerInfo(this.initialDistance, this.currentDistance,
       this.marker);

  factory MarkerInfo.fromJson(Map<String, dynamic> json){
    return MarkerInfo(
        json["initialDistance"],
        json["currentDistance"],
        Marker(
            markerId: MarkerId(json["marker"]["markerId"]),
            position: LatLng((json["marker"]["position"] as List).first,
                (json["marker"]["position"] as List).last),
            infoWindow: InfoWindow(title: json["marker"]["infoWindow"]["title"])));
  }

  Map<String, dynamic> toJson() {
    return {
      "initialDistance": initialDistance,
      "currentDistance": currentDistance,
      "marker": marker.toJson(),
    };
  }
}
