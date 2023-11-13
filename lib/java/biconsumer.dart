// abstract class BiConsumer<T, U> {
//   void accept(T t, U u);
// }

typedef BiConsumer<T, U> = void Function(T, U);

extension Accept<T, U> on BiConsumer<T, U> {
  void accept(T t, U u, [Function(T, U)? override]) {
    override ?? (t, u);
  }
}
