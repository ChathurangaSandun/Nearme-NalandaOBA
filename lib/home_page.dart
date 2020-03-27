import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:nearmenalandaoba/helper/graphQL_api_client_helper.dart';
import 'package:nearmenalandaoba/helper/graphql_query_helper.dart';
import 'package:nearmenalandaoba/models/person.dart';
import 'components/components.dart';
import 'components/pointlocation_listview.dart';
import 'configurations/graphQLConfiguration.dart';
import 'helper/ui_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/pointlocation.dart';

class GoogleMapPage extends StatefulWidget {
  GoogleMapPage();

  @override
  State<StatefulWidget> createState() {
    return _GoogleMapState();
  }
}

class _GoogleMapState extends State<GoogleMapPage>
    with TickerProviderStateMixin {
  AnimationController animationControllerExplore;
  AnimationController animationControllerSearch;
  AnimationController animationControllerMenu;
  CurvedAnimation curve;
  Animation<double> animation;
  Animation<double> animationW;
  Animation<double> animationR;
  bool isCreatedMap = false;
  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  GraphQLApiClient _graphQLClient = GraphQLApiClient();
  GraphQlQueryHelper _graphQLQeuryHelper = GraphQlQueryHelper();
  List<Person> nearestPointLocations = [
    Person(),
    Person(),
    Person(),
    Person(),
    Person()
  ];
  bool isLoadingNearestLocations = false;
  Marker selectedLocationMarker = new Marker();

  static int selectedOranizationId = 1;

  static LatLng _initialPosition;
  final List<Marker> _markers = List<Marker>();
  static LatLng _lastMapPosition = _initialPosition;
  BitmapDescriptor _myIcon;
  //google map
  Completer<GoogleMapController> _mapController = Completer();
  

  /// get currentOffset percent
  get currentExplorePercent =>
      max(0.0, min(1.0, offsetExplore / (760.0 - 122.0)));
  get currentSearchPercent => max(0.0, min(1.0, offsetSearch / (347 - 68.0)));
  get currentMenuPercent => max(0.0, min(1.0, offsetMenu / 358));

  var offsetExplore = 0.0;
  var offsetSearch = 0.0;
  var offsetMenu = 0.0;

  bool isExploreOpen = false;
  bool isSearchOpen = false;
  bool isMenuOpen = false;

  // google map
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(6.913452, 79.854703),
    zoom: 14.0,
  );

  /// search drag callback
  void onSearchHorizontalDragUpdate(details) {
    offsetSearch -= details.delta.dx;
    if (offsetSearch < 0) {
      offsetSearch = 0;
    } else if (offsetSearch > (347 - 68.0)) {
      offsetSearch = 347 - 68.0;
    }
    setState(() {});
  }

  /// explore drag callback
  void onExploreVerticalUpdate(details) {
    offsetExplore -= details.delta.dy;
    if (offsetExplore > 644) {
      offsetExplore = 644;
    } else if (offsetExplore < 0) {
      offsetExplore = 0;
    }
    setState(() {});
  }

  /// animate Explore
  ///
  /// if [open] is true , make Explore open
  /// else make Explore close
  void animateExplore(bool open) {
    animationControllerExplore = AnimationController(
        duration: Duration(
            milliseconds: 1 +
                (800 *
                        (isExploreOpen
                            ? currentExplorePercent
                            : (1 - currentExplorePercent)))
                    .toInt()),
        vsync: this);
    curve =
        CurvedAnimation(parent: animationControllerExplore, curve: Curves.ease);
    animation = Tween(begin: offsetExplore, end: open ? 760.0 - 122 : 0.0)
        .animate(curve)
          ..addListener(() {
            setState(() {
              offsetExplore = animation.value;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              isExploreOpen = open;
            }
          });
    animationControllerExplore.forward();
  }

  void animateSearch(bool open) {
    animationControllerSearch = AnimationController(
        duration: Duration(
            milliseconds: 1 +
                (800 *
                        (isSearchOpen
                            ? currentSearchPercent
                            : (1 - currentSearchPercent)))
                    .toInt()),
        vsync: this);
    curve =
        CurvedAnimation(parent: animationControllerSearch, curve: Curves.ease);
    animation = Tween(begin: offsetSearch, end: open ? 347.0 - 68.0 : 0.0)
        .animate(curve)
          ..addListener(() {
            setState(() {
              offsetSearch = animation.value;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              isSearchOpen = false;
            }
          });
    animationControllerSearch.forward();
  }

  void animateMenu(bool open) {
    animationControllerMenu =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    curve =
        CurvedAnimation(parent: animationControllerMenu, curve: Curves.ease);
    animation =
        Tween(begin: open ? 0.0 : 358.0, end: open ? 358.0 : 0.0).animate(curve)
          ..addListener(() {
            setState(() {
              offsetMenu = animation.value;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              isMenuOpen = open;
            }
          });
    animationControllerMenu.forward();
  }

  onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    if (!isCreatedMap) {
      changeGoogleMapStyle();
    }

    return Scaffold(
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: <Widget>[
            GoogleMap(
              markers: _markers.toSet(),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
                isCreatedMap = true;
                changeGoogleMapStyle();
              },
            ),
            PointLocationList(
              nearestLocations: nearestPointLocations,
              changeGoogleMapMarkercamera: _changeGoogleMapMakerCamera,
              isLoadingNearestLocations: isLoadingNearestLocations,
              initLatLng: _initialPosition,
            ),
            //blur
            offsetSearch != 0
                ? BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 10 * currentSearchPercent,
                        sigmaY: 10 * currentSearchPercent),
                    child: Container(
                      color:
                          Colors.white.withOpacity(0.1 * currentSearchPercent),
                      width: screenWidth,
                      height: screenHeight,
                    ),
                  )
                : const Padding(
                    padding: const EdgeInsets.all(0),
                  ),
            //explore content

            //recent search
            RecentSearchWidget(
              currentSearchPercent: currentSearchPercent,
            ),
            //search
            SearchWidget(
              currentSearchPercent: currentSearchPercent,
              currentExplorePercent: currentExplorePercent,
              isSearchOpen: isSearchOpen,
              animateSearch: animateSearch,
              onHorizontalDragUpdate: onSearchHorizontalDragUpdate,
              onPanDown: () => animationControllerSearch?.stop(),
              getDirectionFromSelectedLocation:
                  _getDirectionFromSelectedLocation,
            ),
            //search back
            SearchBackWidget(
              currentSearchPercent: currentSearchPercent,
              animateSearch: animateSearch,
            ),
            //directions button
            // MapButton(
            //   currentSearchPercent: currentSearchPercent,
            //   currentExplorePercent: currentExplorePercent,
            //   bottom: realH(250),
            //   offsetX: -68,
            //   width: 68,
            //   height: 71,
            //   icon: Icons.directions,
            //   iconColor: Colors.white,
            //   gradient: const LinearGradient(colors: [
            //     Color(0xFF59C2FF),
            //     Color(0xFF1270E3),
            //   ]),
            //   doAction: () => _getDirection(56, 45, 1),
            // ),
            //my_location button
            MapButton(
              currentSearchPercent: currentSearchPercent,
              currentExplorePercent: currentExplorePercent,
              bottom: realH(150),
              offsetX: -68,
              width: 68,
              height: 71,
              icon: Icons.my_location,
              iconColor: Colors.blue,
              doAction: _getCurrentMyLocation,
            ),

            // //menu button
            // Positioned(
            //   top: realH(50),
            //   left: realW(-71 * (currentExplorePercent + currentSearchPercent)),
            //   child: GestureDetector(
            //     onTap: () {
            //       animateMenu(true);
            //     },
            //     child: Opacity(
            //       opacity: 1 - (currentSearchPercent + currentExplorePercent),
            //       child: Container(
            //         width: realW(71),
            //         height: realH(71),
            //         alignment: Alignment.centerLeft,
            //         padding: EdgeInsets.only(left: realW(17)),
            //         child: Icon(
            //           Icons.menu,
            //           size: realW(34),
            //         ),
            //         decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.only(
            //                 bottomRight: Radius.circular(realW(36)),
            //                 topRight: Radius.circular(realW(36))),
            //             boxShadow: [
            //               BoxShadow(
            //                   color: Color.fromRGBO(0, 0, 0, 0.3),
            //                   blurRadius: realW(36)),
            //             ]),
            //       ),
            //     ),
            //   ),
            // ),
            //menu
            MenuWidget(
              currentMenuPercent: currentMenuPercent,
              animateMenu: animateMenu,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);
    _getUserLocation();

    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(128, 128)),
            'assets/icons8-user-location.png')
        .then((onValue) {
      _myIcon = onValue;
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationControllerExplore?.dispose();
    animationControllerSearch?.dispose();
    animationControllerMenu?.dispose();
  }

  void changeGoogleMapStyle() async {
    await getJsonFile("assets/light.json").then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) async {
    // https://www.youtube.com/watch?v=XAowXcmQ-kA
    final GoogleMapController controller = await _mapController.future;
    controller.setMapStyle(mapStyle);
  }

  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);

    if (this.mounted) {
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
        print('${placemark[0].name}');
        print(position.latitude.toString());
        print(position.longitude.toString());
      });

      await _getCurrentMyLocation();
    }
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  Future _getCurrentMyLocation() async {
    this.selectedLocationMarker = Marker(
      markerId: MarkerId("curr_loc"),
      position: LatLng(_initialPosition.latitude, _initialPosition.longitude),
      infoWindow: InfoWindow(title: 'Your Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );
    
    await _changeGoogleMapMakerCamera(
        _initialPosition.latitude, _initialPosition.longitude, 13.0);

    await _getDirection(_initialPosition.latitude, _initialPosition.longitude,
        selectedOranizationId);
  }

  _changeGoogleMapMakerCamera(
      double latitude, double longtitude, double zoom) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(latitude, longtitude),
      zoom: zoom,
      //tilt: 50.0,
    )));
  }

  void _getDirectionFromSelectedLocation(
      double latitude, double longtitude) async {
    this.selectedLocationMarker = Marker(
      markerId: MarkerId('SELECTED_LOCATION_MERKER'),
      position: LatLng(latitude, longtitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    print(_markers);
    await this._getDirection(latitude, longtitude, selectedOranizationId);
    await _changeGoogleMapMakerCamera(latitude, longtitude, 13.0);
  }

  Future _getDirection(
      double latitude, double longtitude, int organizationId) async {
    setState(() {
      this.isLoadingNearestLocations = false;
      _markers.clear();
      _markers.add(this.selectedLocationMarker);
      nearestPointLocations = [
        Person(),
        Person(),
        Person(),
        Person(),
        Person(),
      ];
    });
    QueryResult result = await _graphQLClient.execute(_graphQLQeuryHelper
        .getNearestPersons(latitude, longtitude, organizationId));
    List<Person> persons = List<Person>();
    List<Marker> nearestMakers = List<Marker>();

    if (!result.hasException) {
      var resultList = Data.fromJson(result.data);
      resultList.nearestLocations.forEach((person) {
        persons.add(person);

        person.pointLocations.forEach((point) {
          final bitmapIcon = BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(16, 16)), 'assets/marker.png');

          // create marks
          final marker = Marker(
            markerId: MarkerId(person.name + '_' + point.type),
            position: LatLng(point.latitude, point.longtitude),
            infoWindow: InfoWindow(
              title: person.name + ' ' + point.type.toLowerCase(),
              snippet: person.mobile,
            ),
            //icon: bitmapIcon,
          );
          nearestMakers.add(marker);
        });
      });

      setState(() {
        print(_markers.length);
        this.isLoadingNearestLocations = true;
        nearestPointLocations = persons;
        _markers.addAll(nearestMakers);
        print(_markers.length);
      });
    }
  }
}
