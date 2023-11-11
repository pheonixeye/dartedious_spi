import 'package:dartedious_spi/readable_metadata.dart';

/// Represents the metadata for a column of the results returned from a query.
/// The implementation of all methods except {@link #getName()}  is optional for drivers.
/// Column metadata is optionally available as by-product of statement execution on a best-effort basis.
abstract class ColumnMetadata extends ReadableMetadata {}
