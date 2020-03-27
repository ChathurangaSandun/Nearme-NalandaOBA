class GraphQlQueryHelper {
  // get nearest persons
  String getNearestPersons(
      double latitude, double longtitude, int organizationId) {
    String qry = """{
    nearestLocations(latitude: $latitude, longtitude: $longtitude, organizationId: $organizationId){
      id
      name
      mobile
      imageUri
      pointList{
        latitude
        longtitude
        type
        address
      }
    }
    }""";

    return qry;
  }
}
