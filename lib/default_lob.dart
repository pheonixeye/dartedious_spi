// ignore_for_file: non_constant_identifier_names

import 'package:rxdart/subjects.dart';

/// Abstract implementation for large object types.

class DefaultLob<T> {
  static final int NOT_DISCARDED = 0;

  static final int DISCARDED = 1;

  static final int NOT_CONSUMED = 0;

  static final int CONSUMED = 1;

  final PublishSubject<T> p;

  DefaultLob(this.p);

  PublishSubject<T> stream() {}

  PublishSubject<void> discard() {}
}
