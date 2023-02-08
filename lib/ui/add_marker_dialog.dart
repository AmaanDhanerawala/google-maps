import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googleplaceapidemo/framework/provider/google_maps/proivder.dart';

class AddMarkerSheet extends StatelessWidget {
  const AddMarkerSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final googleMapsWatch = ref.watch(googleMapsProvider);
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  decoration: const InputDecoration(hintText: "Marker Id"),
                  controller: googleMapsWatch.markerIdCtr,
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Title"),
                  controller: googleMapsWatch.titleCtr,
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Latitude"),
                  controller: googleMapsWatch.latitudeCtr,
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Longitude"),
                  controller: googleMapsWatch.longitudeCtr,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("CANCEL"),
                    ),
                    TextButton(
                      onPressed: () {
                        googleMapsWatch.addMarker(
                          googleMapsWatch.markerIdCtr.text,
                          googleMapsWatch.titleCtr.text,
                          LatLng(
                            double.parse(googleMapsWatch.latitudeCtr.text),
                            double.parse(googleMapsWatch.longitudeCtr.text),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: Text("ADD"),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
