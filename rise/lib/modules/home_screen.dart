import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rise/modules/detail_screen.dart/task_detail_screen.dart';
import 'package:rise/shared/cubit/task_%20cubit.dart';
import 'package:rise/shared/cubit/task_state.dart';
import 'package:rise/shared/widget/taskCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TaskCubit>(context).getAllTasks();
  }

  void _onSelected(String value) {
    setState(() {
      _isMenuOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit, TaskCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final TaskCubit cubit = TaskCubit.get(context);

        // Reverse the list of tasks
        final reversedTasks = cubit.allTasks.reversed.toList();

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFFf96060),
                centerTitle: true,
                title: Text(
                  "Work List",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: PopupMenuButton<String>(
                      onOpened: () {
                        setState(() {
                          _isMenuOpen = true;
                        });
                      },
                      onCanceled: () {
                        setState(() {
                          _isMenuOpen = false;
                        });
                      },
                      onSelected: _onSelected,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Colors.white,
                      icon: const Icon(
                        Icons.date_range_outlined,
                        color: Colors.white,
                      ),
                      offset: const Offset(0, 50),
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'All',
                          child: Text('All'),
                        ),
                        PopupMenuItem(
                          value: 'Incomplete',
                          child: Text('Incomplete'),
                        ),
                        PopupMenuItem(
                          value: 'Complete',
                          child: Text('Complete'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              body: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: reversedTasks.length,
                itemBuilder: (context, index) {
                  final task = reversedTasks[index];

                  return GestureDetector(
                    onLongPress: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TaskDetailScreen(task: task),
                        ),
                      );
                    },
                    child: Slidable(
                      key: ValueKey(task.id ?? index),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.2,
                        dismissible: DismissiblePane(
                          onDismissed: () {
                            cubit.dataHelper.deleteTask(task.id);
                            setState(() {});
                          },
                        ),
                        dragDismissible: true,
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              cubit.dataHelper.deleteTask(task.id);
                            },
                            backgroundColor: const Color(0xFFf96060),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                          ),
                        ],
                      ),
                      dragStartBehavior: DragStartBehavior.down,
                      closeOnScroll: true,
                      direction: Axis.horizontal,
                      useTextDirection: true,
                      enabled: true,
                      child: SizedBox(
                        width: double.infinity,
                        child: Taskcard(
                          task: task,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isMenuOpen)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isMenuOpen = false;
                    });
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
