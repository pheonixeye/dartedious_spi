import 'dart:collection';

import 'package:dartedious_spi/assert.dart';

/// A pool of constant instances.  Only a single instance of each constant (by name) should ever exist.
///
/// @param <T> the type of the constant
abstract class ConstantPool<T> {
  final HashMap<String, T> _constants = HashMap();

  @override
  String toString() {
    return "ConstantPool{constants=$_constants}";
  }

  /// Creates a new instance of the constant.  Implementations of this method should return a new instance each time.
  ///
  /// @param name      the name of the constant
  /// @param sensitive whether the value represented by this constant is sensitive
  /// @return a new instance of the constant
  T createConstant(String name, bool sensitive);

  /// Returns a cached or newly created instance of a constant.
  ///
  /// @param name      the name of the constant
  /// @param sensitive whether the value represented by this constant is sensitive
  /// @return a cached or newly created instance of a constant
  /// @throws IllegalArgumentException if {@code name} is {@code null} or empty
  T valueOf(String name, bool sensitive) {
    Assert.requireNonNull(name, "name must not be null");
    Assert.requireNonEmpty(name, "name must not be empty");

    return _constants.putIfAbsent(name, () => createConstant(name, sensitive));
  }
}
