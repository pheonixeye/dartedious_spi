import 'package:dartedious_spi/readable_metadata.dart';

/// Represents the metadata for an {@code OUT} parameter.  The implementation of all methods except {@link #getName()}  is optional for drivers.  Parameter metadata is optionally
/// available as by-product of statement execution on a best-effort basis.
///
/// @since 0.9
abstract class OutParameterMetadata extends ReadableMetadata {}
