class R2dbcException implements Exception {
  final int errorCode;

  final String? _sqlState;

  final String? _sql;

  R2dbcException({
    required this.errorCode,
    String? sqlState,
    String? sql,
  })  : _sql = sql,
        _sqlState = sqlState;

  int getErrorCode() {
    return errorCode;
  }

  String? getSqlState() {
    return _sqlState;
  }

  String? getSql() {
    return _sql;
  }

  //HACK
  String? getMessage() {
    return runtimeType.toString();
  }

  @override
  String toString() {
    StringBuffer builder = StringBuffer();
    builder.write(this);

    if (getErrorCode() != 0 ||
        (getSqlState() != null && getSqlState()!.isNotEmpty) ||
        getMessage() != null) {
      builder.write(":");
    }

    if (getErrorCode() != 0) {
      builder.write(" [");
      builder.write(getErrorCode());
      builder.write("]");
    }

    if (getSqlState() != null && getSqlState()!.isNotEmpty) {
      builder.write(" [");
      builder.write(getSqlState());
      builder.write("]");
    }

    if (getMessage() != null) {
      builder.write(" ");
      builder.write(getMessage());
    }

    return builder.toString();
  }
}
