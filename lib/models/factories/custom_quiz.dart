import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/question.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/providers.dart';
import 'package:quiz_app/services/api_service.dart';

abstract class CustomQuiz {
  late GameSessionProvider _gameSessionProvider;
  void getQuestions();
  Uri generateURI();

  CustomQuiz(BuildContext context) {
    initializeProvider(context);
  }

  void initializeProvider(BuildContext context) {
    _gameSessionProvider =
        Provider.of<GameSessionProvider>(context, listen: false);
  }

  Future<Questions> callAPI(Uri uri) async {
    return ApiService().getQuestions(uri);
  }

  void updateProvider(Questions questions) {
    _gameSessionProvider.questions = questions;
    _gameSessionProvider.isLoaded = true;
  }
}
