import 'package:dartedious_spi/assert.dart';
import 'package:dartedious_spi/default_lob.dart';
import 'package:rxdart/rxdart.dart';

/// Represents a handle to a large character object.
abstract class ClobBase {
  /// Creates a new {@link Clob} wrapper that is backed by a {@link Publisher} of {@link CharSequence} or its subtypes.
  /// The wrapper subscribes and cancels the subscription immediately on {@link #discard()}.
  ///
  /// @param p the backing {@link Publisher} of {@link CharSequence}.
  /// @return the {@link Clob} wrapper
  ClobBase from(PublishSubject<String> p);

  /// Returns the content stream as a {@link Publisher} emitting {@link CharSequence} chunks.
  /// <p>
  /// The content stream can be consumed ("subscribed to") only once.  Subsequent consumptions result in a {@link IllegalStateException}.
  /// <p>
  /// Once {@link Publisher#subscribe(Subscriber) subscribed}, {@link Subscription#cancel() canceling} the subscription releases resources associated with this {@link Clob}.
  ///
  /// @return a {@link Publisher} emitting {@link CharSequence} chunks.
  PublishSubject<String> stream();

  /// Release any resources held by the {@link Clob} when not subscribing to the {@link #stream() stream content}.
  ///
  /// @return a {@link Publisher} that termination is complete
  PublishSubject<void> discard();
}

class Clob implements ClobBase {
  late final DefaultLob<String> lob;
  @override
  ClobBase from(PublishSubject<String> p) {
    Assert.requireNonNull(p, "Publisher must not be null");

    lob = DefaultLob<String>(p);

    return Clob();
  }

  @override
  PublishSubject<String> stream() {
    return lob.stream();
  }

  @override
  PublishSubject<void> discard() {
    return lob.discard();
  }
}
