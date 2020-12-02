part of 'compass_cubit.dart';

class CompassState {
  final double north;
  final Position position;
  final List<LatLng> points;
  final int totalDistance;

  CompassState({this.north, this.position, this.points = const [], this.totalDistance = 0});

  CompassState copyWith({double north, List<LatLng> points, Position position, int totalDistance}) {
    return CompassState(
        north: north ?? this.north,
        position: position ?? this.position,
        points: points ?? this.points,
        totalDistance: totalDistance ?? this.totalDistance);
  }
}
