
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_health/blocs/user_bloc/event.dart';
import 'package:tracking_health/blocs/user_bloc/state.dart';
import 'package:tracking_health/database/database.dart';

class UsersBloc extends Bloc<Event, State> {
  @override
  State get initialState => Loading();

  @override
  Stream<State> mapEventToState(Event event) async* {
    final DBProvider _db = DBProvider.db;

    Stream<State> _reload() async* {
      final users = await _db.getUsers();
      yield Loaded(users);
    }

    if (event is LoadUsers) {
      yield Loading();
      yield* _reload();
    } else if (event is InsertUser) {
      _db.insertTransaction(event.transaction);
      yield* _reload();
    }
  }
}
