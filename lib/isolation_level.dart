// ignore_for_file: non_constant_identifier_names

import 'package:dartedious_spi/assert.dart';
import 'package:dartedious_spi/constant_pool.dart';
import 'package:dartedious_spi/options.dart';
import 'package:dartedious_spi/transaction_definition.dart';

class IsolationLevelConstantPool implements ConstantPool<IsolationLevel> {
  @override
  createConstant(String name, bool sensitive) {
    return IsolationLevel(name);
  }

  @override
  IsolationLevel valueOf(String name, bool sensitive) {
    // TODO: implement valueOf
    throw UnimplementedError();
  }
}

class IsolationLevel implements TransactionDefinition {
  static final ConstantPool<IsolationLevel> CONSTANTS =
      IsolationLevelConstantPool();

  /// The read committed isolation level.
  static final IsolationLevel READ_COMMITTED =
      IsolationLevel.valueOf("READ COMMITTED");

  /// The read uncommitted isolation level.
  static final IsolationLevel READ_UNCOMMITTED =
      IsolationLevel.valueOf("READ UNCOMMITTED");

  /// The repeatable read isolation level.
  static final IsolationLevel REPEATABLE_READ =
      IsolationLevel.valueOf("REPEATABLE READ");

  /// The serializable isolation level.
  static final IsolationLevel SERIALIZABLE =
      IsolationLevel.valueOf("SERIALIZABLE");

  final String sql;

  IsolationLevel(this.sql) : super();

  static IsolationLevel valueOf(String sql) {
    Assert.requireNonNull(sql, "sql must not be null");
    Assert.requireNonEmpty(sql, "sql must not be empty");

    return CONSTANTS.valueOf(sql, false);
  }

  @override
  T? getAttribute<T>(Option<T> option) {
    Assert.requireNonNull(option, "option must not be null");

    if (option == TransactionDefinition.ISOLATION_LEVEL) {
      return option.cast(this);
    }

    return null;
  }

  /// Returns the SQL string represented by each value.
  ///
  /// @return the SQL string represented by each value
  String asSql() {
    return sql;
  }

  @override
  String toString() {
    return "IsolationLevel{" "sql='" "$sql" '\'' '}';
  }
}
