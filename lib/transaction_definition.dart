// ignore_for_file: non_constant_identifier_names

import 'package:dartedious_spi/isolation_level.dart';
import 'package:dartedious_spi/options.dart';

/// Specification of properties to be used when starting a transaction.  This interface is typically implemented by code that calls {@link Connection#beginTransaction(TransactionDefinition)}.
///
/// @see Connection#beginTransaction(TransactionDefinition)
/// @see Option
/// @since 0.9
class TransactionDefinition {
  /// Isolation level requested for the transaction.
  Option<IsolationLevel> ISOLATION_LEVEL = Option.valueOf("isolationLevel");

  /// The transaction mutability (i.e. whether the transaction should be started in read-only mode).
  Option<bool> READ_ONLY = Option.valueOf("readOnly");

  /// Name of the transaction.
  Option<String> NAME = Option.valueOf("name");

  /// Lock wait timeout.
  Option<Duration> LOCK_WAIT_TIMEOUT = Option.valueOf("lockWaitTimeout");

  /// Retrieve a transaction attribute by its {@link Option} identifier.  This low-level interface allows querying transaction attributes supported by the {@link Connection} that should be applied
  /// when starting a new transaction.
  ///
  /// @param option the option to retrieve the value for
  /// @param <T>    requested value type
  /// @return the value of the transaction attribute. Can be {@code null} to indicate absence of the attribute.
  /// @throws IllegalArgumentException if {@code name} or {@code type} is {@code null}

  T? getAttribute<T>(Option<T> option) {
    throw UnimplementedError();
  }
}
