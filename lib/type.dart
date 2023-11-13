/// Type descriptor for column- and parameter types.
///
/// @see R2dbcType
/// @since 0.9
abstract class DartType implements Type {
  /// @return default Java type.
  DartType getJavaType();

  /// @return type name.
  String getName();

  /**
     * Marker interface to indicate type inference.
     * Types are inferred during statement execution by applying type hints.
     */
}

abstract class InferredType extends DartType {}
