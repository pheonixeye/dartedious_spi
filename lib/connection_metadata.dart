/// Metadata about the product a  [Connection] is connected to.
abstract class ConnectionMetadata {
  /// Retrieves the name of this database product.  May contain additional information about editions.
  ///
  /// @return database product name
  String getDatabaseProductName();

  /// Retrieves the version number of this database product.
  ///
  /// @return database version
  String getDatabaseVersion();
}
