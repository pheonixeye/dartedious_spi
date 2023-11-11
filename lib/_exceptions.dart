class IllegalStateException implements Exception {
  final String message;

  IllegalStateException(this.message) : super();
}

class NoSuchOptionException implements Exception {
  final String message;
  NoSuchOptionException(this.message) : super();
}

class IllegalArgumentException implements Exception {
  final String message;
  IllegalArgumentException(this.message) : super();
}
