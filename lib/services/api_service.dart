import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "http://192.168.137.1:8080";
  static Future<http.Response> register(String url, Map<String, dynamic> requestBody) {
    return http.post(
      Uri.parse("$baseUrl$url"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );
  }

  static Future<http.Response> login(String url, Map<String, dynamic> requestBody) {
    return http.post(
      Uri.parse("$baseUrl$url"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );
  }

  static Future<http.Response> loginWithGoogle(String url) {
    return http.post(
      Uri.parse("$baseUrl$url"),
    );
  }

  static Future<http.Response> getCurrent(String url, String token) {
    return http.get(
        Uri.parse("$baseUrl$url"),
        headers: {
          "Authorization": token
        }
    );
  }
}