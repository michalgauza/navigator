import 'dart:async';
import 'dart:convert';

import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'compass_state.dart';

class CompassCubit extends HydratedCubit<CompassState> {
  CompassCubit() : super(CompassState());

  StreamSubscription<Position> _positionSub;
  StreamSubscription<double> _compassSub;

  Position _pos;

  Future<void> setupCompass() async {
    _pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    emit(state.copyWith(
      position: _pos,
    ));
    _positionSub = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.high,
      distanceFilter: 1,
    ).listen((p) {
      _pos = p;
      emit(state.copyWith(
        position: _pos,
      ));
    });
    _compassSub = FlutterCompass.events.listen((n) async {
      double north = n;
      emit(state.copyWith(
        north: north,
      ));
    });
    Timer.periodic(Duration(minutes: 5), (_) {
      List<LatLng> points = state.points.toList();
      points.add(LatLng(
        _pos?.latitude,
        _pos?.longitude,
      ));
      emit(state.copyWith(points: points));
    });
  }

  Polyline get polyLine =>
      Polyline(polylineId: PolylineId("polylineId"), points: state.points);

  int getTotalDistance() {
    double distance = 0;
    final points = state.points;
    for (int i = 0; i < points.length - 1; i++) {
      distance += Geolocator.distanceBetween(points[i].latitude,
          points[i].longitude, points[i + 1].latitude, points[i + 1].longitude);
    }
    return distance.toInt();
  }

  void cancelSubs() {
    _positionSub?.cancel();
    _compassSub?.cancel();
  }

  @override
  CompassState fromJson(Map<String, dynamic> json) {
    print('$json');
    try {
      List<LatLng> points = [];
      (jsonDecode(json["points"]) as List).forEach((value) => points.add(LatLng(
            value["lat"],
            value["lng"],
          )));
      return CompassState(points: points);
    } catch (error) {
      print('$error');
      return CompassState();
    }
  }

  @override
  Map<String, dynamic> toJson(CompassState state) {
    final json = jsonEncode(state.points
        .map((e) => {"lat": e.latitude, "lng": e.longitude})
        .toList());
    return {"points": json};
  }

  void startNewTravel() {
    emit(CompassState());
  }
}
