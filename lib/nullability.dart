/// Constants indicating nullability of column values.
// ignore_for_file: constant_identifier_names

enum Nullability {
  /// Indicating that a column does allow {@code NULL} values.
  NULLABLE,

  /// Indicating that a column does not allow {@code NULL} values.
  NON_NULL,

  /// Indicating that the nullability of a column's values is unknown.
  UNKNOWN
}
