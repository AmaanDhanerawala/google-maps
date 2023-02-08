// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:googleplaceapidemo/framework/provider/google_maps/proivder.dart';
//
// class MapTypeBottomSheet extends ConsumerStatefulWidget {
//   const MapTypeBottomSheet({Key? key}) : super(key: key);
//
//   @override
//   ConsumerState<MapTypeBottomSheet> createState() =>
//       _BottomSheetForSelectionState();
// }
//
// class _BottomSheetForSelectionState extends ConsumerState<MapTypeBottomSheet>
//     with SingleTickerProviderStateMixin {
//   @override
//   Widget build(BuildContext context) {
//     final googleMapsWatch = ref.watch(googleMapsProvider);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: [
//                 const Expanded(
//                   child: Text(
//                     "Normal",
//                     style: TextStyle(
//                       fontSize: 22,
//                     ),
//                   ),
//                 ),
//                 Radio(
//                   value: MapType.normal,
//                   groupValue: googleMapsWatch.mapType,
//                   onChanged: (value) {
//                     googleMapsWatch.updateMapType(MapType.normal);
//                   },
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                   child: Text(
//                     "Hybrid",
//                     style: TextStyle(
//                       fontSize: 22,
//                     ),
//                   ),
//                 ),
//                 Radio(
//                   value: MapType.hybrid,
//                   groupValue: googleMapsWatch.mapType,
//                   onChanged: (value) {
//                     googleMapsWatch.updateMapType(MapType.hybrid);
//                   },
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 const Expanded(
//                   child: Text(
//                     "Satellite",
//                     style: TextStyle(
//                       fontSize: 22,
//                     ),
//                   ),
//                 ),
//                 Radio(
//                   value: MapType.satellite,
//                   groupValue: googleMapsWatch.mapType,
//                   onChanged: (value) {
//                     googleMapsWatch.updateMapType(MapType.satellite);
//                   },
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
