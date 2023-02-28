import 'dart:convert';

import 'package:api_people_flutter/models/profile_model.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class ProfileProvider with ChangeNotifier {
  List<Profile> _items = [];
  final url = 'https://api-dev.onlyfemme.fr/api/v1/profile';

  List<Profile> get items {
    return [..._items];
  }

  Future<void> addProfile(String name) async {
    if (name.isEmpty) {
      return;
    }
    Map<String, dynamic> request = {"name": name};
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(request));
    Map<String, dynamic> responsePayload = json.decode(response.body);
    final people =
        Profile(id: responsePayload["id"], name: responsePayload["name"]);
    _items.add(people);
    notifyListeners();
  }

  Future<void> get getProfiles async {
    try {
      var response = await http.get(Uri.parse("$url?append_to_response=all"));
      _items = profileItemsFromJson(response.body);
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  Future<void> deleteProfile(String profileId) async {
    try {
      var response = await http.delete(Uri.parse("$url/$profileId"));
      final body = json.decode(response.body);
      _items.removeWhere((element) => element.id == body["id"]);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> executeTask(String profileId) async {
    try {
      final response = await http.patch(Uri.parse("$url/$profileId"));
      Map<String, dynamic> responsePayload = json.decode(response.body);
      for (var element in _items) {
        {
          if (element.id == responsePayload["id"]) {
            element.name = responsePayload["name"];
          }
        }
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
}
