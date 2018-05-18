class UserSource {

  String gender;
  String email;
  String picture;
  String first;
  String last;
  String street;
  String city;
  String state;
  String postcode;

  UserSource.fromMap(Map<String, dynamic> map)
      :
        gender = map["gender"],
        email = map["email"],
        picture = map["picture"]["large"],
        first = map["name"]["first"],
        last = map["name"]["last"],
        street = map["location"] != null ? map["location"]["street"]  : null,
        city = map["location"] != null ? map["location"]["city"]  : null,
        state = map["location"] != null ? map["location"]["state"]  : null,
        postcode = map["location"] != null ? map["location"]["postcode"].toString() : null;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map["gender"] = gender;
    map["email"] = email;

    Map large = new Map();
    large["large"] = picture;
    map["picture"] = large;

    Map nameMap = new Map();
    nameMap["first"] = first;
    nameMap["last"] = last;
    map["name"] = nameMap;

    Map locationMap = new Map();
    locationMap["street"] = street;
    locationMap["city"] = city;
    locationMap["state"] = state;
    locationMap["postcode"] = postcode;
    map["location"] = locationMap;

    return map;
  }
}