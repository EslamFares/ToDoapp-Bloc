import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/home_cubit/home_cubit.dart';
import 'package:todo_app/shared/home_cubit/home_state.dart';
import 'package:todo_app/shared/widgets/no_tasks_yet.dart';
import 'package:todo_app/shared/widgets/task_child_body.dart';

class NewTasksScreen extends StatelessWidget {
  bool checkBoxValue = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          List newTasks = HomeCubit.get(context).newTasks;
          return Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: newTasks.length > 0
                ? ListView.builder(
                    itemBuilder: (BuildContext context, index) {
                      return tasksShowChild(index, context, newTasks);
                    },
                    itemCount: newTasks.length,
                  )
                : noTasksYet(),
          );
        });
  }

  }
