import 'package:flutter/material.dart';
import 'package:maps_app/compass/cubit/compass_cubit.dart';
import 'package:maps_app/compass/targets_icons.dart';
import 'package:maps_app/finish/finish_page.dart';
import 'package:maps_app/main.dart';
import 'package:maps_app/common/my_text_button.dart';
import 'package:maps_app/common/targets_list.dart';
import 'dart:math' as math;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_app/map/cubit/map_cubit.dart';

class CompassForm extends StatelessWidget {
  final double scale = 1;

  @override
  Widget build(BuildContext context) {
    final state = getIt<CompassCubit>().state;
    state.north ?? getIt<CompassCubit>().setupCompass();
    return BlocBuilder<CompassCubit, CompassState>(
        cubit: getIt<CompassCubit>(),
        buildWhen: (previous, current) => previous.north == null,
        builder: (BuildContext context, CompassState state) {
          return state.north != null
              ? Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      child: BlocBuilder<MapCubit, MapState>(
                          cubit: getIt<MapCubit>(),
                          buildWhen: (previous, current) {
                            if (current.markers.isNotEmpty) {
                              return previous.markers.first.marker.markerId !=
                                  current.markers.first.marker.markerId;
                            } else {
                              return true;
                            }
                          },
                          builder: (BuildContext context, MapState state) {
                            return state.markers.isNotEmpty
                                ? BlocBuilder<CompassCubit, CompassState>(
                                    cubit: getIt<CompassCubit>(),
                                    builder: (BuildContext context,
                                        CompassState state) {
                                      getIt<MapCubit>()
                                          .updateMarkers(state.position);
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Transform.rotate(
                                            angle: state.north != null &&
                                                    getIt<MapCubit>()
                                                            .state
                                                            .markers
                                                            .first
                                                            .bearing !=
                                                        null
                                                ? ((state.north -
                                                        getIt<MapCubit>()
                                                            .state
                                                            .markers
                                                            .first
                                                            .bearing) *
                                                    (math.pi / 180) *
                                                    -1)
                                                : 0,
                                            child: Icon(Icons.north,
                                                size: 200 * scale,
                                                color: Colors.white),
                                          ),
                                          TargetsIcons(
                                            direction: state.north,
                                            scale: scale,
                                          ),
                                          Transform.translate(
                                            offset: Offset(0, -110 * scale),
                                            child: Transform.rotate(
                                              origin: Offset(0, 110 * scale),
                                              angle: state.north != null
                                                  ? (state.north *
                                                      (math.pi / 180) *
                                                      -1)
                                                  : 0,
                                              child: Transform.rotate(
                                                angle: state.north != null
                                                    ? (state.north *
                                                        (math.pi / 180))
                                                    : 0,
                                                child: Text(
                                                  "N",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    })
                                : Center(
                                    child: Text(
                                      "No targets",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                          }),
                    ),
                    Expanded(
                      child: BlocBuilder<MapCubit, MapState>(
                          cubit: getIt<MapCubit>(),
                          builder: (BuildContext context, MapState state) {
                            return TargetsList();
                          }),
                    ),
                    const SizedBox(height: 8),
                    MyTextButton(
                      onTap: () {
                        if (getIt<MapCubit>()
                            .state
                            .markers
                            .any((element) => !element.isDone)) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text("There are still some targets"),
                              content: Text("Are you sure you want to finish?"),
                              actions: [
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                      ..pop()
                                      ..pushReplacement(MaterialPageRoute(
                                          builder: (_) => FinishPage()));
                                  },
                                  child: Text("Yes"),
                                ),
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context)?.pop();
                                  },
                                  child: Text("No"),
                                ),
                              ],
                            ),
                          );
                        } else {
                          Navigator.of(context)?.pushReplacement(
                              MaterialPageRoute(builder: (_) => FinishPage()));
                        }
                      },
                      text: "FINISH",
                      iconData: Icons.done,
                    )
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Loading...",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      CircularProgressIndicator()
                    ],
                  ),
                );
        });
  }
}
