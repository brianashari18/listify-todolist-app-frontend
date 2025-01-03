import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:listify/models/subtask_model.dart';
import 'package:http/http.dart' as http;

class AIService {
  final String _baseUrl = "http://${dotenv.env["HOST"]}:${dotenv.env["PORT_AI"]}/api";

  Future<Map<String, dynamic>> getRecommendation(SubTask subtask) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/ai-recommendation?query=${subtask.taskData}"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data['data'],
        };
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'error': error['errors']};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}