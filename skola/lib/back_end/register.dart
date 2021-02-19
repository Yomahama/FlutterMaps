import 'package:tracking_health/model/person.dart';
import 'package:tracking_health/model/transaction.dart';
import 'package:tracking_health/model/status_enum.dart';

class PeopleRegister {
  List<Person> _peopleThatHave = [];
  List<Person> _peopleThatNeed = [];

  PeopleRegister(List<Transaction> transactions) {
    List<Person> converted = _convert(transactions);
    List<Person> supressed = _supress(converted);
    _splitAndAdd(supressed);
  }

  List<Person> _convert(List<Transaction> transactions) {
    List<Person> converted = [];

    for (Transaction transaction in transactions) {
      Person personThatHas = Person(transaction.nameHas, transaction.surnameHas,
          transaction.money, Status.has);
      Person personThatNeeds = Person(transaction.nameNeed,
          transaction.surnameNeed, transaction.money, Status.need);

      converted.add(personThatHas);
      converted.add(personThatNeeds);
    }

    return converted;
  }

  List<Person> _supress(List<Person> converted) {
    List<Person> supressed = [];

    for (int i = 0; i < converted.length; i++) {
      Person person = converted[i];
      int index = supressed.indexOf(person);
      if (index > 0 && supressed[index].status == Status.has) {
        supressed[index].money += person.money;
      } else if (index > 0 && supressed[index].status == Status.need) {
        supressed[index].money -= person.money;
      } else {
        supressed.add(person);
      }
    }

    return _assign(supressed);
  }

  List<Person> _assign(List<Person> empty) {
    List<Person> supressed = [];

    for (Person person in empty) {
      if (person.money < 0.0) {
        Person p = Person(
            person.name, person.surname, person.money * -1.0, Status.need);
        supressed.add(p);
      } else if (person.money != 0.0) {
        Person p =
            Person(person.name, person.surname, person.money, Status.has);
        supressed.add(p);
      }
    }

    return supressed;
  }

  void _splitAndAdd(List<Person> supressed) {
    for (Person person in supressed) {
      if (person.status == Status.has)
        _peopleThatHave.add(person);
      else
        _peopleThatNeed.add(person);
    }

    _peopleThatHave.sort((a, b) => a.compareTo(b));
    _peopleThatNeed.sort((a, b) => a.compareTo(b));
  }

  List<Transaction> findTransfers() {
    List<Transaction> transactions = [];

    for (Person personThatNeeds in _peopleThatNeed) {
      for (Person personThatHas in _peopleThatHave) {
        if (personThatHas.money > personThatNeeds.money) {
          if (personThatHas != personThatNeeds) {
            transactions.add(Transaction(
              id: null,
              nameHas: personThatHas.name,
              surnameHas: personThatHas.surname,
              nameNeed: personThatNeeds.name,
              surnameNeed: personThatNeeds.surname,
              money: personThatNeeds.money,
            ));
          }
          personThatHas.money -= personThatNeeds.money;
          personThatNeeds.money = 0.0;
        }
        if (personThatHas.money == personThatNeeds.money) {
          personThatHas.money = 0.0;
          personThatNeeds.money = 0.0;

          if (personThatHas != personThatNeeds) {
            transactions.add(Transaction(
              id: null,
              nameHas: personThatHas.name,
              surnameHas: personThatHas.surname,
              nameNeed: personThatNeeds.name,
              surnameNeed: personThatNeeds.surname,
              money: personThatNeeds.money,
            ));
          }
        }
        if (personThatHas.money < personThatNeeds.money) {
          personThatNeeds.money -= personThatHas.money;
          personThatHas.money = 0.0;

          if (personThatHas != personThatNeeds) {
            transactions.add(Transaction(
              id: null,
              nameHas: personThatHas.name,
              surnameHas: personThatHas.surname,
              nameNeed: personThatNeeds.name,
              surnameNeed: personThatNeeds.surname,
              money: personThatNeeds.money,
            ));
          }
        }

        if (personThatNeeds.money == 0.0) {
          break;
        }
      }
    }

    return transactions;
  }
}
