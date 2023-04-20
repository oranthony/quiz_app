import 'package:quiz_app/models/factories/custom_quiz.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/models/singletons/token_singleton.dart';
import 'package:quiz_app/utils/constants.dart' as Constants;

// Contains all items that can be implemented for the factory

class GeneralQuiz extends CustomQuiz {
  final int _category = Constants.categoryGeneral;
  final String _level = Constants.mediumLevel;

  GeneralQuiz(super.context);

  @override
  void getQuestions() {
    callAPI(generateURI()).then((questions) => updateProvider(questions));
  }

  @override
  Uri generateURI() {
    final queryParams = {
      'amount': '10',
      'category': _category.toString(),
      'difficulty': _level.toString(),
      'type': 'boolean',
      'token': TokenSingleton.getState().token,
    };

    final uri = Uri.https(Constants.endpointUrl, Constants.path, queryParams);
    print(uri);
    return uri;
  }
}

class HistoryQuiz extends CustomQuiz {
  final int _category = Constants.categoryHistory;
  //final String _level = Constants.easyLevel;

  HistoryQuiz(super.context);

  @override
  void getQuestions() {
    callAPI(generateURI()).then((questions) => updateProvider(questions));
  }

  @override
  Uri generateURI() {
    final queryParams = {
      'amount': '10',
      'category': _category.toString(),
      //'difficulty': _level.toString(),
      'type': 'boolean',
      'token': TokenSingleton.getState().token,
    };

    final uri = Uri.https(Constants.endpointUrl, Constants.path, queryParams);

    return uri;
  }
}

class TechnologyQuiz extends CustomQuiz {
  final int _category = Constants.categoryTechnology;
  //final String _level = Constants.easyLevel;

  TechnologyQuiz(super.context);

  @override
  void getQuestions() {
    callAPI(generateURI()).then((questions) => updateProvider(questions));
  }

  @override
  Uri generateURI() {
    final queryParams = {
      'amount': '10',
      'category': _category.toString(),
      //'difficulty': _level.toString(),
      'type': 'boolean',
      'token': TokenSingleton.getState().token,
    };

    final uri = Uri.https(Constants.endpointUrl, Constants.path, queryParams);

    return uri;
  }
}

class SportQuiz extends CustomQuiz {
  final int _category = Constants.categorySport;
  final String _level = Constants.mediumLevel;

  SportQuiz(super.context);

  @override
  void getQuestions() {
    callAPI(generateURI()).then((questions) => updateProvider(questions));
  }

  @override
  Uri generateURI() {
    final queryParams = {
      'amount': '10',
      'category': _category.toString(),
      'difficulty': _level.toString(),
      'type': 'boolean',
      'token': TokenSingleton.getState().token,
    };

    final uri = Uri.https(Constants.endpointUrl, Constants.path, queryParams);

    return uri;
  }
}

// Mix 6 easy questions and 4 hard questions
class MegaMixGeneralQuiz extends CustomQuiz {
  final int _category = Constants.categoryGeneral;
  Questions _questions = Questions();

  MegaMixGeneralQuiz(super.context);

  @override
  void getQuestions() {
    callAPI(generateURIFromArguments(6, _category, Constants.easyLevel))
        .then((questions) => _questions = questions)
        .then((questions1) =>
            callAPI(generateURIFromArguments(4, _category, Constants.hardLevel))
                .then((questions) => _questions.results =
                    mergeResultsList(_questions.results, questions.results)))
        .then((value) => {updateProvider(_questions)});
  }

  // TODO: put it in a mixin so that it can be reused or in mother abstract class
  List<Results> mergeResultsList(List? list1, List? list2) {
    if (list1 != null && list2 != null) {
      return [...list1, ...list2];
    } else {
      return List.empty();
    }
  }

  Uri generateURIFromArguments(
      int amountOfQuestions, int category, String level) {
    final queryParams = {
      'amount': amountOfQuestions.toString(),
      'category': category.toString(),
      'difficulty': level.toString(),
      'type': 'boolean',
      'token': TokenSingleton.getState().token,
    };

    final uri = Uri.https(Constants.endpointUrl, Constants.path, queryParams);

    return uri;
  }

  @override
  Uri generateURI() {
    final queryParams = {
      'amount': '10',
      'category': _category.toString(),
      'difficulty': 'easy',
      'type': 'boolean',
    };

    final uri = Uri.https(Constants.endpointUrl, Constants.path, queryParams);

    return uri;
  }
}
