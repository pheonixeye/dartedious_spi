import 'package:dartedious_spi/batch.dart';
import 'package:dartedious_spi/closable.dart';
import 'package:dartedious_spi/connection_metadata.dart';
import 'package:rxdart/subjects.dart';

abstract class Connection extends Closable {
  // PublishSubject<void> beginTransaction();

  PublishSubject<void> beginTransaction([TransactionDefinition? definition]);

  @override
  PublishSubject<void> close();

  PublishSubject<void> commitTransaction();

  Batch createBatch();

  PublishSubject<void> createSavepoint(String name);

  Statement createStatement(String sql);

  bool isAutoCommit();

  ConnectionMetadata getMetadata();

  IsolationLevel getTransactionIsolationLevel();

  PublishSubject<void> releaseSavepoint(String name);

  PublishSubject<void> rollbackTransaction();

  PublishSubject<void> rollbackTransactionToSavepoint(String name);

  PublishSubject<void> setAutoCommit(bool autoCommit);

  PublishSubject<void> setLockWaitTimeout(Duration timeout);

  PublishSubject<void> setStatementTimeout(Duration timeout);

  PublishSubject<void> setTransactionIsolationLevel(
      IsolationLevel isolationLevel);

  PublishSubject<bool> validate(ValidationDepth depth);
}
