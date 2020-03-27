import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearmenalandaoba/helper/application_helpers.dart';
import 'package:nearmenalandaoba/models/person.dart';
import 'package:nearmenalandaoba/models/pointLocationTypeEnum.dart';
import 'package:nearmenalandaoba/models/pointlocation.dart';
import 'package:nearmenalandaoba/screens/place_details_screen.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class PointLocationListItem extends StatelessWidget {
  Person person = Person();
  final LatLng initLatLng;
  final Function changeGoogleMapMarkercamera;

  PointLocationListItem(
      {this.person, this.changeGoogleMapMarkercamera, this.initLatLng});

  @override
  Widget build(BuildContext context) {
    final planetThumbnail = new Container(
      margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment: FractionalOffset.centerLeft,
      child: CircleAvatar(
        backgroundImage: NetworkImage(this.person.imageUri != null
            ? this.person.imageUri
            : 'https://www.w3schools.com/howto/img_avatar.png'),
        radius: 48,
      ),
    );

    final baseTextStyle = const TextStyle(fontFamily: 'Poppins');
    final regularTextStyle = baseTextStyle.copyWith(
        color: const Color(0xffb6b2df),
        fontSize: 9.0,
        fontWeight: FontWeight.w400);
    final subHeaderTextStyle =
        regularTextStyle.copyWith(fontSize: 14.0, fontWeight: FontWeight.w600);
    final headerTextStyle = baseTextStyle.copyWith(
        color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600);

    Widget _planetValue({String value, String image}) {
      return GestureDetector(
        onTap: () {
          // changeGoogleMapMarkercamera(this.person.pointLocation.latitude,
          //     this.person.pointLocation.longtitude, 15.0);
        },
        child: new Row(children: <Widget>[
          new Image.asset(image, height: 12.0),
          new Container(width: 8.0),
          new Text('35.69', style: regularTextStyle),
        ]),
      );
    }

    final planetCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(76.0, 16.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height: 4.0),
          Text(
              this.person.name.length > 20
                  ? this.person.name.substring(0, 20) + "..."
                  : this.person.name,
              style: headerTextStyle),
          Container(
              margin: new EdgeInsets.symmetric(vertical: 8.0),
              height: 2.0,
              width: 36.0,
              color: new Color(0xff00c6ff)),
          Container(height: 5.0),
          Text(
              getCityFromAddress(
                ApplicationHelper.getHomeAddressFromPointList(
                    this.person.pointLocations, PointTypes.Home),
              ),
              style: subHeaderTextStyle),
          Container(height: 5.0),
          Text(this.person.mobile, style: subHeaderTextStyle),
          Container(height: 5.0),
          Row(
            children: <Widget>[
              ActionChip(
                  label: Text(
                    'Call',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green[600],
                  onPressed: () {
                    UrlLauncher.launch('tel:${this.person.mobile.toString()}');
                  }),
              Container(width: 10),
              ActionChip(
                  label: Text(
                    'More',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blueAccent,
                  onPressed: () {
                    Navigator.of(context).push(new PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new DetailPage(
                        person: this.person,
                        initLatLong: initLatLng,
                      ),
                    ));
                  })
            ],
          )
        ],
      ),
    );

    final planetCard = new Container(
      child: planetCardContent,
      height: 280.0,
      margin: new EdgeInsets.only(left: 46.0),
      decoration: new BoxDecoration(
        color: new Color(0xFF333366),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
    );

    return new GestureDetector(
        onTap: () => {},
        child: new Container(
          height: 120.0,
          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 12.0,
          ),
          child: new Stack(
            children: <Widget>[
              planetCard,
              planetThumbnail,
            ],
          ),
        ));
  }

  String getCityFromAddress(String address) {
    var addressList = address.split(',');
    return addressList.length > 0
        ? addressList[addressList.length - 1].trim()
        : address.length > 20
            ? address.substring(0, 20).trim() + "..."
            : address;
  }
}
