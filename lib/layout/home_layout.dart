import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/home_cubit/home_cubit.dart';
import 'package:todo_app/shared/home_cubit/home_state.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeCubit()..createDatabase(),
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {
          if (state is HomeInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          HomeCubit cubit = HomeCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
              centerTitle: true,
              backgroundColor: Colors.teal,
            ),
            body: state is HomeLoadingGetDatabaseState
                ? Center(child: CircularProgressIndicator())
                : cubit.bodyScreens[cubit.currentIndex],

            //========================
            floatingActionButtonLocation: cubit.isBottomSheetShown
                ? FloatingActionButtonLocation.centerFloat
                : FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton(
              child: cubit.isBottomSheetShown
                  ? Icon(Icons.check_rounded)
                  : Icon(Icons.add),
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState.validate()) {
                    cubit
                        .insertDatabase(
                            title: titleController.text,
                            time: timeController.text,
                            date: dateController.text)
                        .then((value) {
                      titleController.text = '';
                      timeController.text = '';
                      dateController.text = '';
                    });
                    cubit.changeBottomSheetShown(false);
                  } else {
                    return;
                  }
                } else {
                  scaffoldKey.currentState
                      .showBottomSheet((context) => bottomSheetBody(context))
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetShown(false);
                  });
                  cubit.changeBottomSheetShown(true);
                }
              },
            ),

            //========================
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.moveBottomNavigation(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.list_alt),
                    // ignore: deprecated_member_use
                    title: Text('Tasks')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),
                    // ignore: deprecated_member_use
                    title: Text('Done')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    // ignore: deprecated_member_use
                    title: Text('Archive')),
              ],
            ),
          );
        },
      ),
    );
  }

//========================
  Container bottomSheetBody(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .4,
      width: double.infinity,
      padding: EdgeInsets.only(top: 30, left: 20, right: 20),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            defaultFormedField(
                controller: titleController,
                prefixIcon: Icon(Icons.title),
                hintText: 'Task Tile',
                type: TextInputType.text,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'title must not be empty';
                  }
                  return null;
                },
                onTap: () {}),
            SizedBox(height: 10),
            defaultFormedField(
              readOnly: true,
                controller: timeController,
                prefixIcon: Icon(Icons.timer),
                hintText: 'Task time',
                type: TextInputType.datetime,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'time must not be empty';
                  }
                  return null;
                },
                onTap: () {
                  print('timing tapped');
                  showTimePicker(context: context, initialTime: TimeOfDay.now())
                      .then((value) {
                    timeController.text = value.format(context).toString();

                    print(value.format(context).toString());
                  });
                }),
            SizedBox(height: 10),
            defaultFormedField(
                            readOnly: true,

                controller: dateController,
                prefixIcon: Icon(Icons.date_range),
                hintText: 'Task Date',
                type: TextInputType.datetime,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Date must not be empty';
                  }
                  return null;
                },
                onTap: () {
                  print('Date tapped');
                  showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.parse('2050-12-12'))
                      .then((value) {
                    dateController.text =
                        DateFormat.yMMMd().format(value).toString();
                    print(DateFormat.yMMMd().format(value));
                  });
                })
          ],
        ),
      ),
    );
  }

//========================
  Container defaultFormedField({
    @required TextEditingController controller,
    @required Function validator,
    @required String hintText,
    @required Icon prefixIcon,
    @required TextInputType type,
    Function onTap,
    Function onChange,
    Function onSubmit,
    bool isPassword = false,
    bool readOnly = false,
  }) {
    return Container(
      height: 65,
      child: TextFormField(
        showCursor: true,
        readOnly: readOnly,
        keyboardType: type,
        obscureText: isPassword,
        controller: controller,
        validator: validator,
        onTap: onTap,
        onChanged: onChange,
        onFieldSubmitted: onSubmit,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 5),
          hintText: hintText,
          prefixIcon: prefixIcon,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(10.0)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(5.0)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(10.0)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(5.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(10.0)),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }
}
