import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_health/blocs/transaction_bloc/state.dart' as stateClass;
import 'package:tracking_health/blocs/transaction_bloc/bloc.dart';
import 'package:tracking_health/blocs/transaction_bloc/event.dart';
import 'package:tracking_health/model/transaction.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void initState() {
    super.initState();

    _loadTransactions();
  }

  TransactionsBloc _bloc;
  int _selectedIndex = 0;

  void _onTappedItem(int index) {
    setState(() => _selectedIndex = index);
  }

  _loadTransactions() {
    _bloc = BlocProvider.of<TransactionsBloc>(context);
    _bloc.add(LoadTransactions());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<TransactionsBloc, stateClass.State>(
          builder: (context, state) {
            if (state is stateClass.Loading) {
              Transaction t = Transaction(
                  nameHas: 'Rimas',
                  surnameHas: 'Paul',
                  nameNeed: 'Ignas',
                  surnameNeed: 'Budr',
                  money: 20.12);

              List<Transaction> list = [];

              list.add(t);
              return _dataTable(list); //_blankScreen();
            } else if (state is stateClass.Loaded) {
              return _dataTable(state.transactions);
            }

            return SingleChildScrollView(); //_blankScreen();
          },
        ),
        bottomNavigationBar: _bottomNavigationBar(),
      ),
    );
  }

  Widget _dataTable(List<Transaction> transactions) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
              columns: [
                DataColumn(
                    label: Text(
                  'KAS',
                  style: TextStyle(color: Colors.grey),
                )),
                DataColumn(
                    label: Text(
                  'KAM',
                  style: TextStyle(color: Colors.grey),
                )),
                DataColumn(
                    label: Text(
                  'KIEK',
                  style: TextStyle(color: Colors.grey),
                )),
              ],
              rows: transactions
                  .map((t) => DataRow(cells: [
                        DataCell(Text(t.nameHas.toUpperCase())),
                        DataCell(Text(t.nameNeed.toUpperCase())),
                        DataCell(Text(t.money.toString().toUpperCase()))
                      ]))
                  .toList()),
        ));
  }

  Widget _blankScreen() {
    return Container(
      child: Text('Niekas niekam neskolingas!'),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.note),
          label: 'Pervedimai',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.details),
          label: 'Skolos',
        ),
      ],
      backgroundColor: Colors.grey[700],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.red,
      onTap: _onTappedItem,
    );
  }
}
