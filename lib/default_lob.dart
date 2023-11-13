// ignore_for_file: non_constant_identifier_names

import 'package:dartedious_spi/_exceptions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

/// Abstract implementation for large object types.

class DefaultLob<T> {
  static final int NOT_DISCARDED = 0;

  static final int DISCARDED = 1;

  static final int NOT_CONSUMED = 0;

  static final int CONSUMED = 1;

  int discarded = NOT_DISCARDED;

  int consumed = NOT_CONSUMED;

  final PublishSubject<T> p;

  DefaultLob(this.p);

  PublishSubject<T> stream() {
    if (discarded == DISCARDED) {
      p.doOnError((p0, p1) {
        throw IllegalStateException("Source stream was already released");
      });
    }

    if (consumed == NOT_CONSUMED) {
      p.doOnError((p0, p1) {
        IllegalStateException("Source stream was already consumed");
      });
    }
    return p;
  }

  PublishSubject<void> discard() {
    return PublishSubject(
      onListen: () {
        bool completed = false;
        //TODO:
      },
    );
  }
}
