import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/home_cubit/home_state.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());
  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List bodyScreens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  void moveBottomNavigation(int index) {
    currentIndex = index;
    emit(HomeChangeBottomNavState());
  }

  //==============================
  bool isBottomSheetShown = false;

  void changeBottomSheetShown(bool value) {
    isBottomSheetShown = value;
    emit(HomeChangeBottomSheetShownState());
  }

//=====================

  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 2,
      onCreate: (database, version) {
        print('DB createa ..');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) => print('table created .. '))
            .catchError(
              (error) =>
                  print('error when table was created ${error.toString()}'),
            );
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('DB open ..');
      },
    ).then((value) {
      database = value;
      emit(HomeCreateDatabaseState());
    });
  }

  insertDatabase({
    @required String title,
    @required String date,
    @required String time,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('date inserted successfully');
        emit(HomeInsertDatabaseState());

        getDataFromDatabase(database);

        print('$value raw inserted successfully .. ');
      }).catchError((e) {
        print('error when raw was created ${e.toString()}');
      });
      return null;
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(HomeLoadingGetDatabaseState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      print('tasks db come ..');
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == "archive") {
          archiveTasks.add(element);
        } else {
          doneTasks.add(element);
        }
      });
      emit(HomeGetDatabaseState());
    });
  }

  void updateData({
    @required String status,
    @required int id,
  }) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getDataFromDatabase(database);
      emit(HomeUpdateDatabaseState());
    });
  }

  void deleteData({
    @required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(HomeDeleteDatabaseState());
    });
  }
//=======================

}
