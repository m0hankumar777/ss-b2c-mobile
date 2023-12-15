import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:B2C/controller/customer_controller.dart';
import 'package:B2C/controller/homescreen_controller.dart';
import 'package:B2C/controller/localization_controller.dart';
import 'package:B2C/controller/search_controller.dart' as search;
import 'package:B2C/model/Search/search_product_model.dart';
import 'package:B2C/utility/themes_b2c.dart';
import 'package:B2C/utility/widget_helper/common_text_widget.dart';
import 'package:B2C/view/screens/Business/business_about_screen.dart';
import 'package:B2C/view/screens/HomeScreen/sub_category_screen.dart';
import 'package:B2C/view/screens/SearchScreen/no_item_found_screen.dart';
import 'package:B2C/view/screens/SearchScreen/search_map_view_screen.dart';
import 'package:B2C/view/screens/SearchScreen/character_card_item.dart';
import 'package:B2C/view/screens/SearchScreen/character_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

// ignore: must_be_immutable
class SearchScreeanView extends StatefulWidget {
  String? searchKey;

  SearchScreeanView({super.key, this.searchKey});

  @override
  State<SearchScreeanView> createState() => _SearchScreeanViewState();
}

class _SearchScreeanViewState extends State<SearchScreeanView> {
  final searchController = Get.put(search.SearchController());
  final homeScreenController = Get.put(HomeScreenController());
  final localizationController = Get.put(LocalizationController());
  final customerController = Get.put(CustomerController());

  TextEditingController _searchController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  List<SearchProductModel> items = [];
  List<String> allsearchCategory = [];
  List<String> allsearchLocation = [];

  //-----------
  static const _pageSize = 24;

  final PagingController<int, SearchProductModel> _pagingController =
      PagingController(firstPageKey: 0);
  late GoogleMapController mapController;

  //-----------

  bool isStart = true;
  bool isLoading = false;
  bool isSalonEditing = false;
  bool isLocationEditing = false;
  bool showSalonRecentSearch = false;
  bool showLocationRecentSearch = false;
  RxBool isRecentLocationSelected = false.obs;
  RxBool isRecentSalonSelected = false.obs;

  bool noResults = false;

  bool isTab = false;
  int resultCount = 0;
  bool isServicesSelected = false;
  int isServicesSelectedIndex = -1;
  List<String> recentSalonList = [];
  List<String> recentLocationList = [];
  bool isSubCategorySelected = false;

  //---------------

  final SVProgressHUDStyle _style = SVProgressHUDStyle.custom;
  final SVProgressHUDMaskType _maskType = SVProgressHUDMaskType.gradient;
  final SVProgressHUDAnimationType _animationType =
      SVProgressHUDAnimationType.flat;
  // ignore: unused_field
  final double _minimumSizeWidth = 0;
  // ignore: unused_field
  final double _minimumSizeHeight = 0;
  final int _ringThickness = 7;
  final double _ringRadius = 25;
  final double _ringNoTextRadius = 15;
  // ignore: unused_field
  final int _cornerRadius = 50;
  // ignore: unused_field
  final bool _hapticsEnabled = false;
  bool loadData = false;

  LatLng showLocation = const LatLng(27.7089427, 85.3086209);

  double currentLatitude = 10.8226148;
  double currentLongitude = 78.6831259;
  RxBool isGpsOn = true.obs;
  Location location = Location();

  //---------------------

  bool servicestatus = false;
  bool haspermission = false;
  String long = "", lat = "";

  RxList autoServicesSearchList = [].obs;
  RxList autoLocationSearchList = [].obs;

  //----------------------

