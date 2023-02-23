import 'dart:convert';

List<Profile> profileItemsFromJson(String str) =>
    List<Profile>.from(json.decode(str).map((x) => Profile.fromJson(x)));

class Profile {
  dynamic id;
  String name;

  Profile({this.id, required this.name});

  factory Profile.fromJson(Map<String, dynamic> json) =>
      Profile(id: json["id"], name: json["name"]);
}
