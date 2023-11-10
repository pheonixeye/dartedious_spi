import 'package:dartedious_spi/assert.dart';

abstract class Predicate<T> {
  bool test(T t);

  Predicate<T> and(Predicate<T?> other) {
    Assert.requireNonNull(other, 'Argument <T> cannot be null.');
    return (t) => test(t) && other.test(t);
  }

  Predicate<T> negate() {
    return (t) => !test(t);
  }

  Predicate<T> or(Predicate<T> other) {
    Assert.requireNonNull(other, 'Argument <T> cannot be null.');
    return (t) => test(t) || other.test(t);
  }

  static  Predicate<T> isEqual<T>(Object? targetRef) {
        return (null == targetRef)
                ? Objects::isNull
                : (object) => targetRef.equals(object);
    }

    static  Predicate<T> not<T>(Predicate<T>? target) {
        Assert.requireNonNull(target, 'Argument <T> cannot be null.');
        return target!.negate();
    }
}
