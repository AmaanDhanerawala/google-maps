import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineController extends ChangeNotifier {
  Set<Polyline> polylineList = {};
  int polylineId = 0;

  setPolyline(List<PointLatLng> points) {
    print("Total Polyline: ${points.length}");
    final String polylineIdVal = 'polyline_$polylineId';
    polylineId++;
    polylineList.add(
      Polyline(
        polylineId: PolylineId(polylineIdVal),
        points: points
            .map(
              (e) => LatLng(e.latitude, e.longitude),
            )
            .toList(),
        width: 2,
        color: Colors.blue,
      ),
    );
    notifyListeners();
  }
}
