import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/compass/cubit/compass_cubit.dart';
import 'package:maps_app/main.dart';
import 'package:maps_app/map/cubit/map_cubit.dart';
import 'package:maps_app/map/map_form.dart';

class MapPage extends StatelessWidget {
  final newTravel;

  const MapPage({this.newTravel = false});

  @override
  Widget build(BuildContext context) {
    if (newTravel) {
      getIt<MapCubit>().startNewTravel();
      getIt<CompassCubit>().startNewTravel();
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocConsumer<MapCubit, MapState>(
          listenWhen: (current, previous) => previous.error != null,
          listener: (context, state){
            Scaffold.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(state.error != null ? state.error : "")));
          },
          cubit: getIt<MapCubit>(),
          builder: (BuildContext context, MapState state) {
            return MapPageForm();
          },
        ),
      ),
    );
  }
}