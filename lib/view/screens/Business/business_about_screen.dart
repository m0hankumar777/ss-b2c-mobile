import 'dart:async';
import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/utility/widget_helper/common_text_widget.dart';
import 'package:B2C/view/screens/Business/reviews_screen.dart';
import 'package:B2C/view/screens/Business/service_screen.dart';
import 'package:B2C/view/screens/Business/gallery_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import '../../../utility/ui_helper.dart' as list;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:B2C/utility/images.dart' as images;

import '../../../controller/business_controller.dart';
import '../../../controller/localization_controller.dart';
import 'frequently_asked_questions_screen.dart';

// ignore: must_be_immutable
class BusinessAboutScreen extends StatefulWidget {
  int id;
  bool canClear;
  BusinessAboutScreen(this.id, this.canClear, {super.key});

  @override
  State<BusinessAboutScreen> createState() => _BusinessAboutScreenState();
}

class _BusinessAboutScreenState extends State<BusinessAboutScreen> {
  Location location = Location();
  final businessController = Get.put(BusinessController());
  final localizationController = Get.put(LocalizationController());
  int currentIndex = 0;
  int tabIndex = 0;
  RxBool isGpsEnabled = true.obs;
  // ignore: prefer_typing_uninitialized_variables
  var lati = 0.0;
  // ignore: prefer_typing_uninitialized_variables
  var longi = 0.0;
  bool isLoad = false;
  List<String> imgList = [];
  GoogleMapController? mapController;
  // ignore: prefer_collection_literals
  Set<Marker> markers = Set();
  // ignore: prefer_const_constructors
  LatLng showLocation = LatLng(0.0, 0.0);
  final ScrollController _scrollViewController = ScrollController();
  bool isScrollingDown = false;
  bool _showAppbar = false;
  @override
  void initState() {
    super.initState();
    fetchAPI();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = true;
          setState(() {});
        }
      }

      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = false;
          setState(() {});
        }
      }
    });
  }

  Future<void> fetchAPI() async {
    businessController.getBusinessData(widget.id, lati, longi);
    await getCurrentLocation().then(
        (value) => businessController.getBusinessData(widget.id, lati, longi));
    setState(() {
      showLocation = LatLng(
          businessController.businessData.value.salonDetail!.latitude,
          businessController.businessData.value.salonDetail!.longitude);
    });
    markers.add(Marker(
      //add marker on google map
      markerId: MarkerId(showLocation.toString()),
      position: showLocation, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: businessController.businessData.value.salonDetail!.name,
        snippet: businessController.businessData.value.salonDetail!.address,
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));
    if (businessController.businessData.value.coverPhoto!.isNotEmpty) {
      for (int i = 0;
          i < businessController.businessData.value.coverPhoto!.length;
          i++) {
        imgList
            .add(businessController.businessData.value.coverPhoto![i].imageUrl);
      }
    }
    setState(() {
      isLoad = true;
    });
    await getCurrentLocation();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollViewController.dispose();
    _scrollViewController.removeListener(() {});
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: isLoad
            ? NestedScrollView(
                controller: _scrollViewController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    sliverBar(context),
                  ];
                },
                body: TabBarView(children: [
                  ServiceScreen(
                      buisnessId: widget.id, canClear: widget.canClear),
                  ShowImages(widget.id),
                  getABoutScreen(context),
                  ReviewsScreen(widget.id),
                  FAQScreen(widget.id)
                ]),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: Colr.primary,
                ),
              ),
      ),
    );
  }

  SliverAppBar sliverBar(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      title: _showAppbar
          ? CommenTextWidget(
              s: localizationController.isHebrew.value
                  ? businessController.businessData.value.salonDetail?.name !=
                          null
                      ? businessController.businessData.value.salonDetail!.name
                          .toString()
                      : ''
                  : businessController.businessData.value.salonDetail?.nameE !=
                          null
                      ? businessController.businessData.value.salonDetail!.nameE
                          .toString()
                      : '',
              size: 18,
              clr: Colors.black,
              fw: FontWeight.bold,
            )
          : const Text(''),
      leadingWidth: localizationController.isHebrew.value ? 90 : 55,
      leading:
          localizationController.isHebrew.value ? ratingCard() : backButton(),
      actions: [
        localizationController.isHebrew.value ? backButton() : ratingCard(),
      ],
      centerTitle: true,
      backgroundColor: Colors.white,
      pinned: true,
      snap: false,
      floating: false,
      expandedHeight: Get.height * 0.43,
      flexibleSpace: FlexibleSpaceBar(
          background: Column(
        children: [
          imgList.isNotEmpty
              ? getCoverPicture(context)
              : Container(
                  height: Get.height * 0.27,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/Glamz-cover.png"))),
                ),
          getProfilePicture(context),
        ],
      )),
      bottom: TabBar(
        isScrollable: true,
        indicatorColor: Colr.primary,
        unselectedLabelColor: Colors.black,
        labelColor: Colr.primary,
        tabs: [
          Tab(
            text: ("Services".tr),
          ),
          Tab(
            text: ("Gallery".tr),
          ),
          Tab(
            text: "About".tr,
          ),
          Tab(
            text: "Reviews".tr,
          ),
          Tab(
            text: "FAQ".tr,
          ),
        ],
      ),
    );
  }

  Padding backButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: CircleAvatar(
        backgroundColor: const Color.fromARGB(255, 235, 233, 233),
        radius: 18,
        child: IconButton(
          icon: localizationController.isHebrew.value
              ? const Icon(Icons.chevron_right)
              : const Icon(Icons.chevron_left),
          iconSize: 20,
          color: Colors.black,
          onPressed: () {
            Get.back();
          },
        ),
      ),
    );
  }

  Card ratingCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      color: Colors.white,
      elevation: 5,
      child: localizationController.isHebrew.value ? rowHebrew() : rowEnglish(),
    );
  }

  Row rowHebrew() {
    return Row(
      children: [
        const Text(' '),
        Icon(
          Icons.star,
          color: Colr.primary,
          size: 20,
        ),
        CommenTextWidget(
            s: businessController.businessData.value.salonDetail?.rating
                .toStringAsFixed(1)),
        const Text(' '),
      ],
    );
  }

  Row rowEnglish() {
    return Row(
      children: [
        const Text(' '),
        CommenTextWidget(
            s: businessController.businessData.value.salonDetail?.rating
                .toStringAsFixed(1)),
        Icon(
          Icons.star,
          color: Colr.primary,
          size: 20,
        ),
        const Text(' '),
      ],
    );
  }

  getCoverPicture(BuildContext context) {
    return Stack(children: [
      CarouselSlider(
        options: CarouselOptions(
          viewportFraction: 1,
          height: Get.height * 0.27,
          enableInfiniteScroll: false,
          autoPlay: imgList.length > 1 ? true : false,
          onPageChanged: (index, reason) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
        items: imgList
            .map((item) => Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill, image: NetworkImage(item))),
                ))
            .toList(),
      ),
    ]);
  }

  getProfilePicture(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        children: [
          Container(
            width: Get.width * 0.15,
            height: Get.height * 0.07,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(5),
                image: businessController
                                .businessData.value.salonDetail?.imageUrl !=
                            null &&
                        businessController
                                .businessData.value.salonDetail?.imageUrl !=
                            ''
                    ? DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(businessController
                                .businessData.value.salonDetail!.imageUrl ??
                            ''))
                    : const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/glamz-logo.png"))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  salonName(),
                  SizedBox(
                    child: addressField(),
                  ),
                ]),
          )
        ],
      ),
    );
  }

  salonName() {
    return SizedBox(
      width: Get.width * 0.5,
      child: CommenTextWidget(
          s: localizationController.isHebrew.value
              ? businessController.businessData.value.salonDetail?.name != null
                  ? businessController.businessData.value.salonDetail!.name
                      .toString()
                  : ''
              : businessController.businessData.value.salonDetail?.nameE != null
                  ? businessController.businessData.value.salonDetail!.nameE
                      .toString()
                  : '',
          clr: Colors.black,
          mxL: 2,
          of: TextOverflow.ellipsis,
          size: 18,
          fw: FontWeight.w500),
    );
  }

  Row addressField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: Get.width * 0.5,
          child: CommenTextWidget(
            s: localizationController.isHebrew.value
                ? businessController.businessData.value.salonDetail?.address !=
                        null
                    ? businessController.businessData.value.salonDetail!.address
                        .toString()
                    : ''
                : businessController.businessData.value.salonDetail?.addressE !=
                        null
                    ? businessController
                        .businessData.value.salonDetail!.addressE
                        .toString()
                    : '',
            size: 14,
            fw: FontWeight.w300,
            clr: Colors.black54,
            mxL: 2,
            of: TextOverflow.ellipsis,
          ),
        ),
        CommenTextWidget(
            s: '${businessController.businessData.value.salonDetail!.distance} '
                '${'Km'.tr} ',
            align: TextAlign.left,
            clr: Colors.black54,
            size: 14,
            fw: FontWeight.w300),
      ],
    );
  }

  Future getCurrentLocation() async {
    LocationData? currentLocation;
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
      var location = Location();
      try {
        // Find and store your location in a variable
        currentLocation = await location.getLocation();
      } on Exception {
        currentLocation = null;
      }
      if (currentLocation != null) {
        lati = currentLocation.latitude!;
        longi = currentLocation.longitude!;
      }
    }
    // if (serviceEnabled) {
    //   location.onLocationChanged.listen((event) {
    //     if (mounted) {
    //       setState(() {
    //         lati = event.latitude;
    //         longi = event.longitude;
    //         isGpsEnabled.value = false;
    //       });
    //     }
    //   });
    // }
  }

  getABoutScreen(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: CommenTextWidget(
              s: 'About'.tr,
              size: 18,
              fs: FontStyle.normal,
              fw: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Obx(() => CommenTextWidget(
                  s: businessController.businessData.value.salonDetail!
                              .shortDescription !=
                          null
                      ? businessController
                          .businessData.value.salonDetail!.shortDescription!
                      : '',
                  size: 14,
                  fs: FontStyle.normal,
                  fw: FontWeight.normal,
                )),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: CommenTextWidget(
              s: 'Working Hours'.tr,
              size: 18,
              fs: FontStyle.normal,
              fw: FontWeight.bold,
            ),
          ),
          getWorkingHours(),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: CommenTextWidget(
              s: 'Address'.tr,
              size: 18,
              fs: FontStyle.normal,
              fw: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: addressField(),
          ),
          getMap(),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: CommenTextWidget(
              s: 'Facilities'.tr,
              size: 18,
              fs: FontStyle.normal,
              fw: FontWeight.bold,
            ),
          ),
          getFacilities(),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: CommenTextWidget(
              s: 'Staff'.tr,
              size: 18,
              fs: FontStyle.normal,
              fw: FontWeight.bold,
            ),
          ),
          getAvailableStaffs(),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  getWorkingHours() {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: List.generate(
              7,
              (index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CommenTextWidget(
                              s: localizationController.isHebrew.value
                                  ? list.daysH[index]
                                  : list.days[index],
                              size: 14,
                              fs: FontStyle.normal,
                              fw: FontWeight.normal,
                            ),
                            isToday(businessController.businessData.value
                                    .businessWorkingHours![index].day!)
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6.0, vertical: 4.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colr.primary,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: CommenTextWidget(
                                          s: 'Today'.tr,
                                          size: 14,
                                          fs: FontStyle.normal,
                                          fw: FontWeight.normal,
                                          clr: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        businessController
                                        .businessData
                                        .value
                                        .businessWorkingHours![index]
                                        .fromWorkingHours ==
                                    'NULL' ||
                                businessController
                                        .businessData
                                        .value
                                        .businessWorkingHours![index]
                                        .fromWorkingHours ==
                                    '' ||
                                businessController
                                        .businessData
                                        .value
                                        .businessWorkingHours![index]
                                        .fromWorkingHours ==
                                    null
                            ? CommenTextWidget(
                                s: 'Closed'.tr,
                                clr: Colors.red,
                                size: 14,
                                fw: FontWeight.normal)
                            : CommenTextWidget(
                                s: localizationController.isHebrew.value
                                    ? '${businessController.businessData.value.businessWorkingHours![index].toWorkingHours} - ${businessController.businessData.value.businessWorkingHours![index].fromWorkingHours}'
                                    : '${businessController.businessData.value.businessWorkingHours![index].fromWorkingHours} - ${businessController.businessData.value.businessWorkingHours![index].toWorkingHours}',
                                size: 14,
                                fs: FontStyle.normal,
                                fw: FontWeight.normal,
                              )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                );
              },
            ),
          ),
        ));
  }

  getFacilities() {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
              spacing: 20,
              runSpacing: 10,
              alignment: WrapAlignment.spaceEvenly,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: List.generate(
                businessController.businessData.value.facilityType!.length,
                (index) => Chip(
                  padding: const EdgeInsets.all(12),
                  backgroundColor: const Color.fromARGB(255, 243, 242, 242),
                  shadowColor: Colors.black,
                  avatar: CircleAvatar(
                    backgroundImage: AssetImage(images.facilities[
                        businessController
                                .businessData.value.facilityType![index].id -
                            1]), //NetworkImage
                  ), //CircleAvatar
                  label: CommenTextWidget(
                    s: localizationController.isHebrew.value
                        ? businessController
                            .businessData.value.facilityType![index].nameH
                        : businessController
                            .businessData.value.facilityType![index].name,
                    size: 16,
                    fs: FontStyle.normal,
                    fw: FontWeight.normal,
                  ),
                ), //Text
              )),
        ));
  }

  getAvailableStaffs() {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
                children: List.generate(
                    businessController.businessData.value.staffDetail!.length,
                    (index) {
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 27,
                        backgroundColor: Colors.white,
                        child: businessController.businessData.value
                                    .staffDetail![index].imageUrl !=
                                null
                            ? CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(businessController
                                    .businessData
                                    .value
                                    .staffDetail![index]
                                    .imageUrl),
                              )
                            : const CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    AssetImage('assets/images/glamz-logo.png'),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: SizedBox(
                          width: 200,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommenTextWidget(
                                    s: businessController.businessData.value
                                        .staffDetail![index].firstName,
                                    //textAlign: TextAlign.left,
                                    clr: Colors.black,
                                    size: 18,
                                    fw: FontWeight.w500),
                                CommenTextWidget(
                                    s: businessController.businessData.value
                                            .staffDetail![index].position ??
                                        '',
                                    //textAlign: TextAlign.left,
                                    clr: Colors.black54,
                                    size: 14,
                                    fw: FontWeight.w300),
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              );
            })),
          ),
        ));
  }

  getMap() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey, width: 1.0)),
            child: GoogleMap(
              zoomGesturesEnabled: true,
              initialCameraPosition:
                  CameraPosition(target: showLocation, zoom: 16),
              markers: markers,
              mapType: MapType.normal,
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  isToday(int day) {
    if (DateFormat('EEEE').format(DateTime.now()) == list.days[day]) {
      return true;
    } else {
      return false;
    }
  }
}
