import 'package:flutter/material.dart';
import 'package:quiz_app/models/question.dart';

import 'models/factories/factory_method.dart';

class GameSessionProvider extends ChangeNotifier {
  int _step = 0;
  int _score = 0;
  int _category = -1;
  bool _isLoaded = false;
  Questions questions = Questions();
  late CustomQuiz _customQuiz;

  int get score => _score;

  set score(value) {
    _score = value;
  }

  int get category => _category;

  set category(value) {
    _category = value;
  }

  Questions get getQuestions => questions;

  set setQuestions(questions) {
    this.questions = questions;
  }

  int get step => _step;

  set step(int newStep) {
    _step = newStep;
    notifyListeners();
  }

  void incrementStep() {
    _step++;
    notifyListeners();
  }

  bool get isLoaded => _isLoaded;

  set isLoaded(value) {
    _isLoaded = value;
    notifyListeners();
  }

  set setCustomQuiz(customQuiz) {
    _customQuiz = customQuiz;
    notifyListeners();
  }

  CustomQuiz get getCustomQuiz => _customQuiz;
}
