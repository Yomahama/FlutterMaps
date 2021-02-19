import 'package:tracking_health/model/person.dart';
import 'package:tracking_health/model/status_enum.dart';

class Transaction {
  int id;
  String nameHas;
  String surnameHas;
  String nameNeed;
  String surnameNeed;

  double money;

  Transaction(
      {this.id,
      this.nameHas,
      this.surnameHas,
      this.nameNeed,
      this.surnameNeed,
      this.money});

  List<Person> convertToPoeple() {
    List<Person> people = [];

    Person personThatHas =
        new Person(this.nameHas, this.surnameHas, this.money, Status.has);
    Person personThatNeeds =
        new Person(this.nameNeed, this.surnameNeed, this.money, Status.need);

    people.add(personThatHas);
    people.add(personThatNeeds);

    return people;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameHas': nameHas,
      'surnameHas': surnameHas,
      'nameNeed': nameNeed,
      'surnameNeed': surnameNeed,
      'money': money
    };
  }

  Transaction.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        nameHas = map['nameHas'],
        surnameHas = map['surnameHas'],
        nameNeed = map['nameNeed'],
        surnameNeed = map['surnameNeed'],
        money = map['money'];
}
