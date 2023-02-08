import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleplaceapidemo/framework/provider/google_maps/google_maps_controller.dart';
import 'package:googleplaceapidemo/framework/provider/google_maps/proivder.dart';

class MapTypeBottomSheet extends StatelessWidget {
  const MapTypeBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final googleMapsWatch = ref.watch(googleMapsProvider);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Map Type",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withOpacity(1),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      CupertinoIcons.clear,
                    ),
                  )
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: mapWidget(googleMapsWatch),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  mapWidget(GoogleMapsController googleMapsWatch) {
    return List<Widget>.generate(
      googleMapsWatch.mapTypeList.length,
      (int index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                googleMapsWatch.setMapType(
                  googleMapsWatch.mapTypeList[index]["title"].toString(),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: googleMapsWatch.selectedMapType ==
                              googleMapsWatch.mapTypeList[index]["title"]
                          ? Colors.blue
                          : Colors.black,
                      width: googleMapsWatch.selectedMapType ==
                              googleMapsWatch.mapTypeList[index]["title"]
                          ? 3
                          : 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      "assets/images/${googleMapsWatch.mapTypeList[index]["icon"]}",
                      height: 60,
                      width: 60,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              googleMapsWatch.mapTypeList[index]["title"].toString(),
            )
          ],
        );
      },
    );
  }
}
