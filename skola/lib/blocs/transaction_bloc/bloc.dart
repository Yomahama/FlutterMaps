
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_health/blocs/transaction_bloc/event.dart';
import 'package:tracking_health/blocs/transaction_bloc/state.dart';
import 'package:tracking_health/database/database.dart';

class TransactionsBloc extends Bloc<Event, State> {
  @override
  State get initialState => Loading();

  @override
  Stream<State> mapEventToState(Event event) async* {
    final DBProvider _db = DBProvider.db;

    Stream<State> _reload() async* {
      final transactions = await _db.getTransactions();
      yield Loaded(transactions);
    }

    if (event is LoadTransactions) {
      yield Loading();
      yield* _reload();
    } else if (event is InsertTransaction) {
      _db.insertTransaction(event.transaction);
      yield* _reload();
    } else if (event is DeleteTransaction) {
      _db.deleteTransaction(event.id);
      yield* _reload();
    }
  }
}
