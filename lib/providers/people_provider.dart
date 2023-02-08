import 'dart:convert';

import 'package:api_people_flutter/models/people_item.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class PeopleProvider with ChangeNotifier {
  List<PeopleItem> _items = [];
  final url = 'http://127.0.0.1:5000/api/v1/people';

  List<PeopleItem> get items {
    return [..._items];
  }

  Future<void> addPeople(String name) async {
    if (name.isEmpty) {
      return;
    }
    Map<String, dynamic> request = {"name": name};
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(request));
    Map<String, dynamic> responsePayload = json.decode(response.body);
    final people =
        PeopleItem(id: responsePayload["id"], name: responsePayload["name"]);
    _items.add(people);
    notifyListeners();
  }

  Future<void> get getPeoples async {
    try {
      var response = await http.get(Uri.parse(url));
      List<dynamic> body = json.decode(response.body);
      _items =
          body.map((e) => PeopleItem(id: e['id'], name: e['name'])).toList();
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  Future<void> deletePeople(String peopleId) async {
    try {
      var response = await http.delete(Uri.parse("$url/$peopleId"));
      final body = json.decode(response.body);
      _items.removeWhere((element) => element.id == body["id"]);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> executeTask(String peopleId) async {
    try {
      final response = await http.patch(Uri.parse("$url/$peopleId"));
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
