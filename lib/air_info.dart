import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'models/AirResult.dart';
import 'package:http/http.dart' as http;


class AirInfo extends ChangeNotifier {
  AirResult _result;

  AirResult get result => _result;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  Future<AirResult> _fetchData() async {
    var response = await http.get(
        'https://api.airvisual.com/v2/nearest_city?key=36ff6fed-03b3-4c7b-b244-6df0158197cd');

    AirResult result = AirResult.fromJson(json.decode(response.body));

    return result;
  }

  void fetchData() {
    _isLoading = true;
    _fetchData().then((result) {
      _result = result;
      _isLoading = false;
      notifyListeners();
    });
  }
}