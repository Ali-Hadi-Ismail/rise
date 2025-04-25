import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rise/models/task.dart';
import 'package:rise/shared/cubit/task_%20cubit.dart';

import 'package:rise/shared/cubit/task_state.dart';

class Taskcard extends StatelessWidget {
  final Task task;

  const Taskcard({
    required this.task,
    super.key,
  });

  Widget circleIcon(bool isCompleted) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: isCompleted
          ? Icon(
              Icons.check_circle_rounded,
              key: ValueKey(true),
              color: Colors.red,
              size: 35,
            )
          : Icon(
              Icons.circle_outlined,
              key: ValueKey(false),
              color: Colors.blue,
              size: 35,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskCubitStates>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            // Call the toggleTaskCompletion method from the cubit
            TaskCubit.get(context).toggleTaskCompletion(task);
          },
          child: Card(
            elevation: 2,
            margin: EdgeInsets.all(20),
            shadowColor: Colors.black,
            surfaceTintColor: Colors.white38,
            child: SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                children: [
                  const SizedBox(width: 30),
                  circleIcon(task.isCompleted),
                  const SizedBox(width: 20),
                  _descriptionCard(),
                  const Spacer(),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: 10,
                    height: 40,
                    color: (task.isCompleted) ? Colors.red : Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Column _descriptionCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedOpacity(
          opacity: task.isCompleted ? 0.5 : 1.0,
          duration: Duration(milliseconds: 500),
          child: Container(
            width: 200,
            child: Text(
              task.title,
              maxLines: 1,
              style: TextStyle(
                fontSize: 19,
                overflow: TextOverflow.ellipsis,
                color: (task.isCompleted) ? Colors.grey : Colors.black,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: Colors.grey,
                decorationThickness: 2.0,
              ),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: task.isCompleted ? 0.5 : 1.0,
          duration: Duration(milliseconds: 500),
          child: Text(
            task.description,
            maxLines: 1,
            style: TextStyle(
              fontSize: 16,
              overflow: TextOverflow.ellipsis,
              color: Colors.grey,
              decoration: task.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              decorationColor: Colors.grey,
              decorationThickness: 2.0,
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: task.isCompleted ? 0.5 : 1.0,
          duration: Duration(milliseconds: 500),
          child: Text(
            "9:00",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              decoration: task.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              decorationColor: Colors.grey,
              decorationThickness: 2.0,
            ),
          ),
        ),
      ],
    );
  }
}
