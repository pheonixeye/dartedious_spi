import 'package:dartedious_spi/connection_factory.dart';
import 'package:dartedious_spi/connection_factory_options.dart';

abstract class ConnectionFactoryProvider {
  /// Creates a new {@link ConnectionFactory} given a collection of {@link ConnectionFactoryOptions}.  This method is only called if a previous invocation of
  /// {@link #supports(ConnectionFactoryOptions)} has returned {@code true}.
  ///
  /// @param connectionFactoryOptions a collection of {@link ConnectionFactoryOptions}
  /// @return the {@link ConnectionFactory} created from this collection of {@link ConnectionFactoryOptions}
  /// @throws IllegalArgumentException if {@code connectionFactoryOptions} is {@code null}
  ConnectionFactory create(ConnectionFactoryOptions connectionFactoryOptions);

  /// Whether this {@link ConnectionFactoryProvider} supports this collection of {@link ConnectionFactoryOptions}.
  ///
  /// @param connectionFactoryOptions a collection of {@link ConnectionFactoryOptions}
  /// @return {@code true} if this {@link ConnectionFactoryProvider} supports this collection of {@link ConnectionFactoryOptions}, {@code false} otherwise
  /// @throws IllegalArgumentException if {@code connectionFactoryOptions} is {@code null}
  bool supports(ConnectionFactoryOptions connectionFactoryOptions);

  /// Returns the driver identifier used by the driver.
  /// The identifier for drivers would be the value applicable to {@link ConnectionFactoryOptions#DRIVER}
  ///
  /// @return the driver identifier used by the driver
  String getDriver();
}
