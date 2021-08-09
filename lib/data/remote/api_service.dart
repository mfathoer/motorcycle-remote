import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'responses/api_response.dart';

class ApiService {
  final String _baseUrl = "your module ip address";

  Future<ApiResponse?> turnOnEngine() async {
    try {
      Uri url = Uri.parse(_baseUrl + "/engine/on");

      http.Response response = await http.get(url);

      var jsonObject = json.decode(response.body);
      var data = jsonObject as Map<String, dynamic>;

      return ApiResponse.fromJson(data);
    } on Error catch (e) {
      log("Error: $e");
      return null;
    }
  }

  Future<ApiResponse?> turnOffEngine() async {
    try {
      Uri url = Uri.parse(_baseUrl + "/engine/off");

      http.Response response = await http.get(url);

      var jsonObject = json.decode(response.body);
      var data = jsonObject as Map<String, dynamic>;

      return ApiResponse.fromJson(data);
    } on Error catch (e) {
      log("Error: $e");
      return null;
    }
  }

  Future<ApiResponse?> turnOnContact() async {
    try {
      Uri url = Uri.parse(_baseUrl + "/contact/on");

      http.Response response = await http.get(url);

      var jsonObject = json.decode(response.body);
      var data = jsonObject as Map<String, dynamic>;

      return ApiResponse.fromJson(data);
    } on Error catch (e) {
      log("Error: $e");
      return null;
    }
  }

  Future<ApiResponse?> turnOffContact() async {
    try {
      Uri url = Uri.parse(_baseUrl + "/contact/off");

      http.Response response = await http.get(url);

      var jsonObject = json.decode(response.body);
      var data = jsonObject as Map<String, dynamic>;

      return ApiResponse.fromJson(data);
    } on Error catch (e) {
      log("Error: $e");
      return null;
    }
  }

  Future<ApiResponse?> turnOnEmergencyMode() async {
    try {
      Uri url = Uri.parse(_baseUrl + "/emergency/on");

      http.Response response = await http.get(url);

      var jsonObject = json.decode(response.body);
      var data = jsonObject as Map<String, dynamic>;

      return ApiResponse.fromJson(data);
    } on Error catch (e) {
      log("Error: $e");
      return null;
    }
  }

  Future<ApiResponse?> turnOffEmergencyMode() async {
    try {
      Uri url = Uri.parse(_baseUrl + "/emergency/off");

      http.Response response = await http.get(url);

      var jsonObject = json.decode(response.body);
      var data = jsonObject as Map<String, dynamic>;

      return ApiResponse.fromJson(data);
    } on Error catch (e) {
      log("Error: $e");
      return null;
    }
  }
}
