// ignore_for_file: unused_local_variable
import 'dart:ui' as ui;
import 'package:B2C/controller/localization_controller.dart';
import 'package:B2C/controller/search_controller.dart' as search;
import 'package:B2C/model/Search/search_product_model.dart';
import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/utility/widget_helper/common_text_widget.dart';
import 'package:B2C/view/screens/Business/business_about_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

// ignore: must_be_immutable
class SearchMapView extends StatefulWidget {
  List<SearchProductModel>? locationList;

  SearchMapView({super.key, this.locationList});

  @override
  State<SearchMapView> createState() => _SearchMapViewState();
}

class _SearchMapViewState extends State<SearchMapView> {
  late GoogleMapController mapController;
  // ignore: prefer_collection_literals
  Set<Marker> markers = Set();
  // ignore: prefer_collection_literals
  Set<Marker> currMarkers = Set();
  LatLng showLocation = const LatLng(31.95932, 34.81793);

  List<String> menuList = ["LIST", "MAP"];
  // int menuIndex = 0;
  final searchController = Get.put(search.SearchController());

  // final duplicateItems = List<SearchProductModel>.generate(100, (i) => "Item $i");
  List<SearchProductModel> items = [];

  FocusNode myFocusNode = FocusNode();
  String myHintText = 'Search';
  final localizationController = Get.put(LocalizationController());
  Uint8List markerIcon = Uint8List(0);
  Uint8List bigMarkerIcon = Uint8List(0);

  double currentLatitude = 31.7594;
  double currentLongitude = 34.8178;
  RxBool isGpsOn = true.obs;
  Location location = Location();
  bool isTapped = false;

