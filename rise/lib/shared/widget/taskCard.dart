import 'package:flutter/material.dart';
import 'package:rise/models/task.dart';

class Taskcard extends StatefulWidget {
  final Task task;
  const Taskcard({
    required this.task,
    super.key,
  });

  @override
  State<Taskcard> createState() => _TaskcardState();
}

class _TaskcardState extends State<Taskcard> {
  Widget circleIcon(bool isCompleted) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: widget.task.isCompleted
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
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.task.isCompleted = !widget.task.isCompleted;
        });
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
              circleIcon(widget.task.isCompleted),
              const SizedBox(width: 20),
              _descriptionCard(),
              const Spacer(),
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: 10,
                height: 40,
                color: (widget.task.isCompleted)
                    ? Colors.red
                    : Colors.blue, // Just a placeholder
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _descriptionCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedOpacity(
          opacity: widget.task.isCompleted ? 0.5 : 1.0,
          duration: Duration(milliseconds: 500),
          child: Container(
            width: 200,
            child: Text(
              maxLines: 1,
              widget.task.title,
              style: TextStyle(
                fontSize: 19,
                overflow: TextOverflow.ellipsis,
                color: (widget.task.isCompleted) ? Colors.grey : Colors.black,
                decoration: widget.task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: Colors.grey,
                decorationThickness: 2.0,
              ),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: widget.task.isCompleted ? 0.5 : 1.0,
          duration: Duration(milliseconds: 500),
          child: Flexible(
            child: Text(
              maxLines: 1,
              widget.task.description,
              style: TextStyle(
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
                color: Colors.grey,
                decoration: widget.task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: Colors.grey,
                decorationThickness: 2.0,
              ),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: widget.task.isCompleted ? 0.5 : 1.0,
          duration: Duration(milliseconds: 500),
          child: Text(
            "9:00",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              decoration: widget.task.isCompleted
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
