import 'package:rxdart/subjects.dart';

/// A {@link Closeable} is an object that can be closed.  The {@link #close()} method is invoked to release resources that the object is holding (such as open connections).
abstract class Closable {
  /// Close this object and release any resources associated with it.  If the object is already closed, then {@link Publisher#subscribe(Subscriber) subscriptions} complete successfully and the
  /// close operation has no effect.
  ///
  /// @return a {@link Publisher} that termination is complete
  PublishSubject<void> close();
}