  @override
  void initState() {
    super.initState();
    _updateHUDConfig();
    getCurrentLocation().then(
      (value) {
        _fetchPage(0);
      },
    );
    _pagingController.addPageRequestListener((pageKey) {
      if (!loadData && pageKey != 0) {
        loadData = !loadData;
        getCurrentLocation().then((value) {
          _fetchPage(pageKey);
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.searchKey != null) {
        _searchController.text = widget.searchKey.toString();
        searchController.searchDetails.clear();
        _fetchPage(0);
      }
    });

    recentSearchList();
    fetchAPI();

    if (widget.searchKey != null && widget.searchKey!.isNotEmpty) {
      isSubCategorySelected = true;
      addSalonSearch(widget.searchKey!.toString());
    }

    if (widget.searchKey != null) {
      _searchController.text = widget.searchKey.toString();
      isSalonEditing = true;
    }

    // checkGps();

    getCurrentLocation().then(
      (value) {
        if (value != null) {
          currentLatitude = value.latitude!;
          currentLongitude = value.longitude!;
        }
        _fetchPage(0);
      },
    );
  }

  /*  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        getLocation();
      }
    } else {
      // permission = await Geolocator.requestPermission();
      print("GPS Service is not enabled, turn on GPS location");
    }
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      setState(() {
        currentLatitude = position.latitude;
        currentLongitude = position.longitude;
      });
    });
  } */

  // created method for getting user current location
  /*  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  } */

  void _updateHUDConfig() {
    SVProgressHUD.setForegroundColor(Colr.primary);
    SVProgressHUD.setDefaultStyle(_style);
    SVProgressHUD.setDefaultMaskType(_maskType);
    SVProgressHUD.setDefaultAnimationType(_animationType);
    if (Platform.isAndroid) {
      SVProgressHUD.setCornerRadius(50);
    } else if (Platform.isIOS) {
      SVProgressHUD.setCornerRadius(34);
    }
    // SVProgressHUD.setMinimumSize(Size(_minimumSizeWidth, _minimumSizeHeight));
    SVProgressHUD.setRingThickness(_ringThickness);
    SVProgressHUD.setRingRadius(_ringRadius);
    SVProgressHUD.setRingNoTextRadius(_ringNoTextRadius);
    // SVProgressHUD.setCornerRadius(_cornerRadius);
    // SVProgressHUD.setBorderColor(Colors.red);
    // SVProgressHUD.setBorderWidth(12);
    // SVProgressHUD.setForegroundImageColor(Colors.amber);
    // SVProgressHUD.setBackgroundColor(Colr.primary);
    // SVProgressHUD.setBackgroundLayerColor(Colors.cyan.withOpacity(0.5));
    // SVProgressHUD.setImageViewSize(Size(60, 60));
    // SVProgressHUD.setMinimumDismissTimeInterval(2);
    // SVProgressHUD.setFadeInAnimationDuration(1);
    // SVProgressHUD.setFadeOutAnimationDuration(1);
    // SVProgressHUD.setHapticsEnabled(_hapticsEnabled);
  }

  Future<void> _fetchPage(pageKey) async {
    try {
      var newItems = <SearchProductModel>[];

      if (_searchController.text.isNotEmpty &&
          _locationController.text.isNotEmpty) {
        if (pageKey == 0) _pagingController.refresh();
        loadData = !loadData;
        await searchController
            .search(pageKey, _pageSize, _searchController.text,
                _locationController.text, currentLatitude, currentLongitude)
            .then((value) {
          if (value == 200) {
            newItems = searchController.searchDetails.toList();
            processData(value, "");
            setState(() {
              resultCount = newItems.isNotEmpty ? newItems[0].totalCount : 0;
              isSalonEditing = true;
              isLocationEditing = true;
              showSalonRecentSearch = false;
              showLocationRecentSearch = false;
              isLoading = false;
            });
          }
        });
      } else if (_searchController.text.isNotEmpty &&
          _locationController.text.isEmpty) {
        // SVProgressHUD.show();
        if (pageKey == 0) _pagingController.refresh();
        loadData = !loadData;
        await searchController
            .searchSalonOrServices(pageKey, _pageSize, _searchController.text,
                currentLatitude, currentLongitude)
            .then((value) {
          if (value == 200) {
            newItems = searchController.searchDetails.toList();
            processData(value, "");
            setState(() {
              resultCount = newItems.isNotEmpty ? newItems[0].totalCount : 0;
              isLoading = false;
              isSalonEditing = true;
              showSalonRecentSearch = false;
              showLocationRecentSearch = false;
            });
          }
        });
      } else if (_searchController.text.isEmpty &&
          _locationController.text.isNotEmpty) {
        // SVProgressHUD.show();
        if (pageKey == 0) _pagingController.refresh();

        await searchController
            .searchByLocation(pageKey, _pageSize, _locationController.text,
                currentLatitude, currentLongitude)
            .then((value) {
          if (value == 200) {
            newItems = searchController.searchDetails.toList();
            processData(value, "");
            setState(() {
              resultCount = newItems.isNotEmpty ? newItems[0].totalCount : 0;
              isLoading = false;
              isLocationEditing = true;
              showSalonRecentSearch = false;
              showLocationRecentSearch = false;
            });
          }
        });
      } else {
        if (pageKey == 0) _pagingController.refresh();

        await searchController
            .getBestRatedSalons(
                pageKey, _pageSize, currentLatitude, currentLongitude)
            .then((value) {
          if (value == 200) {
            newItems = searchController.bestRatedSalons.toList();
            processData(value, "bestRated");
            setState(() {
              resultCount = newItems.isNotEmpty ? newItems[0].totalCount : 0;
              isLoading = false;
            });
          }
        });
      }

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
    SVProgressHUD.dismiss();
  }

  recentSearchList() async {
    /*  var salonBox = await Hive.openBox('recentSalonSearch');
    var locationBox = await Hive.openBox('recentLocationSearch');
    salonBox.put('name', "123");
    String name = salonBox.get('name');
    String name1 = locationBox.get('name'); */

    SharedPreferences pre = await SharedPreferences.getInstance();
    recentSalonList = pre.getStringList("recentSalonSearch") ?? [];
    recentLocationList = pre.getStringList("recentLocationSearch") ?? [];

    pre.setStringList("recentSalonSearch", recentSalonList); //save List
    pre.setStringList("recentLocationSearch", recentLocationList);
  }

  Future<void> addSalonSearch(String salonService) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    recentSalonList = pre.getStringList("recentSalonSearch") ?? [];
    if (recentSalonList.isNotEmpty) {
      recentSalonList = recentSalonList
          .map((recentSalonList) => recentSalonList.toLowerCase())
          .toList();
      if (!recentSalonList.contains(salonService.toLowerCase())) {
        if (recentSalonList.length >= 5) {
          recentSalonList.removeAt(0);
        }
        recentSalonList.add(salonService);
      }
    } else {
      recentSalonList.add(salonService);
    }
    recentSalonList = recentSalonList.reversed.toList();
    pre.setStringList("recentSalonSearch", recentSalonList); //save List
  }

  Future<void> addLocationSearch(String salonService) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    recentLocationList = pre.getStringList("recentLocationSearch") ?? [];
    if (recentLocationList.isNotEmpty) {
      recentLocationList = recentLocationList
          .map((recentLocationList) => recentLocationList.toLowerCase())
          .toList();

      if (!recentLocationList.contains(salonService.toLowerCase())) {
        if (recentLocationList.length >= 5) {
          recentLocationList.removeAt(0);
        }
        recentLocationList.add(salonService);
      }
    } else {
      recentLocationList.add(salonService);
    }
    recentLocationList = recentLocationList.reversed.toList();
    pre.setStringList("recentLocationSearch", recentLocationList);
  }

  clearRecentSalonSearch() {
    setState(() {
      clearSalonSearch();
    });
  }

  clearSalonSearch() async {
    recentSalonList.clear();
    SharedPreferences pre = await SharedPreferences.getInstance();
    pre.setStringList("recentSalonSearch", recentSalonList); //save List
  }

  clearRecentLocationSearch() {
    setState(() {
      clearLocationSearch();
    });
  }

  clearLocationSearch() async {
    recentLocationList.clear();
    SharedPreferences pre = await SharedPreferences.getInstance();
    pre.setStringList("recentLocationSearch", recentLocationList);
  }

  Future<void> fetchAPI() async {
    await getCurrentLocation();
    await homeScreenController.getAllCategories();
    await homeScreenController.getRecommendedSalons(
        currentLatitude, currentLongitude);
    await homeScreenController.getClientReviewCount();
    await homeScreenController.getClientReviews();

    /*  await searchController
        .getSalonandSservices(_searchController.text)
        .then((value) {
      allsearchCategory = searchController.allsearchCategory;
      log(allsearchLocation.toString());

      if (allsearchCategory.isEmpty) {
        allsearchCategory = searchController.allSearchDummy;
      }
    });
    await searchController.getLocations(_locationController.text).then((value) {
      allsearchLocation = searchController.allsearchLocation;
      log(allsearchLocation.toString());
      if (allsearchLocation.isEmpty) {
        allsearchLocation = searchController.allLocationDummy;
      }
    }); */
  }

  // ignore: body_might_complete_normally_nullable
  Future<LocationData?> getCurrentLocation() async {
    LocationData? currentLocation;

    location.enableBackgroundMode(enable: true);

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
        currentLatitude = currentLocation.latitude!;
        currentLongitude = currentLocation.longitude!;
      }

      /*   location.onLocationChanged.listen((event) {
        currentLatitude = event.latitude!;
        currentLongitude = event.longitude!;
        isGpsOn.value = false;
      }); */
      return currentLocation;
    }
  }

  loader(bool isloading) {
    // SVProgressHUD.setCornerRadius(50);
    // // SVProgressHUD.setBackgroundColor(Colors.red);
    // // SVProgressHUD.setBackgroundLayerColor(Colors.blue);
    // SVProgressHUD.setForegroundColor(Colors.yellow);
    // SVProgressHUD.setRingThickness(7);
    isloading ? SVProgressHUD.show() : SVProgressHUD.dismiss();
  }

  IconButton iconButton() {
    return IconButton(
      icon: Icon(
        localizationController.isHebrew.value
            ? Icons.arrow_forward_ios_outlined
            : Icons.arrow_back_ios_rounded,
        color: Colors.white,
        size: 16,
      ),
      onPressed: () {
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colr.primaryLight,
      floatingActionButton: resultCount > 0 ? getFloatingButton() : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        leading:
            localizationController.isHebrew.value ? Container() : iconButton(),
        actions: [
          localizationController.isHebrew.value ? iconButton() : Container()
        ],
        title: CommenTextWidget(
          s: 'SEARCH'.tr,
          size: 15,
          fs: FontStyle.normal,
          fw: FontWeight.bold,
          clr: Colors.white,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colr.primary,
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          isRecentSalonSelected.value = false;
        },
        child: Column(children: [
          Container(
            color: const Color(0xffAE1133),
            height: Get.height * 0.20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                searchAutoComplete("Services"),
                searchAutoComplete("Location"),
              ],
            ),
          ),
          if (!isSalonEditing &&
              !isLocationEditing &&
              !showLocationRecentSearch)
            Services(),
          // getRecommendationSalons(),
          // getRecommendationSalonsList(),

          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    /*   !isSalonEditing || !isLocationEditing
                        ? recommendedSalonsListTitle()
                        : Container(), */
                    recommendedSalonsListTitle(),
                    recommendedSalonsListWidget(),
                  ],
                ),
                if (showSalonRecentSearch) recentSalonSearch(),
                if (showLocationRecentSearch) recentLocationSearch(),
              ],
            ),
          ),

          // isTab ? recommendedSalonsListTitle() : searchSalonsListTitle([]),
          // isTab ? recommendedSalonsListWidget() : searchSalonsListWidget([]),
          //-------------
          /* PagedListView<int, SearchProductModel>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<SearchProductModel>(
              itemBuilder: (context, item, index) =>
                  /*  CharacterListItem(
                character: item,
              ), */
      
                  getSearchSalonsList(items),
            ),
          ), */

          //----------------------------------
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    SVProgressHUD.dismiss();
    super.dispose();
  }

  searchAutoComplete(String searchTerm) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        // ignore: unnecessary_null_comparison
        if (textEditingValue != null) {
          if (searchTerm != "Location") {
            var value = textEditingValue.text.length > 2
                ? allsearchCategory
                    .where((element) => element
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()))
                    .toList()
                : null;
            if (value == null) {
              return [];
            } else {
              return value;
            }
          } else {
            var value = textEditingValue.text.length > 2
                ? allsearchLocation
                    .where((element) => element
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()))
                    .toList()
                : null;
            if (value == null) {
              return [];
            } else {
              return value;
            }
          }
        } else {
          return [];
        }
      },
      displayStringForOption: (String option) => option,
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        if (searchTerm != "Location") {
          // _searchController.text = widget.searchKey ?? "";
          _searchController = fieldTextEditingController;
          // if (widget.searchKey != null && isSalonEditing) {
          //   _searchController.text = widget.searchKey.toString();
          // }
          // return searchByCategoryContainer(_searchController, fieldFocusNode);
          if (isSubCategorySelected) {
            _searchController.text = widget.searchKey.toString();
          }
          return searchBarWidget(_searchController, fieldFocusNode);
        } else {
          _locationController = fieldTextEditingController;
          // return searchByLocationContainer(_locationController, fieldFocusNode);
          return searchLocationWidget(_locationController, fieldFocusNode);
        }
      },
      onSelected: (String selection) {
        if (searchTerm != "Location") {
          // addSalonSearch(selection);
        } else {
          // addLocationSearch(selection);
        }
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        return Visibility(
          visible: isSalonEditing ||
              isLocationEditing ||
              (!isRecentSalonSelected.value && !isRecentLocationSelected.value),
          child: Padding(
            padding: EdgeInsets.fromLTRB(Get.height * 0.02, 0.0, 0, 0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Material(
                child: Container(
                  width: Get.width * 0.92,
                  height: Get.height * 0.35,
                  color: Colors.grey[100],
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0.0),
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      TextEditingController txtcontroller =
                          searchTerm != "Location"
                              ? _searchController
                              : _locationController;
                      return GestureDetector(
                        onTap: () {
                          SVProgressHUD.show();
                          onSelected(option);
                          loadData = false;

                          _fetchPage(0);
                        },
                        child: ListTile(
                          title: suggestedTextFormField(txtcontroller, option),
                          selectedColor: Colr.primary,
                          selectedTileColor: Colr.primary,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  getPager(bool istab) {
    return Expanded(
      child: PagedListView<int, SearchProductModel>.separated(
        padding: EdgeInsets.symmetric(
          horizontal: Get.height * 0.02,
          vertical: Get.height * 0.022,
        ),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<SearchProductModel>(
          animateTransitions: true,
          itemBuilder: (context, item, index) {
            return istab
                ? GestureDetector(
                    onTap: () async {
                      Get.to(BusinessAboutScreen(item.productId, true));
                    },
                    child: CharacterListItem(
                      character: item,
                      localizationController: localizationController,
                    ),
                  )
                : GestureDetector(
                    onTap: () async {
                      Get.to(BusinessAboutScreen(item.productId, true));
                    },
                    child: CharacterCardItem(
                      character: item,
                      localizationController: localizationController,
                    ),
                  );
          },
          firstPageErrorIndicatorBuilder: (context) => const NoItemFound(),
          noItemsFoundIndicatorBuilder: (context) => const NoItemFound(),
          firstPageProgressIndicatorBuilder: (context) {
            loadData = false;
            SVProgressHUD.show();
            return Container();
          },
          newPageProgressIndicatorBuilder: (context) {
            loadData = false;
            SVProgressHUD.show();
            return Container();
          },
        ),
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }

  processData(int value, String title) {
    if (value == 200) {
      if (title == "bestRated") {
        items = searchController.bestRatedSalons.toList();
      } else {
        items = searchController.searchDetails.toList();
        getSearchSalonsList(items, title);
      }
      // ignore: unrelated_type_equality_checks
      if (items == 0) {
        setState(() {
          noResults = true;
        });
      }
    }
  }

  /* getRecommendedPager(bool istab) {
    return Expanded(
      child: PagedListView<int, RecommendedSalonsModel>.separated(
        padding: EdgeInsets.symmetric(
          horizontal: Get.height * 0.02,
          vertical: Get.height * 0.022,
        ),
        pagingController: _recopagingController,
        builderDelegate: PagedChildBuilderDelegate<RecommendedSalonsModel>(
          animateTransitions: true,
          itemBuilder: (context, item, index) => istab
              ? RecoCharacterListItem(character: item)
              : RecoCharacterCardItem(character: item),
          noItemsFoundIndicatorBuilder: (context) => const NoItemFound(),
        ),
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  } */

  getFloatingButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: Get.height * 0.02),
      child: FloatingActionButton.extended(
        onPressed: () {
          Get.to(SearchMapView(
            locationList: searchController.searchDetails,
          ));
        },
        label: Text('Map View'.tr),
        icon: const Icon(Icons.location_on),
        backgroundColor: Colr.primary,
      ),
    );
  }

  searchBarWidget(TextEditingController searchCntller, FocusNode focusNode) {
    return Row(children: [
      Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.04, vertical: Get.width * 0.02),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Get.width * 0.02)),
            child: Padding(
              padding: EdgeInsets.only(
                  right: Get.width * 0.02, left: Get.width * 0.04),
              child: TextFormField(
                textInputAction: TextInputAction.search,
                controller: searchCntller,
                focusNode: focusNode,
                onTap: () {
                  setState(() {
                    isSubCategorySelected = false;
                    bool status = false;
                    salononTapMode(status);
                  });
                },
                onChanged: (value) async {
                  // print("OnChange Value  - " + value.toString());
                  setState(() {
                    isSubCategorySelected = false;
                    bool status = value.isEmpty ? false : true;
                    salonEditMode(status);
                  });

                  if (value.length > 2) {
                    await searchController
                        .getSalonandSservices(value)
                        .then((value) {
                      setState(() {
                        allsearchCategory = searchController.allsearchCategory;
                        autoServicesSearchList.value = allsearchCategory;
                      });

                      log(allsearchCategory.toString());

                      if (allsearchCategory.isEmpty) {
                        allsearchCategory = searchController.allSearchDummy;
                      }
                    });
                  }
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search By Service/Salon'.tr,
                  hintStyle: const TextStyle(
                      color: Colors.black45,
                      fontSize: 18,
                      fontFamily: 'opensans',
                      fontWeight: FontWeight.w400),
                  suffixIcon: IconButton(
                    icon: (!isSalonEditing || searchCntller.text.isEmpty)
                        ? ImageIcon(
                            const AssetImage('assets/images/search.png'),
                            size: Get.width * 0.06,
                            color: Colors.black45,
                          )
                        : Icon(
                            Icons.close,
                            size: Get.width * 0.06,
                            color: Colors.grey,
                          ),
                    onPressed: () async {
                      if (isSalonEditing) {
                        searchCntller.text = "";
                        if (widget.searchKey != null) widget.searchKey = "";
                        setState(() {
                          isSalonEditing = false;
                          showSalonRecentSearch = true;
                          isRecentSalonSelected.value = false;
                        });
                      } else {
                        loadData = false;
                        _fetchPage(0);
                      }
                    },
                  ),
                ),
                onFieldSubmitted: (value) {
                  loadData = false;
                  _fetchPage(0);
                },
              ),
            ),
          ),
        ),
      )
    ]);
  }

  salonEditMode(bool isEditing) {
    isSalonEditing = isEditing;
    showSalonRecentSearch = !isEditing;
    isLocationEditing = isEditing;
    showLocationRecentSearch = !isEditing;
  }

  salononTapMode(bool isEditing) {
    isSalonEditing = isEditing;
    showSalonRecentSearch = !isEditing;
    isLocationEditing = isEditing;
    showLocationRecentSearch = isEditing;
  }

  locationEditMode(bool isEditing) {
    isLocationEditing = isEditing;
    showLocationRecentSearch = !isEditing;
    isSalonEditing = isEditing;
    showSalonRecentSearch = !isEditing;
  }

  locationOnTapMode(bool isEditing) {
    isLocationEditing = isEditing;
    showLocationRecentSearch = !isEditing;
    isSalonEditing = isEditing;
    showSalonRecentSearch = isEditing;
  }

  searchLocationWidget(
      TextEditingController locationController, FocusNode focusNode) {
    return Row(children: [
      Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.04, vertical: Get.width * 0.02),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Get.width * 0.02)),
            child: Padding(
              padding: EdgeInsets.only(
                  right: Get.width * 0.02, left: Get.width * 0.04),
              child: TextFormField(
                textInputAction: TextInputAction.search,
                controller: locationController,
                focusNode: focusNode,
                onTap: () {
                  setState(() {
                    locationOnTapMode(false);
                  });
                },
                onChanged: (value) async {
                  setState(() {
                    value.isNotEmpty
                        ? locationEditMode(true)
                        : locationEditMode(false);
                  });

                  if (value.length > 2) {
                    await searchController.getLocations(value).then((value) {
                      setState(() {
                        allsearchLocation = searchController.allsearchLocation;
                        autoLocationSearchList.value = allsearchLocation;
                      });

                      log(allsearchLocation.toString());

                      if (allsearchLocation.isEmpty) {
                        allsearchLocation = searchController.allSearchDummy;
                      }
                    });
                  }
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search By Location'.tr,
                  hintStyle: const TextStyle(
                      color: Colors.black45,
                      fontSize: 18,
                      fontFamily: 'opensans',
                      fontWeight: FontWeight.w400),
                  suffixIcon: IconButton(
                    icon:
                        (!isLocationEditing || _locationController.text.isEmpty)
                            ? ImageIcon(
                                const AssetImage('assets/images/search.png'),
                                size: Get.width * 0.06,
                                color: Colors.black45,
                              )
                            : Icon(
                                Icons.close,
                                size: Get.width * 0.06,
                                color: Colors.grey,
                              ),
                    onPressed: () async {
                      if (isLocationEditing) {
                        _locationController.text = "";
                        setState(() {
                          isLocationEditing = false;
                          showLocationRecentSearch = true;
                          isRecentLocationSelected.value = false;
                        });
                      } else {
                        loadData = false;
                        _fetchPage(0);
                      }
                    },
                  ),
                ),
                onFieldSubmitted: (value) {
                  loadData = false;
                  _fetchPage(0);
                },
              ),
            ),
          ),
        ),
      )
    ]);
  }

  // ignore: non_constant_identifier_names
  LocationWidget() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: EdgeInsets.only(
                    right: 8, left: MediaQuery.of(context).size.width * 0.04),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search By Location'.tr,
                    hintStyle: const TextStyle(
                        color: Colors.black45,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                    suffixIcon: IconButton(
                      icon: Row(
                        children: const [
                          Icon(
                            Icons.search,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  getRecommendationSalons() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            recommendedSalonsListTitle(),
            recommendedSalonsListWidget()
          ],
        ),
      ),
    );
  }

  //-----------Start SearchList

  getSearchSalonsList(List<SearchProductModel> searchDetails, String title) {
    searchSalonsListTitle(searchDetails, title);
    searchSalonsListWidget(searchDetails);
    /*  return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searchSalonsListTitle(searchDetails),
            searchSalonsListWidget(searchDetails),
          ],
        ),
      ),
    ); */
  }

  searchSalonsListTitle(List<SearchProductModel> searchDetails, String title) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.04, vertical: Get.width * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetX<HomeScreenController>(
                builder: (_) {
                  if (title == "") {
                    return CommenTextWidget(
                      s: "${'Results Found'.tr} : $resultCount",
                      size: 18,
                      fs: FontStyle.normal,
                      fw: FontWeight.bold,
                      clr: Colors.black,
                    );
                  } else {
                    return CommenTextWidget(
                      s: 'Reco Salons : '.tr + resultCount.toString(),
                      size: 18,
                      fs: FontStyle.normal,
                      fw: FontWeight.bold,
                      clr: Colors.black,
                    );
                  }
                },
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isTab = !isTab;
                  });
                },
                child: Container(
                  color: const Color.fromRGBO(211, 51, 69, 0.2),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.04,
                        vertical: Get.height * 0.008),
                    child: CommenTextWidget(
                      s: isTab ? 'Tab View'.tr : 'List View'.tr,
                      size: 12,
                      fs: FontStyle.normal,
                      fw: FontWeight.normal,
                      clr: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  searchSalonsListWidget(List<SearchProductModel> searchDetails) {
    return GetX<search.SearchController>(
      builder: (controller) => searchDetails.isNotEmpty
          ? getPager(isTab)
          : Padding(
              padding: EdgeInsets.only(top: Get.width / 5),
              child: Column(
                children: [
                  Container(
                    height: Get.height * 0.108,
                    width: Get.width * 0.445,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(),
                      image: DecorationImage(
                          image: AssetImage('assets/images/NoResults.png'),
                          opacity: 1.0,
                          fit: BoxFit.fill,
                          scale: 1.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Get.width * 0.037),
                    child: Center(
                      child: CommenTextWidget(
                        s: 'No Results Found'.tr,
                        size: 18,
                        fs: FontStyle.normal,
                        fw: FontWeight.bold,
                        clr: Colr.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  //-----------------End SearchList

  /*  getRecommendationSalonsList() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            recommendedSalonsListTitle(),
            recommendedSalonsListWidget(),
          ],
        ),
      ),
    );
  } */

  recommendedSalonsListTitle() {
    return Column(
      children: [
        Padding(
          // padding: EdgeInsets.symmetric(
          //     horizontal: Get.width * 0.04, vertical: Get.width * 0.03),
          padding: EdgeInsets.fromLTRB(
              Get.width * 0.04,
              (isSalonEditing || isLocationEditing) ? Get.width * 0.04 : 10,
              Get.width * 0.04,
              Get.width * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (isSalonEditing || isLocationEditing)
                  ? CommenTextWidget(
                      s: "${'Results Found'.tr} : $resultCount",
                      size: 18,
                      fs: FontStyle.values.first,
                      fw: FontWeight.bold,
                      clr: Colors.black,
                    )
                  : CommenTextWidget(
                      s: "${'Recommended Salons'.tr} : $resultCount",
                      size: 18,
                      fs: FontStyle.normal,
                      fw: FontWeight.bold,
                      clr: Colors.black,
                    ),
              (isSalonEditing || isLocationEditing)
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          isTab = !isTab;
                          getPager(isTab);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Get.height * 0.005),
                            color: const Color.fromRGBO(211, 51, 69, 0.2),
                            shape: BoxShape.rectangle),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.04,
                              vertical: Get.height * 0.008),
                          child: CommenTextWidget(
                            s: isTab ? 'Tab View'.tr : 'List View'.tr,
                            size: 12,
                            fs: FontStyle.normal,
                            fw: FontWeight.normal,
                            clr: Colors.black,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 0,
                    ),
            ],
          ),
        )
      ],
    );
  }

  /*  recommendedSalonsListWidget() {
    return GetX<SearchController>(
        builder: (controller) => controller.bestRatedSalons.isEmpty
            ? getPager(isTab)
            : noResultsFound());
  } */

  recommendedSalonsListWidget() {
    return getPager(isTab);
  }

  noResultsFound() {
    noResults = true;
    return Padding(
      padding: EdgeInsets.only(top: Get.width / 20),
      child: Column(
        children: [
          Container(
            height: Get.height * 0.108,
            width: Get.width * 0.445,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(),
              image: DecorationImage(
                  image: AssetImage('assets/images/Search1.png'),
                  opacity: 1.0,
                  fit: BoxFit.fill,
                  scale: 1.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Get.width * 0.037),
            child: Center(
              child: CommenTextWidget(
                s: 'No Results Found'.tr,
                size: 18,
                fs: FontStyle.normal,
                fw: FontWeight.bold,
                clr: Colr.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Icon circleIcon() {
    return const Icon(
      Icons.circle,
      size: 6,
      color: Colors.grey,
    );
  }

  // ignore: non_constant_identifier_names
  Services() {
    return SingleChildScrollView(
      padding:
          EdgeInsets.symmetric(horizontal: 0, vertical: Get.height * 0.024),
      scrollDirection: Axis.horizontal,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              List.generate(homeScreenController.categories.length, (index) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(Get.width * 0.023, 0, 0, 0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Get.height * 0.028),
                          color: (isServicesSelected &&
                                  isServicesSelectedIndex == index)
                              ? Colors.white
                              : Colr.primary,
                          shape: BoxShape.rectangle),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Get.width * 0.04,
                            vertical: Get.width * 0.016),
                        child: InkWell(
                          onTap: () {
                            Get.off(SubCategoryScreen(
                                categoryId:
                                    homeScreenController.categories[index].id,
                                categoryName:
                                    homeScreenController.categories[index].name,
                                categoryNameH: homeScreenController
                                    .categories[index].categoryNameH));
                          },
                          splashColor: Colors.blue,
                          child: Text(
                            localizationController.isHebrew.value
                                ? homeScreenController
                                    .categories[index].categoryNameH
                                : homeScreenController.categories[index].name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'opensans',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]);
          })),
    );
  }

  recentSalonSearch() {
    return Visibility(
      visible: showSalonRecentSearch && !isRecentSalonSelected.value,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                showSalonRecentSearch
                    ? recentSalonList.length + 1
                    : recentLocationList.length + 1, (index) {
              return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: index != 0
                          ? recentTextFormField(index)
                          : ((recentSalonList.isNotEmpty ||
                                      recentLocationList.isNotEmpty) &&
                                  showSalonRecentSearch)
                              ? recentSearchTitle()
                              : Container(
                                  height: 0,
                                ),
                    ),
                  ),
                ),
              ]);
            })),
      ),
    );
  }

  recentTextFormField(int index) {
    return TextFormField(
      onTap: () {
        _searchController.text = recentSalonList[index - 1];
        setState(() {
          showSalonRecentSearch = false;
          isSalonEditing = true;
          isRecentSalonSelected.value = true;
          FocusManager.instance.primaryFocus?.unfocus();
          loadData = false;

          _fetchPage(0);
        });
      },
      readOnly: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: showSalonRecentSearch
            ? recentSalonList[index - 1]
            : recentLocationList[index - 1],
        hintStyle: const TextStyle(
            color: Colors.black45,
            fontFamily: 'opensans',
            fontSize: 18,
            fontWeight: FontWeight.w500),
        prefixIcon: IconButton(
          icon: ImageIcon(
            const AssetImage('assets/images/search.png'),
            size: Get.width * 0.06,
            color: Colors.black45,
          ),
          onPressed: () async {},
        ),
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
          onPressed: () async {},
        ),
      ),
    );
  }

  suggestedTextFormField(TextEditingController txtController, String option) {
    return TextFormField(
      onTap: () {
        txtController.text = option;
        if (txtController == _searchController) {
          setState(() {
            showSalonRecentSearch = false;
            isSalonEditing = true;
            isRecentSalonSelected.value = true;
            FocusManager.instance.primaryFocus?.unfocus();
            loadData = false;
          });
          addSalonSearch(option);
          _fetchPage(0);
        } else {
          setState(() {
            showLocationRecentSearch = false;
            isLocationEditing = true;
            isRecentLocationSelected.value = true;
            FocusManager.instance.primaryFocus?.unfocus();
            loadData = false;
          });
          addLocationSearch(option);
          _fetchPage(0);
        }
      },
      readOnly: true,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: option,
        hintStyle: const TextStyle(
            color: Colors.black45,
            fontFamily: 'opensans',
            fontSize: 18,
            fontWeight: FontWeight.w500),
        prefixIcon: IconButton(
          icon: ImageIcon(
            const AssetImage('assets/images/search.png'),
            size: Get.width * 0.06,
            color: Colors.black45,
          ),
          onPressed: () async {},
        ),
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
          onPressed: () async {},
        ),
      ),
    );
  }

  recentLocationSearch() {
    return Visibility(
      visible: showLocationRecentSearch && !isRecentLocationSelected.value,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(recentLocationList.length + 1, (index) {
              return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: index != 0
                          ? TextFormField(
                              onTap: () {
                                _locationController.text =
                                    recentLocationList[index - 1];
                                setState(() {
                                  isLocationEditing = true;
                                  showLocationRecentSearch = false;
                                  isRecentLocationSelected.value = true;
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  loadData = false;
                                  _fetchPage(0);
                                });
                              },
                              readOnly: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: recentLocationList[index - 1],
                                hintStyle: const TextStyle(
                                    color: Colors.black45,
                                    fontFamily: 'opensans',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                                prefixIcon: IconButton(
                                  icon: ImageIcon(
                                    const AssetImage(
                                        'assets/images/search.png'),
                                    size: Get.width * 0.06,
                                    color: Colors.black45,
                                  ),
                                  onPressed: () async {},
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () async {},
                                ),
                              ),
                            )
                          : /* ((recentLocationList.length > 0) &&
                                  showLocationRecentSearch)
                              ? recentSearchTitle()
                              : Container(), */
                          recentSearchTitle(),
                    ),
                  ),
                ),
              ]);
            })),
      ),
    );
  }

  recentSearchTitle() {
    if ((recentSalonList.isNotEmpty || recentLocationList.isNotEmpty) &&
        (showSalonRecentSearch || showLocationRecentSearch)) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommenTextWidget(
                  s: 'Recent Search'.tr,
                  size: 18,
                  fs: FontStyle.normal,
                  fw: FontWeight.bold,
                  clr: Colors.black,
                ),
                InkWell(
                  onTap: () {
                    if (showSalonRecentSearch == true) clearRecentSalonSearch();
                    if (showLocationRecentSearch == true) {
                      clearRecentLocationSearch();
                    }
                  },
                  child: Container(
                    height: Get.height * 0.032,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Get.height * 0.005),
                      color: const Color.fromRGBO(211, 51, 69, 0.2),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          Get.width * 0.05,
                          Get.height * 0.005,
                          Get.width * 0.05,
                          Get.height * 0.005),
                      child: CommenTextWidget(
                        s: 'CLEAR'.tr,
                        size: 12,
                        fs: FontStyle.normal,
                        fw: FontWeight.normal,
                        clr: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }
  }
}
