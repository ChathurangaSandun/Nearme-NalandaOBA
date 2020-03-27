import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import '../helper/ui_helper.dart';

const kGoogleApiKey = "AIzaSyCE_9fNS6xY5Rn3EJU_gRhuUwQ_9BAls_8";

// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class SearchWidget extends StatelessWidget {
  final double currentExplorePercent;

  final double currentSearchPercent;

  final Function(bool) animateSearch;

  final bool isSearchOpen;

  final Function(DragUpdateDetails) onHorizontalDragUpdate;

  final Function() onPanDown;

  final Function(double, double) getDirectionFromSelectedLocation;

  const SearchWidget(
      {Key key,
      this.currentExplorePercent,
      this.currentSearchPercent,
      this.animateSearch,
      this.isSearchOpen,
      this.onHorizontalDragUpdate,
      this.onPanDown,
      this.getDirectionFromSelectedLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: realH(50),
      right: realW((68.0 - 320) -
          (68.0 * currentExplorePercent) +
          (347 - 68.0) * currentSearchPercent),
      child: GestureDetector(
        onTap: () async {
          //animateSearch(!isSearchOpen);
          Prediction p = await PlacesAutocomplete.show(
            context: context,
            apiKey: kGoogleApiKey,
            onError: onError,
            mode: Mode.overlay,
            language: "si",
            components: [Component(Component.country, "LK")],
          );

          displayPrediction(p, homeScaffoldKey.currentState);
        },
        onPanDown: (_) => onPanDown,
        onHorizontalDragUpdate: onHorizontalDragUpdate,
        onHorizontalDragEnd: (_) {
          _dispatchSearchOffset();
        },
        child: Container(
          width: realW(320),
          height: realH(71),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: realW(17)),
          child: Opacity(
            opacity: 1.0 - currentSearchPercent,
            child: Icon(
              Icons.search,
              size: realW(34),
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(realW(36))),
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.3), blurRadius: realW(36)),
              ]),
        ),
      ),
    );
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  
Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
  if (p != null) {
    // get detail (lat/lng)
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;

    print("lat - " + lat.toString());
    print("lng - " + lng.toString());

    this.getDirectionFromSelectedLocation(lat, lng);
    
  }
}

  /// dispatch Search state
  ///
  /// handle it by [isSearchOpen] and [currentSearchPercent]
  void _dispatchSearchOffset() {
    if (!isSearchOpen) {
      if (currentSearchPercent < 0.3) {
        animateSearch(false);
      } else {
        animateSearch(true);
      }
    } else {
      if (currentSearchPercent > 0.6) {
        animateSearch(true);
      } else {
        animateSearch(false);
      }
    }
  }
}
