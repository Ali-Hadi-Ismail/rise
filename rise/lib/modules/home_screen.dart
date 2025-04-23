import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rise/models/task.dart';
import 'package:rise/shared/widget/taskCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMenuOpen = false;

  void _onSelected(String value) {
    setState(() {
      _isMenuOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFf96060),
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
                margin: EdgeInsets.symmetric(horizontal: 30),
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
                  icon: const Icon(Icons.date_range_outlined,
                      color: Colors.white),
                  offset: const Offset(0, 50),
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'Today',
                      child: Text('Today'),
                    ),
                    PopupMenuItem(
                      value: 'This Week',
                      child: Text('This Week'),
                    ),
                    PopupMenuItem(
                      value: 'This Month',
                      child: Text('This Month'),
                    ),
                    PopupMenuItem(
                      value: 'This Year',
                      child: Text('This Year'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16),
              itemCount: 8,
              itemBuilder: (context, index) {
                return Slidable(
                  key: ValueKey(index),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: 0.2,
                    children: [
                      SlidableAction(
                        onPressed: (context) {},
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: 0.2,
                    dismissible: DismissiblePane(
                      onDismissed: () {
                        setState(() {});
                      },
                    ),
                    dragDismissible: true,
                    children: [
                      SlidableAction(
                        onPressed: (context) {},
                        backgroundColor: Color(0xFFf96060),
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
                      task: Task("Create a Task", true, "This is the UI."),
                    ),
                  ),
                );
              }),
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
  }
}
