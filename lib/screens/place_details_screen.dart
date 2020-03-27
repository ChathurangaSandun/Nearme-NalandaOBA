import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearmenalandaoba/helper/application_helpers.dart';
import 'package:nearmenalandaoba/helper/ui_helper.dart';
import 'package:nearmenalandaoba/models/person.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nearmenalandaoba/models/pointLocationTypeEnum.dart';
import 'package:nearmenalandaoba/models/pointlocation.dart';
import 'package:nearmenalandaoba/screens/onboarding_screen.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  final Person person;
  final LatLng initLatLong;
  BuildContext scaffoldContext;
  DetailPage({this.person, this.initLatLong});

  @override
  Widget build(BuildContext context) {
    final Color color1 = Color(0xFF59C2FF);
    final Color color2 = Color(0xFF1270E3);
    //final String image = avatars[0];
    final String homeAddress = ApplicationHelper.getHomeAddressFromPointList(
        this.person.pointLocations, PointTypes.Home);
    final String companyAddress =
        ApplicationHelper.getCompanyAddressFromPointList(
            this.person.pointLocations, PointTypes.Company);

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  height: 360,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50.0),
                          bottomRight: Radius.circular(50.0)),
                      gradient: LinearGradient(colors: [
                        color1,
                        color2,
                      ])),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 80),
                  child: Column(
                    children: <Widget>[
                      Text(
                        this.person.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: screenHeight * 0.4,
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                  left: 30.0, right: 30.0, top: 10.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: Image.network(
                                    (this.person.imageUri != null ||
                                            this.person.imageUri != '')
                                        ? this.person.imageUri
                                        : 'https://www.w3schools.com/howto/img_avatar.png',
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            // Container(
                            //   alignment: Alignment.topCenter,
                            //   child: Container(
                            //     padding: const EdgeInsets.symmetric(
                            //         horizontal: 10.0, vertical: 5.0),
                            //     decoration: BoxDecoration(
                            //         color: Colors.yellow,
                            //         borderRadius: BorderRadius.circular(20.0)),
                            //     child: Text("3.7mi away"),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        this.person.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      Visibility(
                        visible: (homeAddress != '' || homeAddress != null),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.home,
                              size: 16.0,
                              color: Colors.grey,
                            ),
                            Text(
                              homeAddress,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Visibility(
                        visible:
                            (companyAddress != '' || companyAddress != null),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.work,
                              size: 16.0,
                              color: Colors.grey,
                            ),
                            Text(
                              companyAddress,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            color: Colors.grey,
                            icon: Icon(FontAwesomeIcons.instagram),
                            onPressed: () {
                              showSnackBar(this.scaffoldContext,
                                  'This is not implemented');
                            },
                          ),
                          IconButton(
                            color: Colors.grey,
                            icon: Icon(FontAwesomeIcons.facebookF),
                            onPressed: () {
                              showSnackBar(this.scaffoldContext,
                                  'This is not implemented');
                            },
                          ),
                          IconButton(
                            color: Colors.grey.shade600,
                            icon: Icon(FontAwesomeIcons.twitter),
                            onPressed: () {
                              showSnackBar(this.scaffoldContext,
                                  'This is not implemented');
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 16.0),
                              margin: const EdgeInsets.only(
                                  top: 30,
                                  left: 20.0,
                                  right: 20.0,
                                  bottom: 20.0),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    color2,
                                    color1,
                                  ]),
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                      color: Colors.white,
                                      icon: Icon(Icons.navigation),
                                      onPressed: () async {
                                        await navigatePointLocation(
                                            this.person.pointLocations);
                                      }),
                                  IconButton(
                                    color: Colors.white,
                                    icon: Icon(Icons.email),
                                    onPressed: () {
                                      UrlLauncher.launch(
                                          'mailto:wacsk19921002@gmail.com');
                                    },
                                  ),
                                  Spacer(),
                                  IconButton(
                                    color: Colors.white,
                                    icon: Icon(Icons.message),
                                    onPressed: () {
                                      UrlLauncher.launch(
                                          'sms::${this.person.mobile.toString()}');
                                    },
                                  ),
                                  IconButton(
                                    color: Colors.white,
                                    icon: Icon(Icons.add_call),
                                    onPressed: () {
                                      showSnackBar(this.scaffoldContext,
                                          'This is not implemented');
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: FloatingActionButton(
                                child: Icon(
                                  Icons.call,
                                  color: Colors.green,
                                ),
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  UrlLauncher.launch(
                                      'tel:${this.person.mobile.toString()}');
                                },
                              ),
                            ),
                            new Builder(builder: (BuildContext context) {
                              scaffoldContext = context;
                              return new Center();
                            })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  // title: Text("Person Details"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void showSnackBar(BuildContext context, String value) {
    SnackBar snackBar = SnackBar(
      content: Text(value),
      action: SnackBarAction(
        label: "Cancel",
        onPressed: () {},
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigatePointLocation(List<PointLocation> points) async {
    PointLocation homePoint = null;
    PointLocation companyPoint = null;
    points.forEach((PointLocation point) {
      if (point.type == 'HOME') {
        homePoint = point;
      }

      if (point.type == 'COMPANY') {
        companyPoint = point;
      }
    });

    if (homePoint != null && companyPoint != null) {
      String origin = "${companyPoint.latitude},${companyPoint.latitude}";
      String destination = "${homePoint.latitude},${homePoint.latitude}";

      String url = "https://www.google.com/maps/dir/?api=1&origin=" +
          origin +
          "&destination=" +
          destination +
          "&travelmode=driving&dir_action=navigate";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        this.showSnackBar(
            this.scaffoldContext, 'Could not launch google locations');
      }
    } else {
      showSnackBar(
          this.scaffoldContext, 'Cannot found home or company address.');
    }
  }
}
