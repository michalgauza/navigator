part of 'map_cubit.dart';

class MapState  {
  final MapType mapType;
  final List<MarkerInfo> markers;
  final LatLng initialCameraPosition;
  final String error;

  MapState(
      {this.mapType = MapType.normal,
      this.markers = const [],
      this.initialCameraPosition,
      this.error});

  MapState copyWith(
      {MapType mapType, List<MarkerInfo> markers, LatLng initialCameraPosition, String error}) {
    return MapState(
        mapType: mapType ?? this.mapType,
        markers: markers ?? this.markers,
        initialCameraPosition: initialCameraPosition ?? this.initialCameraPosition,
        error: error);
  }
}
