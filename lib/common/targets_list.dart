import 'package:flutter/material.dart';
import 'package:maps_app/main.dart';
import 'package:maps_app/common/target_list_tile.dart';
import 'package:maps_app/map/cubit/map_cubit.dart';

class TargetsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = getIt<MapCubit>().state;
    return state.markers.isNotEmpty
        ? Theme(
            data: ThemeData(canvasColor: Colors.blueGrey),
            child: ReorderableListView(
              onReorder: getIt<MapCubit>().swapMarkers,
              children: state.markers
                  .map(
                    (markerInfo) => Dismissible(
                      key: ValueKey(markerInfo),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.delete,
                              size: 40,
                            ),
                            Icon(
                              Icons.delete,
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                      onDismissed: (interaction) {
                        getIt<MapCubit>().removeMarker(markerInfo);
                      },
                      child: TargetListTile(
                        markerInfo: markerInfo,
                        iconOnTap: getIt<MapCubit>().setToDoneOrNot,
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
        : Center(
            child: Text(
              "No targets",
              style: TextStyle(color: Colors.white),
            ),
          );
  }
}
