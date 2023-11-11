import 'package:dartedious_spi/_exceptions.dart';
import 'package:dartedious_spi/assert.dart';
import 'package:dartedious_spi/connection_factory.dart';
import 'package:dartedious_spi/connection_factory_options.dart';
import 'package:dartedious_spi/connection_factory_provider.dart';

final class ConnectionFactories {
  ConnectionFactories._();

  /// Returns a  [ConnectionFactory] if an available implementation can be
  /// created from a collection of [ConnectionFactoryOptions].
  ///
  /// @param [connectionFactoryOptions] a collection of [ConnectionFactoryOptions]
  /// @return the created {@link [ConnectionFactory]} if one can be created, otherwise {@code [null]}
  /// @throws [IllegalArgumentException] if {@code [connectionSpecification]} is {@code [null]}
  static ConnectionFactory? find(
      ConnectionFactoryOptions connectionFactoryOptions) {
    Assert.requireNonNull(
        connectionFactoryOptions, "connectionFactoryOptions must not be null");

    for (ConnectionFactoryProvider provider in _loadProviders()) {
      if (provider.supports(connectionFactoryOptions)) {
        return provider.create(connectionFactoryOptions);
      }
    }

    return null;
  }

  /// Returns a {@link ConnectionFactory} from an available implementation, created from a R2DBC Connection URL.
  /// R2DBC URL format is:
  /// {@code r2dbc:driver[:protocol]}://[user:password@]host[:port][/path][?option=value]}.
  ///
  /// @param url the R2DBC connection url
  /// @return the created {@link ConnectionFactory}
  /// @throws IllegalArgumentException if {@code url} is {@code null}
  /// @throws IllegalStateException    if no available implementation can create a {@link ConnectionFactory}
  static ConnectionFactory get(String url) {
    return _get(ConnectionFactoryOptions.parse(
        Assert.requireNonNull(url, "R2DBC Connection URL must not be null")));
  }

  /// Returns a {@link ConnectionFactory} from an available implementation,
  /// created from a collection of {@link ConnectionFactoryOptions}.
  ///
  /// @param connectionFactoryOptions a collection of {@link ConnectionFactoryOptions}
  /// @return the created {@link ConnectionFactory}
  /// @throws IllegalArgumentException if {@code connectionFactoryOptions} is {@code null}
  /// @throws IllegalStateException    if no available implementation can create a {@link ConnectionFactory}
  static ConnectionFactory _get(
      ConnectionFactoryOptions connectionFactoryOptions) {
    ConnectionFactory? connectionFactory = find(connectionFactoryOptions);

    if (connectionFactory == null) {
      throw IllegalStateException(
        "Unable to create a ConnectionFactory for '$connectionFactoryOptions'. Available drivers: [ ${_getAvailableDrivers()} ]",
      );
    }

    return connectionFactory;
  }

  /// Returns whether a {@link ConnectionFactory} can be created from a collection of {@link ConnectionFactoryOptions}.
  ///
  /// @param connectionFactoryOptions a collection of {@link ConnectionFactoryOptions}
  /// @return {@code true} if a {@link ConnectionFactory} can be created from a collection of {@link ConnectionFactoryOptions}, {@code false} otherwise.
  /// @throws IllegalArgumentException if {@code connectionFactoryOptions} is {@code null}
  static bool supports(ConnectionFactoryOptions? connectionFactoryOptions) {
    Assert.requireNonNull(
        connectionFactoryOptions, "connectionFactoryOptions must not be null");

    for (ConnectionFactoryProvider provider in _loadProviders()) {
      if (provider.supports(connectionFactoryOptions!)) {
        return true;
      }
    }

    return false;
  }

  static String _getAvailableDrivers() {
    StringBuffer availableDrivers = StringBuffer();

    for (ConnectionFactoryProvider provider in _loadProviders()) {
      if (availableDrivers.length != 0) {
        availableDrivers.write(", ");
      }
      availableDrivers.write(provider.getDriver());
    }

    if (availableDrivers.length == 0) {
      availableDrivers.write("None");
    }

    return availableDrivers.toString();
  }

  //TODO: implementation in dart ??
  static ServiceLoader<ConnectionFactoryProvider> _loadProviders() {
        return ServiceLoader.load(ConnectionFactoryProvider.class, ConnectionFactoryProvider.class.getClassLoader());
    }
}
