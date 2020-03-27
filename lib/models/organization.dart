import 'package:flutter/foundation.dart';

class Organization {
  int id;
  String name;
  String details;

  Organization({
    @required this.id,
    @required this.name,
    this.details,
  });
}
