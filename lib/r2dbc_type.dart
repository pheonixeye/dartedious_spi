// ignore_for_file: constant_identifier_names

import 'dart:typed_data';

enum R2dbcType implements Type {
  /// Identifies the generic SQL type {@code CHAR}.
  CHAR(String),

  /// Identifies the generic SQL type {@code VARCHAR}.
  VARCHAR(String),

  /// Identifies the generic SQL type {@code NCHAR}.
  NCHAR(String),

  /// Identifies the generic SQL type {@code NVARCHAR}.
  NVARCHAR(String),

  /// Identifies the generic SQL type {@code CLOB}.
  /// Note that drivers may default to {@link Clob} if materializing a {@code CLOB} value requires additional database communication.
  CLOB(String),

  /// Identifies the generic SQL type {@code NCLOB}.
  /// Note that drivers may default to {@link Clob} if materializing a {@code NCLOB} value requires additional database communication.
  NCLOB(String),

  // ----------------------------------------------------
  // Boolean types
  // ----------------------------------------------------

  /// Identifies the generic SQL type {@code BOOLEAN}.
  BOOLEAN(bool),

  // ----------------------------------------------------
  // Binary types
  // ----------------------------------------------------

  /// Identifies the generic SQL type {@code BINARY}.
  BINARY(ByteBuffer),

  /// Identifies the generic SQL type {@code VARBINARY}.
  VARBINARY(ByteBuffer),

  /// Identifies the generic SQL type {@code BLOB}.
  /// Note that drivers may default to {@link Blob} if materializing a {@code BLOB} value requires additional database communication.
  BLOB(ByteBuffer),

  // ----------------------------------------------------
  // Numeric types
  // ----------------------------------------------------

  /// Identifies the generic SQL type {@code INTEGER}.
  INTEGER(int),

  /// Identifies the generic SQL type {@code TINYINT}.
  TINYINT(int),

  /// Identifies the generic SQL type {@code SMALLINT}.
  SMALLINT(int),

  /// Identifies the generic SQL type {@code BIGINT}.
  BIGINT(int),

  /// Identifies the generic SQL type {@code NUMERIC}.
  NUMERIC(double),

  /// Identifies the generic SQL type {@code DECIMAL}.
  DECIMAL(double),

  /// Identifies the generic SQL type {@code FLOAT}.
  FLOAT(double),

  /// Identifies the generic SQL type {@code REAL}.
  REAL(double),

  /// Identifies the generic SQL type {@code DOUBLE}.
  DOUBLE(double),

  // ----------------------------------------------------
  // Date/Time types
  // ----------------------------------------------------

  /// Identifies the generic SQL type {@code DATE}.
  DATE(DateTime),

  /// Identifies the generic SQL type {@code TIME}.
  TIME(DateTime),

  /// Identifies the generic SQL type {@code TIME WITH TIME ZONE}.
  TIME_WITH_TIME_ZONE(Duration),

  /// Identifies the generic SQL type {@code TIMESTAMP}.
  TIMESTAMP(DateTime),

  /// Identifies the generic SQL type {@code TIMESTAMP WITH TIME ZONE}.
  TIMESTAMP_WITH_TIME_ZONE(Duration),

  /// Identifies the generic SQL type {@code ARRAY}.
  COLLECTION(List<Object>);

  final Type type;
  const R2dbcType(this.type);

  Type getJavaType() {
    return type;
  }

  String getName() {
    return name;
  }
}
