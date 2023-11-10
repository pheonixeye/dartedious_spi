/// Metadata about the product a {@link ConnectionFactory} is applicable to.
abstract class ConnectionFactoryMetadata {
  /// Returns the name of the product a {@link ConnectionFactory} can connect to
  ///
  /// @return the name of the product a {@link ConnectionFactory} can connect to
  String getName();
}
