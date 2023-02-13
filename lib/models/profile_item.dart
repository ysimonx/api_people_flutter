import 'dart:convert';

List<ProfileItem> profileItemsFromJson(String str) => List<ProfileItem>.from(
    json.decode(str).map((x) => ProfileItem.fromJson(x)));

class ProfileItem {
  dynamic id;
  String name;

  ProfileItem({this.id, required this.name});

  factory ProfileItem.fromJson(Map<String, dynamic> json) =>
      ProfileItem(id: json["id"], name: json["name"]);
}
