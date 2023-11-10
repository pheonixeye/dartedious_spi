import 'dart:typed_data';

import 'package:dartedious_spi/assert.dart';
import 'package:rxdart/subjects.dart';

/// Represents a handle to a large binary object.
abstract class BlobBase {
  /// Creates a new {@link Blob} wrapper that is backed by a {@link Publisher} of {@link ByteBuffer}.
  /// The wrapper subscribes and cancels the subscription immediately on {@link #discard()}.
  ///
  /// @param p the backing {@link Publisher} of {@link ByteBuffer}.
  /// @return the {@link Blob} wrapper
  BlobBase from<T>(PublishSubject<T> p);

  /// Returns the content stream as a {@link Publisher} emitting {@link ByteBuffer} chunks.
  /// <p>
  /// The content stream can be consumed ("subscribed to") only once.  Subsequent consumptions result in a {@link IllegalStateException}.
  /// <p>
  /// Once {@link Publisher#subscribe(Subscriber) subscribed}, {@link Subscription#cancel() canceling} the subscription releases resources associated with this {@link Blob}.
  ///
  /// @return a {@link Publisher} emitting {@link ByteBuffer} chunks.
  PublishSubject<ByteBuffer> stream();

  /// Release any resources held by the {@link Clob} when not subscribing to the {@link #stream() stream content}.
  ///
  /// @return a {@link Publisher} that termination is complete
  PublishSubject<void> discard();
}

class Blob extends BlobBase {
  late final DefaultLob lob;

  @override
  Blob from<ByteBuffer>(PublishSubject<ByteBuffer> p) {
    Assert.requireNonNull(p, "Publisher must not be null");

    lob = DefaultLob<ByteBuffer>(p);

    return Blob();
  }

  @override
  PublishSubject<void> discard() {
    return lob.discard();
  }

  @override
  PublishSubject<ByteBuffer> stream() {
    return lob.stream();
  }
}
