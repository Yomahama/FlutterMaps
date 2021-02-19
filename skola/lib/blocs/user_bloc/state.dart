import 'package:tracking_health/model/user.dart';

abstract class State {}

class Loading extends State {}

class Loaded extends State {
  final List<User> users;

  Loaded(this.users) : super();
}
