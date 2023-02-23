import 'dart:convert';

List<Gallery> galleryItemsFromJson(String str) =>
    List<Gallery>.from(json.decode(str).map((x) => Gallery.fromJson(x)));

class Gallery {
  dynamic id;

  Gallery({this.id});

  factory Gallery.fromJson(Map<String, dynamic> json) =>
      Gallery(id: json["id"]);
}
