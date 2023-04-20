String? convertTimeStampToString() {
  var timeStamp = DateTime.now();
  if (timeStamp != null) {
    return timeStamp!.toIso8601String();
  } else {
    // TODO: throw exeption
    return null;
  }
}
