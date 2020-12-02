import 'package:flutter/material.dart';
import 'package:maps_app/marker_info.dart';

class TargetListTile extends StatelessWidget {
  final MarkerInfo markerInfo;
  final Function(MarkerInfo) iconOnTap;

  const TargetListTile({@required this.markerInfo, this.iconOnTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: ValueKey(markerInfo),
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: markerInfo.isDone
                  ? Color(0xFF99FF99)
                  : Color(0xFFFFFFFF)),
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),
        ),
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.place,
                  size: 40,
                  color: Colors.white,
                ),
                Text(
                  markerInfo.marker.infoWindow.title
                      .length > 8
                      ? "${markerInfo.marker.infoWindow
                      .title.substring(0, 8)}..."
                      : "${markerInfo.marker.infoWindow
                      .title}",
                  style: TextStyle(
                      fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            Row(
              children: [
                Stack(children: [
                  Positioned(
                    bottom: 15,
                    left: -4,
                    child: Icon(
                      Icons.place,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  Icon(
                    Icons.timeline,
                    size: 40,
                    color: Colors.white,
                  ),
                  Positioned(
                    bottom: 19,
                    left: 16,
                    child: Icon(
                      Icons.place,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ]),
                Text(
                  markerInfo.isDone
                      ? " DONE"
                      : markerInfo.currentDistance > 1000
                      ? " ${markerInfo.currentDistance /
                      1000} km"
                      : " ${markerInfo
                      .currentDistance} m",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            InkWell(
              child: Icon(
                markerInfo.isDone ? Icons.undo : Icons
                    .done,
                size: 40,
                color: Colors.white,
              ),
              onTap: () {
                if(iconOnTap != null){
                  iconOnTap(markerInfo);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
