import 'package:tracking_health/model/transaction.dart';

abstract class State {}

class Loading extends State {}

class Loaded extends State {
  final List<Transaction> transactions;

  Loaded(this.transactions) : super();
}
