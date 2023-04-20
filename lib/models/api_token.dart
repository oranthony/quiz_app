/// Stores the token given by the web API.
/// Requested every 6 hours.
/// Used only for shared_prefered

class ApiTokenStringified {
  final String token;
  // Stores the time the token was generated.
  final String timeStamp;

  ApiTokenStringified({required this.token, required this.timeStamp});

  Map<String, dynamic> toJson() {
    return {"token": token, "timeStamp": timeStamp};
  }

  factory ApiTokenStringified.fromJson(Map<dynamic, dynamic> parsedJson) {
    return ApiTokenStringified(
        token: parsedJson['token'] ?? "",
        timeStamp: parsedJson['timeStamp'] ?? "");
  }
}

class ApiToken {
  int? responseCode;
  String? responseMessage;
  String? token;

  ApiToken({this.responseCode, this.responseMessage, this.token});

  ApiToken.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    responseMessage = json['response_message'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['response_code'] = responseCode;
    data['response_message'] = responseMessage;
    data['token'] = token;
    return data;
  }
}
