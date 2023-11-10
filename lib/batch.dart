import 'package:rxdart/subjects.dart';

/// A collection of statements that are executed in a batch for performance reasons.
abstract class Batch {
  /// Add a statement to this batch.
  ///
  /// @param sql the statement to add
  /// @return this {@link Batch}
  /// @throws IllegalArgumentException if {@code sql} is {@code null}
  Batch add(String sql);

  /// Executes one or more SQL statements and returns the {@link Result}s.
  ///
  /// @return the {@link Result}s, returned by each statement
  PublishSubject<Result> execute();
}
