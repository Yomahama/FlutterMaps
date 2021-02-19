import 'status_enum.dart';

class Person {
  String name;
  String surname;
  double money;
  Status status;

  Person(this.name, this.surname, this.money, this.status) {
    this.name = name;
    this.surname = surname;
    this.money = money;
    this.status = status;
  }

  @override
  bool operator ==(Object o) =>
      o is Person && o.name == name && o.surname == surname;

  int get hashCode => name.hashCode ^ name.hashCode;

  int compareTo(Person o) {
    if (this.name == null || o.name == null) return null;

    int cn = this.name.compareTo(o.name);

    if (cn == 0) {
      int cs = this.surname.compareTo(surname);

      if (cs == 0) {
        return o.money.compareTo(this.money);
      }

      return cs;
    }

    return cn;
  }
}
