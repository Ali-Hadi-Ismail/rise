import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rise/models/task.dart';
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
  String _currentFilter = 'All';
  bool _isMenuOpen = false;

  @override
  void initState() {
    super.initState();

    context.read<TaskCubit>().getAllTasks();
  }

  void _filterTasks(String filter) {
    setState(() {
      _currentFilter = filter;
      _isMenuOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit, TaskCubitStates>(
      listener: (context, state) {
        if (state is TaskErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<TaskCubit>();

        List<Task> source;
        switch (_currentFilter) {
          case 'Complete':
            source = cubit.completeTasks;
            break;
          case 'Incomplete':
            source = cubit.incompleteTasks;
            break;
          default:
            source = cubit.allTasks;
        }

        final tasks = source.reversed.toList();

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFFf96060),
                title: Text(
                  'Work List',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 30),
                    child: Row(
                      children: [
                        PopupMenuButton<String>(
                          onOpened: () => setState(() => _isMenuOpen = true),
                          onCanceled: () => setState(() => _isMenuOpen = false),
                          onSelected: _filterTasks,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.white,
                          icon: const Icon(
                            Icons.filter_list,
                            color: Colors.white,
                          ),
                          offset: const Offset(0, 50),
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'All', child: Text('All')),
                            PopupMenuItem(
                                value: 'Incomplete', child: Text('Incomplete')),
                            PopupMenuItem(
                                value: 'Complete', child: Text('Complete')),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _currentFilter,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              body: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Slidable(
                    key: ValueKey(task.id),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      extentRatio: 0.2,
                      children: [
                        SlidableAction(
                          onPressed: (slideContext) async {
                            final cubit = context.read<TaskCubit>();
                            await cubit.deleteTask(task.id);
                          },
                          backgroundColor: const Color(0xFFf96060),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                        ),
                      ],
                    ),
                    child: Container(
                      width: double.infinity,
                      child: GestureDetector(
                        onLongPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => TaskDetailScreen(task: task),
                            ),
                          );
                        },
                        child: Taskcard(task: task),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isMenuOpen)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => setState(() => _isMenuOpen = false),
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
