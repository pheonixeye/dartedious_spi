import 'package:dartedious_spi/connection.dart';
import 'package:dartedious_spi/connection_factory_metadata.dart';
import 'package:rxdart/subjects.dart';

/// A factory for creating {@link Connection}s and entry point for a driver.
///
///  @See [Connection]
abstract class ConnectionFactory {
  /// Creates a new [Connection].
  ///
  /// @return the newly created [Connection]
  PublishSubject<Connection> create();

  /// Returns the {@link ConnectionFactoryMetadata} about the product this {@link ConnectionFactory} is applicable to.
  ///
  /// @return the {@link ConnectionFactoryMetadata} about the product this {@link ConnectionFactory} is applicable to
  ConnectionFactoryMetadata getMetadata();
}
