import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:maps_app/marker_info.dart';

part 'map_state.dart';

class MapCubit extends HydratedCubit<MapState> {
  MapCubit() : super(MapState());

  final List<MapType> _mapTypes = [
    MapType.normal,
    MapType.hybrid,
    MapType.satellite,
    MapType.terrain
  ];

  GoogleMapController _controller;

  int _mapTypeIndex = 0;

  Position _initialPos;

  Position get initialPos => _initialPos;

  LatLng _cameraPos;

  String _lastLocationName;

  String get lastLocationName => _lastLocationName;

  void startNewTravel() {
    emit(MapState());
  }

  Future<void> setupCameraPosition() async {
    try {
      _initialPos ??= await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final List<Placemark> placemarks = await placemarkFromCoordinates(
          _initialPos.latitude, _initialPos.longitude);
      _lastLocationName = placemarkToStringInfo(placemarks.first);
      _cameraPos ??= LatLng(_initialPos?.latitude, _initialPos?.longitude);
      emit(state.copyWith(initialCameraPosition: _cameraPos));
    } catch (error){
      print('$error');
      emit(state.copyWith(error: "This app need to know your location"));
    }
  }

  void onCameraMove(CameraPosition position) {
    _cameraPos = position.target;
  }

  void changeMapType() {
    _mapTypeIndex < _mapTypes.length - 1 ? _mapTypeIndex++ : _mapTypeIndex = 0;
    emit(state.copyWith(mapType: _mapTypes[_mapTypeIndex]));
  }

  void addMarker(String name) async {
    final Marker newMarker = Marker(
      markerId: MarkerId(_cameraPos.toString()),
      position: _cameraPos,
      infoWindow: InfoWindow(title: name),
      icon: BitmapDescriptor.defaultMarker,
    );
    _initialPos ??= await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    int distance = Geolocator.distanceBetween(
            _initialPos?.latitude,
            _initialPos?.longitude,
            newMarker.position.latitude,
            newMarker.position.longitude)
        .toInt();
    final markers = state.markers.toList();
    markers.add(MarkerInfo(distance, distance, newMarker));
    emit(state.copyWith(markers: markers));
  }

  void swapMarkers(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final tmp = state.markers.elementAt(oldIndex);
    final markers = state.markers.toList()
      ..removeAt(oldIndex)
      ..insert(newIndex, tmp);
    emit(state.copyWith(markers: markers));
  }

  void removeMarker(MarkerInfo markerInfo) {
    final markers = state.markers.toList()..remove(markerInfo);
    emit(state.copyWith(markers: markers));
  }

  void setToDoneOrNot(MarkerInfo marker) {
    final markers = state.markers.toList();
    markers.remove(marker);
    if (marker.isDone) {
      marker.isDone = false;
      markers.insert(0, marker);
    } else {
      marker.isDone = true;
      markers.add(marker);
    }
    emit(state.copyWith(markers: markers));
  }

  void updateMarkers(Position pos) {
    final markers = state.markers.toList();
    markers.forEach((markerInfo) {
      markerInfo.bearing = Geolocator.bearingBetween(
          pos?.latitude,
          pos?.longitude,
          markerInfo.marker.position.latitude,
          markerInfo.marker.position.longitude);
      markerInfo.currentDistance = Geolocator.distanceBetween(
              pos?.latitude,
              pos?.longitude,
              markerInfo.marker.position.latitude,
              markerInfo.marker.position.longitude)
          .toInt();
      if (markerInfo.currentDistance < 10) {
        markerInfo.isDone = true;
        markers.remove(markerInfo);
        markers.add(markerInfo);
      }
    });
    emit(state.copyWith(markers: markers));
  }

  @override
  MapState fromJson(Map<String, dynamic> json) {
    print('load state');
    try {
      List<MarkerInfo> markers = [];
      (jsonDecode(json["markers"]) as List)
          .forEach((value) => markers.add(MarkerInfo.fromJson(value)));
      return MapState(markers: markers);
    } catch (error) {
      print('$error');
      return MapState();
    }
  }

  @override
  Map<String, dynamic> toJson(MapState state) {
    final json = jsonEncode(state.markers.map((e) => e.toJson()).toList());
    return {
      "markers": json,
    };
  }

  void moveCameraToLocation(String location) async {
    try {
      List<Location> locations = await locationFromAddress(location);
      _controller.moveCamera(CameraUpdate.newLatLng(
          LatLng(locations.first.latitude, locations.first.longitude)));
    } catch (error){
      emit(state.copyWith(error: "Can't find location"));
      print('$error');
    }
  }

  void onCameraCreated(GoogleMapController controller) {
    _controller = controller;
  }

  String placemarkToStringInfo(Placemark placemark){
    return "${placemark.locality} ${placemark.subLocality} ${placemark.street}";
  }
}
