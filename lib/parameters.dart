import 'package:dartedious_spi/assert.dart';
import 'package:dartedious_spi/parameter.dart';
import 'package:dartedious_spi/type.dart';

final class Parameters {
  /// Create a {@code NULL IN} parameter using the given {@link Type}.
  ///
  /// @param type the type to be sent to the database.
  /// @return the in parameter.
  /// @throws IllegalArgumentException if {@code type} is {@code null}.
  static Parameter isIn(dynamic type) {
    Assert.requireNonNull(type, "Type must not be null");
    switch (type.runtimeType) {
      case DartType:
        return _in(type, null);
      case Type:
        return _in(DefaultInferredType(type), null);
      case Object:
        return _in(DefaultInferredType(type), type);
      default:
        return _in(type, null);
    }
  }

  static Parameter _in(Type type, Object? value) {
    Assert.requireNonNull(type, "Type must not be null");
    return InParameter(type, value);
  }

  static Parameter out(DartType type) {
    Assert.requireNonNull(type, "Type must not be null");
    return _out(DefaultInferredType(type));
  }

  static Parameter _out(Type type) {
    Assert.requireNonNull(type, "Type must not be null");
    return OutParameter(type, null);
  }

  static Parameter _inOut(Type type, Object? value) {
    Assert.requireNonNull(type, "Type must not be null");
    return InOutParameter(type, value);
  }

  static Parameter inOut(dynamic type) {
    Assert.requireNonNull(type, "Type must not be null");

    switch (type.runtimeType) {
      case Type:
        return _inOut(type, null);
      case DartType:
        return _inOut(DefaultInferredType(type), null);
      case Object:
        return _inOut(DefaultInferredType(type), type);
      default:
        return _inOut(type, null);
    }
  }
}

class DefaultParameter implements Parameter {
  final Type type;

  final Object? value;

  DefaultParameter(this.type, this.value);

  @override
  In? isIn;

  @override
  Out? isOut;

  @override
  Type getType() {
    return type.runtimeType;
  }

  @override
  Object? getValue() {
    return value;
  }

  @override
  bool operator ==(covariant other) {
    if (this == other) {
      return true;
    }
    if (getType() != (other as DefaultParameter).getType()) {
      return false;
    }
    return getValue() != null
        ? getValue() == (other.getValue())
        : other.getValue() == null;
  }

  @override
  int get hashCode {
    int result = getType().hashCode;
    result = 31 * result + (getValue() != null ? getValue().hashCode : 0);
    return result;
  }
}

class InParameter extends DefaultParameter implements In {
  InParameter(super.type, super.value);

  @override
  String toString() {
    return "In{ $getType() }";
  }

  @override
  bool operator ==(covariant Object other) {
    return other is In && other is! Out && (super == other);
  }
}

class OutParameter extends DefaultParameter implements Out {
  OutParameter(super.type, super.value);
  @override
  String toString() {
    return "Out{ $getType() }";
  }

  @override
  bool operator ==(covariant Object other) {
    return other is Out && other is! In && super == (other);
  }
}

class InOutParameter extends DefaultParameter implements In, Out {
  InOutParameter(super.type, super.value);

  @override
  String toString() {
    return "InOut{ $getType() }";
  }

  @override
  bool operator ==(covariant Object other) {
    return other is Out && other is In && super == (other);
  }
}

class DefaultInferredType implements InferredType, DartType {
  final DartType javaType;

  DefaultInferredType(this.javaType);
  @override
  DartType getJavaType() {
    return javaType;
  }

  @override
  String getName() {
    return "(inferred)";
  }

  @override
  bool operator ==(covariant Object other) {
    if (this == other) {
      return true;
    }
    if (other is! InferredType) {
      return false;
    }

    InferredType that = other;

    return getJavaType() == (that.getJavaType());
  }

  @override
  int get hashCode {
    return getJavaType().hashCode;
  }

  @override
  String toString() {
    return "Inferred: ${getJavaType().getName()}";
  }
}
