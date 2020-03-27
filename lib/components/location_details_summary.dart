import 'package:flutter/material.dart';
import 'package:nearmenalandaoba/components/separator.dart';
import 'package:nearmenalandaoba/components/text_styles.dart';
import 'package:nearmenalandaoba/helper/application_helpers.dart';
import 'package:nearmenalandaoba/models/person.dart';
import 'package:nearmenalandaoba/models/pointLocationTypeEnum.dart';
import 'package:nearmenalandaoba/screens/place_details_screen.dart';

class PlanetSummary extends StatelessWidget {
  final Person person;
  final bool horizontal;

  PlanetSummary({this.horizontal = true, this.person});

  //PlanetSummary.vertical(this.planet): horizontal = false;

  @override
  Widget build(BuildContext context) {
    final planetThumbnail = new Container(
      margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment:
          horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
      child: new Hero(
        tag: "planet-hero-1",
        child: new Image(
          image: new AssetImage("assets/avatar.png"),
          height: 92.0,
          width: 92.0,
        ),
      ),
    );

    final planetCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(
          horizontal ? 76.0 : 16.0, horizontal ? 16.0 : 42.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment:
            horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(this.person.name, style: Style.titleTextStyle),
          new Separator(),
          new Container(height: 10.0),
          new Text(
              ApplicationHelper.getHomeAddressFromPointList(
                  this.person.pointLocations, PointTypes.Home),
              style: Style.commonTextStyle),
          new Container(height: 4.0),
          new Text(this.person.mobile, style: Style.commonTextStyle),
        ],
      ),
    );

    final planetCard = new Container(
      child: planetCardContent,
      height: horizontal ? 124.0 : 154.0,
      margin: horizontal
          ? new EdgeInsets.only(left: 46.0)
          : new EdgeInsets.only(top: 72.0),
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
        onTap: horizontal
            ? () => Navigator.of(context).push(
                  new PageRouteBuilder(
                    pageBuilder: (_, __, ___) => new DetailPage(),
                    transitionsBuilder: (context, animation, secondaryAnimation,
                            child) =>
                        new FadeTransition(opacity: animation, child: child),
                  ),
                )
            : null,
        child: new Container(
          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 24.0,
          ),
          child: new Stack(
            children: <Widget>[
              planetCard,
              planetThumbnail,
            ],
          ),
        ));
  }
}
