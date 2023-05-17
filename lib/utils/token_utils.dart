import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:quiz_app/models/api_token.dart';
import 'package:quiz_app/models/singletons/token_singleton.dart';
import 'package:quiz_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Handles all the operations to store and retreived tokens in local storage.
// If no token found, or if the token found in storage is too old, a new one is
// asked to the API and stored.

mixin TokenHandler<T extends StatefulWidget> on State<T> {
  // Token is valid for 6 hours
  final int _tokenExpirationDelay = 6;

  // Search for an existing token in storage, if no token found a new one is asked
  // to the API
  Future<ApiTokenStringified?> retreiveOrGenerateToken() {
    return _retreiveToken().then((tokenFound) {
      if (tokenFound != null) {
        // 1 check date
        var retreivedDate = DateTime.parse(tokenFound.timeStamp);
        var nowDate = DateTime.now();
        var timeDifferene = nowDate.difference(retreivedDate);
        if (timeDifferene.inHours > _tokenExpirationDelay) {
          // Token expired so generates and stores a new one
          return _generateAndStoreToken();
        } else {
          // Token found is still valid
          return tokenFound;
        }
      } else {
        // If no token found -> generate a token from the api and store it
        return _generateAndStoreToken();
      }
    });
  }

  // Instantiate the singleton with the token values
  void generateTokenSingleton(String token, DateTime timeStamp) {
    TokenSingleton.getState().timeStamp = timeStamp;
    TokenSingleton.getState().token = token;
  }

  // Searches in storage for an existing token and returns it, return null if not found
  Future<ApiTokenStringified?> _retreiveToken() async {
    SharedPreferences sharedToken = await SharedPreferences.getInstance();
    var retreivedToken = sharedToken.getString('token');
    if (retreivedToken != null) {
      Map<String, dynamic> userMap = jsonDecode(retreivedToken);
      return ApiTokenStringified.fromJson(userMap);
    } else {
      return null;
    }
  }

  // Get token from API, store it in shared_preferences and return it as value
  Future<ApiTokenStringified?> _generateAndStoreToken() {
    return ApiService().getToken().then((apiToken) {
      var stringifiedDate = DateTime.now().toIso8601String();
      ApiTokenStringified apiTokenStringified = ApiTokenStringified(
          token: apiToken.token.toString(), timeStamp: stringifiedDate);
      _storeToken(apiTokenStringified);
      return apiTokenStringified;
    });
  }

  // Store a given token to SharedPreferences
  Future<void> _storeToken(ApiTokenStringified token) async {
    // Transform ApiToekn into ApiTokenStringified
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    String serializedToekn = jsonEncode(token.toJson());
    sharedUser.setString('token', serializedToekn);
  }
}
