import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracking_health/blocs/transaction_bloc/bloc.dart';
import 'package:tracking_health/screens/details_screen.dart';
import 'package:tracking_health/screens/main_screen.dart';
import 'package:tracking_health/blocs/user_bloc/bloc.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TransactionsBloc(),
        ),
        BlocProvider(
          create: (context) => UsersBloc(),
        ),
      ],
       child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.purple
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MainScreen(),
          '/details': (context) => DetailScreen(),
        },
      ),
    );
  }
}
