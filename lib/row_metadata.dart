import 'package:dartedious_spi/column_metadata.dart';

/// Represents the metadata for a row of the results returned from a query.
/// Metadata for columns can be either retrieved by specifying a column name or the column index.
/// Columns indexes are {@code 0}-based.  Column names do not necessarily reflect the column names how they are in the underlying tables but rather how columns are represented (e.g. aliased) in the
/// result.
abstract class RowMetadata {
  /// Returns the {@link ColumnMetadata} for one column in this row.
  ///
  /// @param index the column index starting at 0
  /// @return the {@link ColumnMetadata} for one column in this row
  /// @throws IndexOutOfBoundsException if {@code index} is out of range (negative or equals/exceeds {@code getColumnMetadatas().size()})
  ColumnMetadata getColumnMetadataByIndex(int index);

  /// Returns the {@link ColumnMetadata} for one column in this row.
  ///
  /// @param name the name of the column.  Column names are case-insensitive.  When a get method contains several columns with same name, then the value of the first matching column will be returned
  /// @return the {@link ColumnMetadata} for one column in this row
  /// @throws IllegalArgumentException if {@code name} is {@code null}
  /// @throws NoSuchElementException   if there is no column with the {@code name}
  ColumnMetadata getColumnMetadataByName(String name);

  ColumnMetadata getColumnMetadata(dynamic val) {
    switch (val.runtimeType) {
      case String:
        return getColumnMetadataByName(val);
      case int:
        return getColumnMetadataByIndex(val);
      default:
        throw UnimplementedError();
    }
  }

  /// Returns the {@link ColumnMetadata} for all columns in this row.
  ///
  /// @return the {@link ColumnMetadata} for all columns in this row
  List<ColumnMetadata> getColumnMetadatas();

  /// Returns whether this object contains metadata for {@code columnName}.
  /// Lookups are case-insensitive. Implementations may allow escape characters to enforce a particular mode of comparison
  /// when querying for presence/absence of a column.
  ///
  /// @param columnName the name of the column.  Column names are case-insensitive.  When a get method contains several columns with same name, then the value of the first matching column will be returned
  /// @return {@code true} if this object contains metadata for {@code columnName}; {@code false} otherwise.
  /// @since 0.9
  bool contains(String columnName) {
    for (ColumnMetadata columnMetadata in getColumnMetadatas()) {
      if (columnMetadata.getName().toLowerCase() == (columnName)) {
        return true;
      }
    }
    return false;
  }
}
