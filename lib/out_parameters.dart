import 'package:dartedious_spi/out_parameters_metadata.dart';
import 'package:dartedious_spi/readable.dart';

/// Represents a set of {@code OUT} parameters returned from a stored procedure.
/// Values from out parameters can be either retrieved by specifying a parameter name or the parameter index.
/// Parameter indexes are {@code 0}-based.
///
/// <p> Parameter names used as input to getter methods are case-insensitive.
/// When a get method is called with a parameter name and several parameters have the same name, then the value of the first matching parameter will be returned.
/// Parameters that are not explicitly named in the query should be referenced through parameter indexes.
///
/// <p>For maximum portability, parameters within each {@link OutParameters} should be read in left-to-right order, and each parameter should be read only once.
///
/// <p>{@link #get(String)} and {@link #get(int)} without specifying a target type returns a suitable value representation.  The R2DBC specification contains a mapping table that shows default
/// mappings between database types and Java types.
/// Specifying a target type, the R2DBC driver attempts to convert the value to the target type.
/// <p>A parameter is invalidated after consumption.
/// <p>The number, type and characteristics of parameters are described through {@link OutParametersMetadata}.
///
/// @since 0.9
abstract class OutParameters extends Readable {
  /// Returns the {@link OutParametersMetadata} for all out parameters.
  ///
  /// @return the {@link OutParametersMetadata} for all out parameters
  OutParametersMetadata getMetadata();
}
