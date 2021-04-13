import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/home_cubit/home_cubit.dart';
import 'package:todo_app/shared/home_cubit/home_state.dart';
import 'package:todo_app/shared/widgets/no_tasks_yet.dart';
import 'package:todo_app/shared/widgets/task_child_body.dart';

class ArchivedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          List archiveTasks = HomeCubit.get(context).archiveTasks;
          return Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child:archiveTasks.length>0? ListView.builder(
        
              itemBuilder: (BuildContext context, index) {
                return tasksShowChild(index, context, archiveTasks);
              },
              itemCount: archiveTasks.length,
            ):noTasksYet(),
          );
        });
  
  }
}
