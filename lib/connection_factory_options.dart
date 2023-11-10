// ignore_for_file: non_constant_identifier_names

import 'dart:collection';

import 'package:dartedious_spi/assert.dart';
import 'package:dartedious_spi/options.dart';

/// A holder for configuration options related to {@link ConnectionFactory}s.
/// <p>
/// A {@link ConnectionFactoryOptions} represents a configuration state that consists of one or more {@link Option} objects. Each configuration option can be specified at most once to associate a
/// value with its key.
/// <p>
/// New objects are constructed through {@link #builder()} or by {@link #parse(CharSequence) parsing} a R2DBC Connection URL.
/// {@link ConnectionFactoryOptions} can be augmented to allow staged construction of the configuration state using a {@link #mutate()
/// initialized builder} to create a new {@link ConnectionFactoryOptions} objects with mutations applied. Values of this class are immutable once created. Builder initializers are left unchanged.
/// <p>
/// Example usage:
/// <pre class="code">
/// ConnectionFactoryOptions options = ConnectionFactoryOptions.builder()
///     .option(ConnectionFactoryOptions.DRIVER, "a-driver")
///     .option(ConnectionFactoryOptions.PROTOCOL, "pipes")
///     .option(ConnectionFactoryOptions.HOST, "localhost")
///     .option(ConnectionFactoryOptions.PORT, 3306)
///     .option(ConnectionFactoryOptions.DATABASE, "my_database")
///     .option(Option.valueOf("locale"), "en_US")
///     .build();
/// </pre>
/// <p>
/// Note that Connection URL Parsing cannot access {@link Option} type information {@code T} due to Java's type erasure. Options configured by URL parsing are represented as {@link String} values.
///
/// @see ConnectionFactories
class ConnectionFactoryOptions {
  /// Connection timeout.
  static final Option<Duration> CONNECT_TIMEOUT =
      Option.valueOf("connectTimeout");

  /// Initial database name.
  static final Option<String> DATABASE = Option.valueOf("database");

  /// Driver name.
  static final Option<String> DRIVER = Option.valueOf("driver");

  /// Endpoint host name.
  static final Option<String> HOST = Option.valueOf("host");

  /// Lock timeout.
  ///
  /// @since 0.9
  static final Option<Duration> LOCK_WAIT_TIMEOUT =
      Option.valueOf("lockWaitTimeout");

  /// Password for authentication.
  static final Option<String> PASSWORD = Option.sensitiveValueOf("password");

  /// Endpoint port number.
  static final Option<int> PORT = Option.valueOf("port");

  /// Driver protocol name.  Typically represented as {@code tcp} or a database vendor-specific protocol string.
  static final Option<String> PROTOCOL = Option.valueOf("protocol");

  /// Whether to require SSL.
  static final Option<bool> SSL = Option.valueOf("ssl");

  /// Statement timeout.
  ///
  /// @since 0.9
  static final Option<Duration> STATEMENT_TIMEOUT =
      Option.valueOf("statementTimeout");

  /// User for authentication.
  static final Option<String> USER = Option.valueOf("user");

  late final Map<Option<Any>, Object> options;

  ConnectionFactoryOptions(Map<Option<Any>, Object> options) {
    this.options = Assert.requireNonNull(options, "options must not be null");
  }

  /// Returns a new {@link Builder}.
  ///
  /// @return a new {@link Builder}
  static Builder builder() {
    return Builder();
  }
}

/// A builder for {@link ConnectionFactoryOptions} instances.
/// <p>
/// <i>This class is not threadsafe</i>
final class Builder {
  Builder();

  final Map<Option<Any>, Object> options = HashMap();

  /// Returns a configured {@link ConnectionFactoryOptions}.
  ///
  /// @return a configured {@link ConnectionFactoryOptions}
  ConnectionFactoryOptions build() {
    return ConnectionFactoryOptions(options);
  }

  /// Populates the builder with the existing values from a configured {@link ConnectionFactoryOptions}.
  ///
  /// @param connectionFactoryOptions a configured {@link ConnectionFactoryOptions}
  /// @return this {@link Builder}
  /// @throws IllegalArgumentException if {@code connectionFactoryOptions} is {@code null}
  Builder from(ConnectionFactoryOptions connectionFactoryOptions) {
    return _from(connectionFactoryOptions, (it) => true);
  }

  /// Populates the builder with the existing values from a configured {@link ConnectionFactoryOptions} allowing to {@link Predicate filter} which values to include.
  ///
  /// @param connectionFactoryOptions a configured {@link ConnectionFactoryOptions}
  /// @param filter                   a {@link Predicate filter function} to include/exclude existing {@link Option}s.
  /// @return this {@link Builder}
  /// @throws IllegalArgumentException if {@code connectionFactoryOptions} or {@code filter} is {@code null}
         Builder _from(ConnectionFactoryOptions connectionFactoryOptions, Predicate<Option<?>> filter) {
            Assert.requireNonNull(connectionFactoryOptions, "connectionFactoryOptions must not be null");
            Assert.requireNonNull(filter, "filter must not be null");

            connectionFactoryOptions.options.forEach((k, v)  {
                if (filter.test(k)) {
                    options.addEntries([MapEntry(k, v)]);
                }
            });

            return this;
        }
}
