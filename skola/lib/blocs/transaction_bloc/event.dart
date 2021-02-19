import 'package:tracking_health/model/transaction.dart';

abstract class Event {}

class InsertTransaction extends Event {
  final Transaction transaction;

  InsertTransaction(this.transaction) : super();
}

class DeleteTransaction extends Event {
  final int id;

  DeleteTransaction(this.id) : super();
}

class LoadTransactions extends Event {}
