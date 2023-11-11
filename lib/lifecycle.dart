import 'package:rxdart/subjects.dart';

/// A common interface defining methods for allocation/release lifecycle control. The typical use case for this is to notify resources.
///
/// <p>Can be implemented by connections.  Components allocating/releasing connections notify resources implementing this interface about the ongoing activity so that resources can react in a proper
/// way (e.g. allocating or releasing associated resources).
///
/// @see Connection
/// @since 0.9
abstract class Lifecycle {
  /// Notifies the resource about its allocation.
  /// The method is called after creating a new resource or allocating a cached resource before applying any requests.  The resource is ready for usage after completion of the returned
  /// {@link Publisher}.
  ///
  /// @return a {@link Publisher} that indicates that the resource is ready for usage
  PublishSubject<void> postAllocate();

  /// Notifies the resource that it is about to be released.
  /// The method is called after finishing its usage and prior to its release/close.  The resource is ready for being released after completion of the returned {@link Publisher}.
  ///
  /// @return a {@link Publisher} that indicates that the resource is ready to be released
  PublishSubject<void> preRelease();
}
