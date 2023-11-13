/// Represents a parameter to be interchanged. Parameters are typed and can define a value. Parameters without a value correspond with a SQL {@code NULL} value.
/// <p>
/// Parameters can be classified as {@link In input} or {@link Out output} parameters.
///
/// @since 0.9
abstract class Parameter {
  /// Returns the parameter.
  ///
  /// @return the type to be sent to the database.
  Type getType();

  /// Returns the value.
  ///
  /// @return the value for this parameter.  Value can be {@code null}.

  Object? getValue();

  In? isIn;

  Out? isOut;
}

/// Marker interface to classify a parameter as input parameter.
/// Parameters that do not implement {@link Out} default to in parameters.
abstract class In {}

/// Marker interface to classify a parameter as output parameter.
/// Parameters can implement both, {@code In} and {@code Out} interfaces to be classified as in-out parameters.
abstract class Out {}
