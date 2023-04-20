/*class TokenSingleton {
  String? token;
  DateTime? timeStamp;

  /// private constructor
  TokenSingleton._();

  /// the one and only instance of this singleton
  static final instance = TokenSingleton._();
}*/

class TokenSingleton {
  static TokenSingleton? _instance;
  String? token;
  DateTime? timeStamp;

  TokenSingleton._internal() {}

  static TokenSingleton getState() {
    return _instance ??= TokenSingleton._internal();
  }
}
