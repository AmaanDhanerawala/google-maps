import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googleplaceapidemo/framework/provider/google_maps/google_maps_controller.dart';
import 'package:googleplaceapidemo/framework/provider/google_maps/proivder.dart';
import 'package:googleplaceapidemo/ui/progress_bar.dart';
import 'package:googleplaceapidemo/ui/utils/const.dart';
import 'package:googleplaceapidemo/ui/utils/map_type_bottom_sheet.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapSample(),
    );
  }
}

class MapSample extends ConsumerStatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  ConsumerState<MapSample> createState() => MapSampleState();
}

class MapSampleState extends ConsumerState<MapSample>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: animationController);
    animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final googleMapsWatch = ref.watch(googleMapsProvider);
      googleMapsWatch.clearProvider();
      await googleMapsWatch.getCurrentPosition(context);
      await googleMapsWatch.updateCameraPosition(
        LatLng(googleMapsWatch.position!.latitude,
            googleMapsWatch.position!.longitude),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final googleMapsWatch = ref.watch(googleMapsProvider);
    final polylineWatch = ref.watch(polylineProvider);
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
      },
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: googleMapsWatch.mapType,
              markers: googleMapsWatch.markerList,
              polylines: polylineWatch.polylineList,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                googleMapsWatch.controller.complete(controller);
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(0.0000, 0.0000),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    googleMapsWatch.isDirection
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Card(
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Form(
                                              child: TextFormField(
                                                textCapitalization:
                                                    TextCapitalization.words,
                                                decoration:
                                                    const InputDecoration(
                                                  prefixIcon: Padding(
                                                    padding: EdgeInsets.all(12),
                                                    child: Icon(CupertinoIcons
                                                        .location),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 1,
                                                      color: Colors.transparent,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 1,
                                                      color: Colors.transparent,
                                                    ),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.blue),
                                                  ),
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      width: 1,
                                                      color: Colors.transparent,
                                                    ),
                                                  ),
                                                  hintText: "Origin",
                                                ),
                                                controller: googleMapsWatch
                                                    .originPlaceCtr,
                                                focusNode:
                                                    googleMapsWatch.originFocus,
                                                onChanged: (value) async {
                                                  if (value.length >= 3) {
                                                    EasyDebounce.debounce(
                                                      'tFMemberController',
                                                      const Duration(
                                                        milliseconds: 200,
                                                      ),
                                                      () async {
                                                        EasyDebounce.debounce(
                                                            'loader',
                                                            const Duration(
                                                                seconds: 1),
                                                            () async {
                                                          googleMapsWatch
                                                              .isLoadingUpdate(
                                                                  true);
                                                          await googleMapsWatch
                                                              .getAutoCompleteList(
                                                                  context,
                                                                  googleMapsWatch
                                                                      .originPlaceCtr);
                                                        });
                                                      },
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                if (googleMapsWatch
                                                    .isPlaceAutoComplete) {
                                                  if (googleMapsWatch
                                                          .placeAutoCompleteResponseModel !=
                                                      null) {
                                                    googleMapsWatch
                                                            .placeAutoCompleteResponseModel =
                                                        null;
                                                  }
                                                } else {
                                                  if (googleMapsWatch
                                                          .queryAutoCompleteResponseModel !=
                                                      null) {
                                                    googleMapsWatch
                                                            .queryAutoCompleteResponseModel =
                                                        null;
                                                  }
                                                }

                                                googleMapsWatch
                                                    .originPlaceCtr.text = "";
                                                hideKeyboard(context);
                                              },
                                              icon: const Icon(
                                                  Icons.remove_circle)),
                                        ],
                                      ),
                                      googleMapsWatch.originFocus.hasFocus
                                          ? googleMapsWatch.isPlaceAutoComplete
                                              ? listForPlaceAutoComplete(
                                                  googleMapsWatch)
                                              : listForQueryAutoComplete(
                                                  googleMapsWatch)
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                              googleMapsWatch.isPlaceAutoComplete
                                  ? Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Card(
                                        elevation: 20,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Form(
                                                    child: TextFormField(
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .words,
                                                      decoration:
                                                          const InputDecoration(
                                                        prefixIcon: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12),
                                                          child: Icon(
                                                              CupertinoIcons
                                                                  .location),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            width: 1,
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            width: 1,
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .blue),
                                                        ),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            width: 1,
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                        ),
                                                        hintText: "Destination",
                                                      ),
                                                      controller:
                                                          googleMapsWatch
                                                              .destinationCtr,
                                                      focusNode: googleMapsWatch
                                                          .destinationFocus,
                                                      onChanged: (value) async {
                                                        if (value.length >= 3) {
                                                          EasyDebounce.debounce(
                                                            'tFMemberController',
                                                            const Duration(
                                                              milliseconds: 200,
                                                            ),
                                                            () async {
                                                              EasyDebounce.debounce(
                                                                  'loader',
                                                                  const Duration(
                                                                      seconds:
                                                                          1),
                                                                  () async {
                                                                googleMapsWatch
                                                                    .isLoadingUpdate(
                                                                        true);
                                                                await googleMapsWatch
                                                                    .getAutoCompleteList(
                                                                        context,
                                                                        googleMapsWatch
                                                                            .destinationCtr);
                                                              });
                                                            },
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      if (googleMapsWatch
                                                          .isPlaceAutoComplete) {
                                                        if (googleMapsWatch
                                                                .placeAutoCompleteResponseModel !=
                                                            null) {
                                                          googleMapsWatch
                                                                  .placeAutoCompleteResponseModel =
                                                              null;
                                                        }
                                                      } else {
                                                        if (googleMapsWatch
                                                                .queryAutoCompleteResponseModel !=
                                                            null) {
                                                          googleMapsWatch
                                                                  .queryAutoCompleteResponseModel =
                                                              null;
                                                        }
                                                      }

                                                      googleMapsWatch
                                                          .destinationCtr
                                                          .text = "";
                                                      hideKeyboard(context);
                                                    },
                                                    icon: const Icon(
                                                        Icons.remove_circle)),
                                              ],
                                            ),
                                            googleMapsWatch
                                                    .destinationFocus.hasFocus
                                                ? googleMapsWatch
                                                        .isPlaceAutoComplete
                                                    ? listForPlaceAutoComplete(
                                                        googleMapsWatch)
                                                    : listForQueryAutoComplete(
                                                        googleMapsWatch)
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.all(5),
                            child: Card(
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Form(
                                          child: TextFormField(
                                            textCapitalization:
                                                TextCapitalization.words,
                                            decoration: const InputDecoration(
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.all(12),
                                                child: Icon(
                                                    CupertinoIcons.location),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blue),
                                              ),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                              hintText: "Search by City",
                                            ),
                                            controller:
                                                googleMapsWatch.searchPlaceCtr,
                                            focusNode:
                                                googleMapsWatch.placeFocus,
                                            onChanged: (value) async {
                                              if (value.length >= 3) {
                                                EasyDebounce.debounce(
                                                  'tFMemberController',
                                                  const Duration(
                                                      milliseconds: 1000),
                                                  () async {
                                                    if (value
                                                        .contains("near")) {
                                                      await googleMapsWatch
                                                          .getQueryAutoCompleteList(
                                                              context,
                                                              googleMapsWatch
                                                                  .searchPlaceCtr);
                                                    } else {
                                                      await googleMapsWatch
                                                          .getAutoCompleteList(
                                                              context,
                                                              googleMapsWatch
                                                                  .searchPlaceCtr);
                                                    }
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            if (googleMapsWatch
                                                .isPlaceAutoComplete) {
                                              if (googleMapsWatch
                                                      .placeAutoCompleteResponseModel !=
                                                  null) {
                                                googleMapsWatch
                                                        .placeAutoCompleteResponseModel =
                                                    null;
                                              }
                                            } else {
                                              if (googleMapsWatch
                                                      .queryAutoCompleteResponseModel !=
                                                  null) {
                                                googleMapsWatch
                                                        .queryAutoCompleteResponseModel =
                                                    null;
                                              }
                                            }
                                            googleMapsWatch
                                                .searchPlaceCtr.text = "";
                                            hideKeyboard(context);
                                          },
                                          icon:
                                              const Icon(Icons.remove_circle)),
                                    ],
                                  ),
                                  googleMapsWatch.placeFocus.hasFocus
                                      ? googleMapsWatch.isPlaceAutoComplete
                                          ? listForPlaceAutoComplete(
                                              googleMapsWatch)
                                          : listForQueryAutoComplete(
                                              googleMapsWatch)
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return const MapTypeBottomSheet();
                            },
                          );
                        },
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          color: Colors.white,
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              CupertinoIcons.square_stack_3d_up,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            DialogProgressBar(isLoading: googleMapsWatch.isLoading),
          ],
        ),
        /*floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        //Init Floating Action Bubble
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: FloatingActionBubble(
            items: <Bubble>[
              Bubble(
                title: "Manage Display Widgets",
                iconColor: Colors.white,
                bubbleColor: Colors.blue,
                icon: Icons.settings,
                titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  animationController.reverse();
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return const BottomSheetForSelection();
                    },
                  );
                },
              ),
              Bubble(
                title: "Manage Map Type",
                iconColor: Colors.white,
                bubbleColor: Colors.blue,
                icon: Icons.settings,
                titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  animationController.reverse();
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return const MapTypeBottomSheet();
                    },
                  );
                },
              ),
            ],
            animation: animation,
            onPress: () => animationController.isCompleted
                ? animationController.reverse()
                : animationController.forward(),
            iconColor: Colors.blue,
            iconData: Icons.menu,
            backGroundColor: Colors.white,
          ),
        ),*/
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () async {
                  googleMapsWatch
                      .updateIsDirection(!googleMapsWatch.isDirection);
                },
                child: const Icon(
                  Icons.directions,
                  color: Colors.black,
                ),
              ),
              googleMapsWatch.isDirection
                  ? FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: () async {
                        if (googleMapsWatch.checkIfDirectionValid()) {
                          hideKeyboard(context);
                          await googleMapsWatch.getDirection(
                              context, polylineWatch);
                        }
                      },
                      child: const Icon(CupertinoIcons.search,
                          color: Colors.black),
                    )
                  : FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: () async {
                        await googleMapsWatch.getCurrentPosition(context);
                        await googleMapsWatch.updateCameraPosition(
                          LatLng(
                            googleMapsWatch.position!.latitude,
                            googleMapsWatch.position!.longitude,
                          ),
                        );
                      },
                      child: const Icon(
                        CupertinoIcons.location,
                        color: Colors.black,
                      ),
                    ),
            ],
          ),
        ),
        bottomSheet: googleMapsWatch.isBottomSheetVisible
            ? Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 100,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Text(
                          googleMapsWatch.directionResponseModel!['routes'][0]
                              ['legs'][0]['duration']['text'],
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.green.withOpacity(1),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "(${googleMapsWatch.directionResponseModel!['routes'][0]['legs'][0]['distance']['text']})",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Container(
                height: 0,
              ),
      ),
    );
  }

  Widget listForPlaceAutoComplete(GoogleMapsController googleMapsWatch) =>
      ListView.separated(
        shrinkWrap: true,
        itemCount: googleMapsWatch
                .placeAutoCompleteResponseModel?.predictions.length ??
            0,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () async {
              if (!googleMapsWatch.isDirection) {
                await googleMapsWatch.getPlaceDetails(
                    context,
                    googleMapsWatch.placeAutoCompleteResponseModel
                            ?.predictions[index].placeId ??
                        "");
              } else {
                googleMapsWatch.setDirectionsId(index);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.location_solid),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(googleMapsWatch.placeAutoCompleteResponseModel
                            ?.predictions[index].description ??
                        ""),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            height: 1,
            color: Colors.black,
          );
        },
      );

  Widget listForQueryAutoComplete(GoogleMapsController googleMapsWatch) =>
      ListView.separated(
        shrinkWrap: true,
        itemCount: googleMapsWatch
                .queryAutoCompleteResponseModel?.predictions.length ??
            0,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () async {
              if (!googleMapsWatch.isDirection) {
                await googleMapsWatch.getPlaceDetails(
                    context,
                    googleMapsWatch.queryAutoCompleteResponseModel
                            ?.predictions[index].placeId ??
                        "");
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.location_solid),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(googleMapsWatch.queryAutoCompleteResponseModel
                            ?.predictions[index].description ??
                        ""),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            height: 1,
            color: Colors.black,
          );
        },
      );
}
