abstract class Assert {
  const Assert._();

  static String requireNonEmpty(String s, String message) {
    if (s.isEmpty) {
      throw ArgumentError(message);
    }
    return s;
  }

  static T requireNonNull<T>(T? t, String message) {
    if (t == null) {
      throw ArgumentError(message);
    }
    return t;
  }
}
