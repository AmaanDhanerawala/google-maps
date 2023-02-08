import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleplaceapidemo/framework/provider/google_maps/proivder.dart';

class BottomSheetForSelection extends ConsumerStatefulWidget {
  const BottomSheetForSelection({Key? key}) : super(key: key);

  @override
  ConsumerState<BottomSheetForSelection> createState() =>
      _BottomSheetForSelectionState();
}

class _BottomSheetForSelectionState
    extends ConsumerState<BottomSheetForSelection>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    final googleMapsWatch = ref.watch(googleMapsProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Show Marker",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
                Switch(
                  value: googleMapsWatch.isShowMarker,
                  onChanged: (bool? value) {
                    googleMapsWatch.updateMarkerShow(value!);
                  },
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Show Trail",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
                Switch(
                  value: googleMapsWatch.isShowTrail,
                  onChanged: (bool? value) {
                    googleMapsWatch.updateTrailShow(value!);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
