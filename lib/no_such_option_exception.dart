import 'package:dartedious_spi/_exceptions.dart';
import 'package:dartedious_spi/options.dart';

class NoSuchOptionException extends IllegalStateException {
  NoSuchOptionException(String message, {required this.option})
      : super(message);

  final Option<Any> option;

  Option<Any> getOption() {
    return option;
  }
}
