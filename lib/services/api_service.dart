import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/utils/constants.dart' as Constants;
import 'package:quiz_app/models/api_token.dart';
import 'package:quiz_app/models/question.dart';

class ApiService {
  Future<Questions> getQuestions(Uri uri) async {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return Questions.fromJson(jsonDecode(response.body));
      print(response.body);
      return Questions.fromJson(jsonDecode(response.body));

      var questions = Questions.fromJson(jsonDecode(response.body));
      if (questions.responseCode == 1 || questions.responseCode == 4) {
        const AlertDialog(title: Text("no more questions"));
        print('no questions');
        return questions;
      } else {
        print("has questions");
        return questions;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load questions from API');
    }
  }

  Future<ApiToken> getToken() async {
    final queryParams = {
      'command': 'request',
    };

    final uri = Uri.https(Constants.endpointUrl, '/api_token.php', queryParams);

    print(uri);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return Questions.fromJson(jsonDecode(response.body));
      return ApiToken.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load questions from API');
    }
  }
}
