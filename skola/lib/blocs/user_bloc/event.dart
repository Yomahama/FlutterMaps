import 'package:tracking_health/model/transaction.dart';

abstract class Event {}

class InsertUser extends Event {
  final Transaction transaction;

  InsertUser(this.transaction) : super();
}

class LoadUsers extends Event {}
