import 'package:dartedious_spi/assert.dart';
import 'package:dartedious_spi/java/predicate.dart';
import 'package:dartedious_spi/out_parameters.dart';
import 'package:dartedious_spi/r2dbc_exception.dart';
import 'package:dartedious_spi/row.dart';
import 'package:dartedious_spi/row_metadata.dart';
import 'package:rxdart/subjects.dart';
import 'package:dartedious_spi/java/bifunction.dart';

/// Represents the results of a query against a database.  Results can be consumed only once by either consuming {@link #getRowsUpdated()}, {@link #map(BiFunction)}, or {@link #map(Function)}.
///
/// <p>A {@link Result} object maintains a consumption state that may be backed by a cursor pointing
/// to its current row of data or out parameters.  A {@link Result} allows read-only and forward-only consumption of statement results.
/// Thus, you can consume either {@link #getRowsUpdated()}, {@link #map(BiFunction) Rows}, or {@link #map(Function) Rows or out parameters} through it only once and only from the first to the last
/// row/parameter set.
abstract class Result {
  /// Returns the number of rows updated by a query against a database.  May be empty if the query did not update any rows.
  /// <p>Consuming the update count may emit an {@link Subscriber#onError(Throwable) error signal} if the results contain one or more {@link Message error message segments}.
  ///
  /// @return the number of rows updated by a query against a database
  /// @throws IllegalStateException if the result was consumed
  PublishSubject<int> getRowsUpdated();

  /// Returns a mapping of the rows that are the results of a query against a database.
  /// May be empty if the query did not return any rows.  A {@link Row} can be only considered valid within a
  /// {@link BiFunction mapping function} callback.
  /// <p>Consuming data rows may emit an {@link Subscriber#onError(Throwable) error signal} if the results contain one or more {@link Message error message segments}.
  ///
  /// @param mappingFunction the {@link BiFunction} that maps a {@link Row} and {@link RowMetadata} to a value
  /// @param <T>             the type of the mapped value
  /// @return a mapping of the rows that are the results of a query against a database
  /// @throws IllegalArgumentException if {@code mappingFunction} is {@code null}
  /// @throws IllegalStateException    if the result was consumed
  PublishSubject<T> _map<T>(BiFunction<Row, RowMetadata, T> mappingFunction);

  /// Returns a mapping of the rows/out parameters that are the results of a query against a database.
  /// May be empty if the query did not return any results.  A {@link Readable} can be only
  /// considered valid within a {@link Function mapping function} callback.
  ///
  /// @param mappingFunction the {@link Function} that maps a {@link Readable} to a value
  /// @param <T>             the type of the mapped value
  /// @return a mapping of the rows that are the results of a query against a database
  /// @throws IllegalArgumentException if {@code mappingFunction} is {@code null}
  /// @throws IllegalStateException    if the result was consumed
  /// @see Row
  /// @see OutParameters
  /// @since 0.9
  PublishSubject<T> map<T>(
      T Function<Readable, T>(Readable, T) mappingFunction) {
    Assert.requireNonNull(mappingFunction, "mappingFunction must not be null");
    return _map((row, metadata) => Function.apply(mappingFunction, [row]));
  }

  /// Returns a filtered variant of the {@link Result} to selectively consume result segments matching {@link Predicate filter predicate}.
  /// <p>The returned {@link Result} is a potentially reduced view of the underlying {@link Result} to filter out unwanted result segments.  For example, filtering all {@link Message} segments
  /// from the result
  /// lets the result complete without an error.
  ///
  /// @param filter the non-interfering and stateless {@link Predicate} to apply to each element to determine if it should be included
  /// @return a filtered {@link Result}
  /// @throws IllegalArgumentException if {@code filter} is {@code null}
  /// @throws IllegalStateException    if the result was consumed
  /// @since 0.9
  Result filter(Predicate<Segment> filter);

  /// Returns a mapping of the {@link Segment result segments} that are the results of a query against a database.  May be empty if the query did not return any segments.  A {@link Segment} can be
  /// only considered valid within a {@link Function mapping function} callback.
  /// <p>Consuming result {@link Segment segments} does not emit {@link Subscriber#onError(Throwable) error signals} from {@link Message message segments representing an error}.  Translation of
  /// error segments is subject to the {@code mappingFunction}.
  /// <p>Signals from mapped {@link Publisher publishers} are replayed sequentially preserving ordering by concatenating publishers.
  ///
  /// @param mappingFunction the {@link Function} that maps a {@link Segment} a to a {@link Publisher}
  /// @param <T>             the type of the mapped value
  /// @return a mapping of the segments that are the results of a query against a database
  /// @throws IllegalArgumentException if {@code mappingFunction} is {@code null}
  /// @throws IllegalStateException    if the result was consumed
  /// @since 0.9
  PublishSubject<T> flatMap<T>(
      PublishSubject<T> Function(Segment, PublishSubject<T>) mappingFunction);
}

/// Marker interface for a result segment.  Result segments represent the individual parts of a result from a query against a database.  Segments are typically update counts, data rows/{@code
/// OUT} parameters, and messages of varying severities.  Segments can also represent vendor-specific extensions.
///
/// @since 0.9
abstract class Segment {}

/// Row segment consisting of {@link Row row data}.
///
/// @since 0.9
abstract class RowSegment extends Segment {
  Row row();
}

/// Out parameters segment consisting of {@link OutParameters readable data}.
///
/// @since 0.9
abstract class OutSegment extends Segment {
  OutParameters outParameters();
}

/// Update count segment consisting providing a {@link #value() affected rows count}.
///
/// @since 0.9
abstract class UpdateCount extends Segment {
  int value();
}

/// Message segment reported as result of the statement processing.
///
/// @since 0.9
abstract class Message extends Segment {
  /// Return the error as {@link R2dbcException}.
  ///
  /// @return the error as {@link R2dbcException}.
  R2dbcException exception();

  /// Returns the vendor-specific error code.
  ///
  /// @return the vendor-specific error code
  int errorCode();

  /// Returns the SQLState.
  ///
  /// @return the SQLState

  String? sqlState();

  /// Returns the message text.
  ///
  /// @return the message text.
  String message();
}
