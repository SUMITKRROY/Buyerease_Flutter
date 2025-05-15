import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchDataFromAPI(String apiUrl, Map<String, dynamic> requestBody ) async {
  try {
    // Make the API call
    final response = await http.post(Uri.parse(apiUrl),body: requestBody);
    // Check if the response is successful (status code 200)
    if (response.statusCode == 200) {
      // Decode the JSON response
      final Map<String, dynamic> data = json.decode(response.body);
      // Return the decoded data
      return data;
    } else {
      // If the response is not successful, throw an exception
      throw Exception('Failed to load data from API');
    }
  } catch (e) {
    // If an error occurs during the API call, throw an exception
    debugPrint('Failed to connect to the API: $e');
    throw Exception('Failed to connect to the API: $e');
  }
}
