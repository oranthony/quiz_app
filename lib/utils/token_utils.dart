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
  final int _tokenExpirationDelay = 6;

  Future<ApiTokenStringified?> retreiveOrGenerateToken() {
    return _retreiveToken().then((tokenFound) {
      if (tokenFound != null) {
        // 1 check date
        var retreivedDate = DateTime.parse(tokenFound.timeStamp);
        var nowDate = DateTime.now();
        var timeDifferene = nowDate.difference(retreivedDate);
        print(timeDifferene.inHours);
        print(retreivedDate);
        // Move to upper finction
        if (timeDifferene.inHours > _tokenExpirationDelay) {
          // Token expired so generates and stores a new one
          print("token found but expired");
          return _generateAndStoreToken();
        } else {
          // Token found is still valid
          return tokenFound;
        }
      } else {
        // If no token found -> generate a token from the api and store it
        return _generateAndStoreToken();
        // instanciate singleton
      }
    });
  }

  Future<ApiTokenStringified?> _retreiveToken() async {
    SharedPreferences shared_Token = await SharedPreferences.getInstance();
    var retreivedToken = shared_Token.getString('token');
    if (retreivedToken != null) {
      print("token found");
      Map<String, dynamic> userMap = jsonDecode(retreivedToken);
      return ApiTokenStringified.fromJson(userMap);
    } else {
      print("token not found");
      return null;
    }
  }

  Future<ApiTokenStringified?> _generateAndStoreToken() {
    // Get token from API
    // Store it in shared_preferences
    return ApiService().getToken().then((apiToken) {
      /*print(apiToken.token.toString())*/
      var stringifiedDate = DateTime.now().toIso8601String();
      ApiTokenStringified apiTokenStringified = ApiTokenStringified(
          token: apiToken.token.toString(), timeStamp: stringifiedDate);
      _storeToken(apiTokenStringified);
      return apiTokenStringified;
    });
  }

  void generateTokenSingleton(String token, DateTime timeStamp) {
    TokenSingleton.getState().timeStamp = timeStamp;
    TokenSingleton.getState().token = token;
  }

  Future<void> _storeToken(ApiTokenStringified token) async {
    // Transform ApiToekn into ApiTokenStringified
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    String serializedToekn = jsonEncode(token.toJson());
    sharedUser.setString('token', serializedToekn);
  }
}