  @override
  void initState() {
    var isbg = enableBackgroundMode();
    location.enableBackgroundMode(enable: true);

    getMarker();
    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  getMarker() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(48, 48)), 'assets/my_icon.png')
        .then((onValue) async {
      markerIcon = await getBytesFromAsset('assets/images/marker.png', 100);
      bigMarkerIcon =
          await getBytesFromAsset('assets/images/bigMarker.png', 120);

      processData(0);
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _searchMap(context),
        Directionality(
          textDirection: TextDirection.ltr,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(Get.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      icon: Image.asset('assets/images/icons.png'),
                      onPressed: () => {
                            Get.back(),
                          }),
                  const VerticalDivider(width: 1.0),
                  IconButton(
                      icon: Image.asset('assets/images/target.png'),
                      onPressed: () => {
                            _currentLocation(),
                            // getCurrentLocation(),
                          }),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Future<bool> enableBackgroundMode() async {
    bool bgModeEnabled = await location.isBackgroundModeEnabled();
    if (bgModeEnabled) {
      return true;
    } else {
      try {
        await location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      try {
        bgModeEnabled = await location.enableBackgroundMode();
      } catch (e) {
        debugPrint(e.toString());
      }
      return bgModeEnabled;
    }
  }

  void _currentLocation() async {
    // Create a map controller
    final GoogleMapController controller = mapController;
    LocationData? currentLocation;
    var location = Location();
    try {
      // Find and store your location in a variable
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    var lat = currentLocation?.latitude;
    var lng = currentLocation?.longitude;

    // var lat = currentLatitude;
    // var lng = currentLongitude;

    setState(() {
      showLocation = LatLng(lat!, lng!);

      markers.add(Marker(
          //add marker on google map
          markerId: MarkerId(showLocation.toString()),
          position: showLocation, //position of marker
          icon: BitmapDescriptor.fromBytes(markerIcon),
          onTap: () {
            markerIcon = markerIcon;
          }));

      GoogleMap(
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: showLocation,
          zoom: 10.0,
        ),
        markers: markers,
        myLocationEnabled: true,
        mapType: MapType.normal,
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
        onTap: _handleTap,
      );

      // Move the map camera to the found location using the controller
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(lat, lng),
          zoom: 12.0,
        ),
      ));
    });
  }

  Future getCurrentLocation() async {
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted == PermissionStatus.granted) {}
    }
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    if (serviceEnabled) {
      // currentLatitude = event.latitude!;
      // currentLongitude = event.longitude!;
      isGpsOn.value = false;

      //-----------------

      setState(() {
        showLocation = LatLng(currentLatitude, currentLongitude);

        markers.add(Marker(
            //add marker on google map
            markerId: MarkerId(showLocation.toString()),
            position: showLocation, //position of marker
            icon: BitmapDescriptor.fromBytes(markerIcon),
            onTap: () {
              markerIcon = markerIcon;
            }));

        GoogleMap(
          zoomGesturesEnabled: true,
          initialCameraPosition: CameraPosition(
            target: showLocation,
            zoom: 16.0,
          ),
          markers: markers,
          myLocationEnabled: true,
          mapType: MapType.normal,
          onMapCreated: (controller) {
            setState(() {
              mapController = controller;
            });
          },
          // onTap: _handleTap,
        );
      });
    }
  }

  _handleTap(LatLng point) {
    setState(() {
      markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: const InfoWindow(
          title: 'You',
        ),
        icon: BitmapDescriptor.fromBytes(bigMarkerIcon),
      ));
    });
  }

  _searchMap(BuildContext context) {
    return GoogleMap(
      zoomGesturesEnabled: true,
      initialCameraPosition: CameraPosition(
        target: showLocation,
        zoom: 10.0,
      ),
      markers: markers,
      mapType: MapType.normal,
      onMapCreated: (controller) {
        setState(() {
          mapController = controller;
        });
      },
      // onTap: _handleTap,
    );
  }

  processData(int productId) {
    items = searchController.searchDetails.toList();

//--------------------
    for (var product in items) {
      if (double.parse(product.latitude.toString()) != 0 ||
          double.parse(product.latitude.toString()) != 0) {
        Uint8List markIcon = (isTapped && productId == product.productId)
            ? bigMarkerIcon
            : markerIcon;

        setState(() {
          showLocation = LatLng(product.latitude, product.longitude);

          markers.add(Marker(
            //add marker on google map
            markerId: MarkerId(showLocation.toString()),
            position: showLocation, //position of marker
            onTap: () {
              setState(() {
                isTapped = true;
                var pname = product.name;
                var pAddress = product.address;
                var fullDesc = product.fullDescription ?? "";

                if (fullDesc.isEmpty) {
                  fullDesc = localizationController.isHebrew.value
                      ? product.shortDescriptionH
                      : product.shortDescription ?? "";
                }
                _bottomSheet(product);
              });

              processData(product.productId);
            },
            icon: BitmapDescriptor.fromBytes(markIcon),
          ));
        });
      }
    }
  }

  _bottomSheet(SearchProductModel character) {
    return Get.bottomSheet(
      GestureDetector(
        onTap: () {
          Get.to(BusinessAboutScreen(character.productId,true));
        },
        child: SafeArea(
          child: Container(
            height: Get.width * 0.2,
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
              child: Card(
                  elevation: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Get.height * 0.005),
                        color: Colors.white),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.width * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: localizationController.isHebrew.value
                                      ? EdgeInsets.only(left: Get.width * 0.04)
                                      : EdgeInsets.only(
                                          right: Get.width * 0.04),
                                  child: Container(
                                    height: Get.height * 0.064,
                                    width: Get.height * 0.064,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(
                                          Get.height * 0.008),
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.all(Get.width * 0.008),
                                      key: Key(character.logoImageUrl),
                                      height: Get.height * 0.054,
                                      width: Get.height * 0.054,
                                      // child: NetworkImageView(character: character)
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Get.height * 0.005),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              character.logoImageUrl),
                                          opacity: 2.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CommenTextWidget(
                                        s: localizationController.isHebrew.value
                                            ? character.nameH
                                            : character.name,
                                        size: 15,
                                        fs: FontStyle.normal,
                                        fw: FontWeight.bold,
                                        clr: Colr.black1,
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          CommenTextWidget(
                                            s: localizationController
                                                    .isHebrew.value
                                                ? character.addressH
                                                : character.address,
                                            size: 12,
                                            fs: FontStyle.normal,
                                            fw: FontWeight.w400,
                                            clr: Colr.black1,
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: localizationController
                                                      .isHebrew.value
                                                  ? Alignment.bottomLeft
                                                  : Alignment.bottomRight,
                                              child: CommenTextWidget(
                                                s: "${character.distance} ${"Km".tr}",
                                                size: 12,
                                                fs: FontStyle.normal,
                                                fw: FontWeight.w400,
                                                clr: Colr.black1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
