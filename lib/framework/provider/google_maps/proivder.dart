import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleplaceapidemo/framework/provider/google_maps/bottom_sheet_controller.dart';
import 'package:googleplaceapidemo/framework/provider/google_maps/google_maps_controller.dart';
import 'package:googleplaceapidemo/framework/provider/google_maps/polyline_controller.dart';

final googleMapsProvider = ChangeNotifierProvider(
  (ref) => GoogleMapsController(),
);

///
final polylineProvider = ChangeNotifierProvider(
  (ref) => PolylineController(),
);

///
final bottomSheetProvider = ChangeNotifierProvider(
  (ref) => BottomSheetController(),
);
