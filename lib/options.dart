import 'package:dartedious_spi/assert.dart';
import 'package:dartedious_spi/constant_pool.dart';

typedef Any = dynamic;

class OptionsConstantPool<T> extends ConstantPool<Option<T>> {
  @override
  Option<T> createConstant(String name, bool sensitive) {
    return Option<T>(name, sensitive);
  }
}

/// Represents a configuration option constant.
///
/// @param <T> The value type of the option when configuring a value programmatically
/// @see ConnectionFactoryOptions
/// @see TransactionDefinition
final class Option<T> {
  final String _name;

  final bool _sensitive;

  Option(this._name, this._sensitive);

  static final ConstantPool<Option<Any>> CONSTANTS = OptionsConstantPool<Any>();

  /// Returns a constant singleton instance of the sensitive option.
  ///
  /// @param name the name of the option to return
  /// @param <T>  the value type of the option
  /// @return a constant singleton instance of the option
  /// @throws IllegalArgumentException if {@code name} is {@code null} or empty
  static Option<T> sensitiveValueOf<T>(String name) {
    Assert.requireNonNull(name, "name must not be null");
    Assert.requireNonEmpty(name, "name must not be empty");

    return CONSTANTS.valueOf(name, true) as Option<T>;
  }

  /// Returns a constant singleton instance of the option.
  ///
  /// @param name the name of the option to return
  /// @param <T>  the value type of the option
  /// @return a constant singleton instance of the option
  /// @throws IllegalArgumentException if {@code name} is {@code null} or empty
  static Option<T> valueOf<T>(String name) {
    Assert.requireNonNull(name, "name must not be null");
    Assert.requireNonEmpty(name, "name must not be empty");

    return CONSTANTS.valueOf(name, false) as Option<T>;
  }

  /// Casts an object to the class or interface represented by this option object.
  ///
  /// @param obj the object to be cast
  /// @return the object after casting, or null if obj is {@code null}.
  /// @since 0.9
  T? cast(Object? obj) {
    if (obj == null) {
      return null;
    }

    return obj as T;
  }

  /// Returns the name of the option.
  ///
  /// @return the name of the option
  String get name => this._name;

  bool get sensitive => this._sensitive;

  @override
  String toString() {
    return """
            Option{"
            "name='" $name '\''
            ", sensitive=" $sensitive
            '}""";
  }

  @override
  bool operator ==(covariant Option other) {
    if (this == other) {
      return true;
    }

    return this._sensitive == other._sensitive && this._name == other._name;
  }

  @override
  int get hashCode => Object.hashAll([_name, _sensitive]);
}
