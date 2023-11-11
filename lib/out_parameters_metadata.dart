import 'package:dartedious_spi/out_parameter_metadata.dart';

/// Represents the metadata for {@code OUT} parameters of the results returned from a stored procedure.
/// Metadata for parameters can be either retrieved by specifying a out parameter name or the out parameter index.
/// Parameter indexes are {@code 0}-based.
abstract class OutParametersMetadata {
  /// Returns the {@link OutParameterMetadata} for one out parameter.
  ///
  /// @param index the out parameter index starting at 0
  /// @return the {@link OutParameterMetadata} for one out parameter
  /// @throws IndexOutOfBoundsException if {@code index} is out of range (negative or equals/exceeds {@code getParameterMetadatas().size()})
  OutParameterMetadata getParameterMetadataFromIndex(int index);

  /// Returns the {@link OutParameterMetadata} for one parameter.
  ///
  /// @param name the name of the out parameter.  Parameter names are case-insensitive.
  /// @return the {@link OutParameterMetadata} for one out parameter
  /// @throws IllegalArgumentException if {@code name} is {@code null}
  /// @throws NoSuchElementException   if there is no out parameter with the {@code name}
  OutParameterMetadata getParameterMetadataFromName(String name);

  /// Returns the {@link OutParameterMetadata} for all out parameters.
  ///
  /// @return the {@link OutParameterMetadata} for all out parameters
  List<OutParameterMetadata> getParameterMetadatas();
}
