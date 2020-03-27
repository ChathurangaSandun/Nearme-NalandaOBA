import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearmenalandaoba/components/pointlocation_listitem.dart';
import 'package:nearmenalandaoba/models/person.dart';
import 'package:pk_skeleton/pk_skeleton.dart';

class PointLocationList extends StatelessWidget {
  List<Person> nearestLocations = List<Person>();
  final Function changeGoogleMapMarkercamera;
  bool isLoadingNearestLocations = false;
  final LatLng initLatLng;

  PointLocationList(
      {this.nearestLocations,
      this.changeGoogleMapMarkercamera,
      this.isLoadingNearestLocations,
      this.initLatLng});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Positioned(
      bottom: -25,
      child: SizedBox(
        width: screenWidth,
        height: screenHeight * 0.4,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24.0),
          height: MediaQuery.of(context).size.height * 0.3,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: nearestLocations.length,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Container(
                    child: !isLoadingNearestLocations
                        ? PKCardSkeleton(
                            isCircularImage: true,
                            isBottomLinesActive: true,
                          )
                        : PointLocationListItem(
                            person: nearestLocations[index],
                            changeGoogleMapMarkercamera:
                                changeGoogleMapMarkercamera,
                            initLatLng: initLatLng,
                          ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
