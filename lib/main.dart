import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/bloc_observer.dart';
// import 'modules/favourite/favourite_screen.dart';
// import 'modules/counter/counter_screen.dart';
import 'package:todo_app/layout/home_layout.dart';

void main() {
  Bloc.observer = MyBlocObserver();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:   HomeLayout(),//CounterScreen(), //FavouriteScreen(),
    );
  }
}
