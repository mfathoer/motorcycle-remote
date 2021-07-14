import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'responses/api_response.dart';

class ApiService {
  final String baseUrl = "http://192.168.43.134";

  Future<ApiResponse> turnOnContactAndEngine() async {
    try {
      Uri url = Uri.parse(baseUrl + "/onetouch");

      http.Response response = await http.get(url);

      var jsonObject = json.decode(response.body);
      var data = jsonObject as Map<String, dynamic>;

      return ApiResponse.fromJson(data);
    } on Error catch (e) {
      log("Error: $e");
      throw 'Cannot retrieve data';
    }
  }

  Future<ApiResponse> turnOnEngine() async {
    try {
      Uri url = Uri.parse(baseUrl + "/engineon");

      http.Response response = await http.get(url);

      var jsonObject = json.decode(response.body);
      var data = jsonObject as Map<String, dynamic>;

      return ApiResponse.fromJson(data);
    } on Error catch (e) {
      log("Error: $e");
      throw 'Cannot retrieve data';
    }
  }

  Future<ApiResponse> turnOffEngine() async {
    try {
      Uri url = Uri.parse(baseUrl + "/engineoff");

      http.Response response = await http.get(url);

      var jsonObject = json.decode(response.body);
      var data = jsonObject as Map<String, dynamic>;

      return ApiResponse.fromJson(data);
    } on Error catch (e) {
      log("Error: $e");
      throw 'Cannot retrieve data';
    }
  }

  Future<ApiResponse> turnOnContact() async {
    try {
      Uri url = Uri.parse(baseUrl + "/contacton");

      http.Response response = await http.get(url);

      var jsonObject = json.decode(response.body);
      var data = jsonObject as Map<String, dynamic>;

      return ApiResponse.fromJson(data);
    } on Error catch (e) {
      log("Error: $e");
      throw 'Cannot retrieve data';
    }
  }

  Future<ApiResponse> turnOffContact() async {
    try {
      Uri url = Uri.parse(baseUrl + "/contactoff");

      http.Response response = await http.get(url);

      var jsonObject = json.decode(response.body);
      var data = jsonObject as Map<String, dynamic>;

      return ApiResponse.fromJson(data);
    } on Error catch (e) {
      log("Error: $e");
      throw 'Cannot retrieve data';
    }
  }

  Future<ApiResponse> turnOnEmergencyMode() async {
    try {
      Uri url = Uri.parse(baseUrl + "/emergencyon");

      http.Response response = await http.get(url);

      var jsonObject = json.decode(response.body);
      var data = jsonObject as Map<String, dynamic>;

      return ApiResponse.fromJson(data);
    } on Error catch (e) {
      log("Error: $e");
      throw 'Cannot retrieve data';
    }
  }

  Future<ApiResponse> turnOffEmergencyMode() async {
    try {
      Uri url = Uri.parse(baseUrl + "/emergencyoff");

      http.Response response = await http.get(url);

      var jsonObject = json.decode(response.body);
      var data = jsonObject as Map<String, dynamic>;

      return ApiResponse.fromJson(data);
    } on Error catch (e) {
      log("Error: $e");
      throw 'Cannot retrieve data';
    }
  }
}
