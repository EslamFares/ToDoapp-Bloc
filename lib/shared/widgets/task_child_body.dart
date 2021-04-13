import 'package:flutter/material.dart';
import 'package:todo_app/shared/home_cubit/home_cubit.dart';

Widget tasksShowChild(int index, context, List tasks) => Dismissible(
      key: Key(tasks[index]['id'].toString()),
      onDismissed: (direction) {
        HomeCubit.get(context).deleteData(id: tasks[index]['id']);
        Scaffold.of(context).showSnackBar(snackBarDelTask(context));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            color: Colors.teal, borderRadius: BorderRadius.circular(10.0)),
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              minRadius: 30,
              maxRadius: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    tasks[index]['time'].toString().split(" ")[0].toString(),
                  ),
                  Text(
                    tasks[index]['time'].toString().split(" ")[1].toString(),
                  ),
                ],
              ),
            ),
            SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tasks[index]['title'],
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  tasks[index]['date'],
                )
              ],
            ),
            Expanded(
                child: SizedBox(
              width: 10,
            )),
            Container(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.check_box,
                        size: 30,
                        color: tasks[index]['status'] == 'done'
                            ? Colors.white70
                            : Colors.black,
                      ),
                      onPressed: () {
                        if (tasks[index]['status'] != 'done') {
                          HomeCubit.get(context).updateData(
                              status: 'done', id: tasks[index]['id']);

                          print('done task...');
                        } else {
                          HomeCubit.get(context).updateData(
                              status: 'new', id: tasks[index]['id']);

                          print('become new task...');
                        }
                      }),
                  IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.archive,
                        size: 30,
                        color: tasks[index]['status'] == 'archive'
                            ? Colors.blue[900]
                            : Colors.black,
                      ),
                      onPressed: () {
                        if (tasks[index]['status'] != 'archive') {
                          HomeCubit.get(context).updateData(
                              status: 'archive', id: tasks[index]['id']);

                          print('archive task...');
                        } else {
                          HomeCubit.get(context).updateData(
                              status: 'new', id: tasks[index]['id']);

                          print('become new task...');
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );

SnackBar snackBarDelTask(context) {
  return SnackBar(
        backgroundColor: Colors.grey,
        elevation: 0,
        width: MediaQuery.of(context).size.width * .4,
        shape: StadiumBorder(),
        content: Container(
          height: 20,
          child: Center(
            child: Text(
              'Task Deleted ..',
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ),
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 1000),
      );
}
