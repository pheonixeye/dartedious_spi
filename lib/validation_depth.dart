/// Constants indicating validation depth for a {@link Connection}.
// ignore_for_file: constant_identifier_names

enum ValidationDepth {
  /// Perform a client-side only validation.  Typically to determine whether a connection is still active or other mechanism that does not involve remote communication.
  LOCAL,

  /// Perform a remote connection validations.  Typically by sending a database message or some other mechanism to validate that the database connection and session are active and can be used for
  /// database queries.  Any query submitted by the driver to validate the connection is executed in the context of the current transaction.
  REMOTE
}
