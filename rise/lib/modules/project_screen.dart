import 'package:flutter/material.dart';
import 'package:rise/models/task.dart';

// Import your existing Project model
class Project {
  List<Task> tasks = [];
  String title = '';
  String description = '';
  int deadline = 0;
  int priority = 0;
  int progress = 0;
  int id = 0;
  Project(String title, String description, int deadline, int priority) {
    this.title = title;
    this.description = description;
    this.deadline = deadline;
    this.priority = priority;
  }
}

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with SingleTickerProviderStateMixin {
  List<Project> projects = [];
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();

    // Sample data - replace with your actual data source
    _loadProjects();
  }

  void _loadProjects() {
    // Sample data - you would typically fetch this from a database or API
    projects = [
      Project('Personal', 'Personal tasks and goals', 0, 1)
        ..tasks = List.generate(10, (index) => Task()),
      Project('Teamworks', 'Collaborative tasks', 0, 2)
        ..tasks = List.generate(5, (index) => Task()),
      Project('Home', 'Household tasks', 0, 3)
        ..tasks = List.generate(10, (index) => Task()),
      Project('Meet', 'Meeting preparations', 0, 4)
        ..tasks = List.generate(10, (index) => Task()),
    ];
  }

  void _navigateToAddProject() {
    // Navigate to add project screen
    // You would implement this navigation to your form
    print('Navigate to add project screen');
  }

  Color _getProjectColor(int index) {
    // Define a set of colors for the circular indicators
    final List<Color> colors = [
      Colors.blue, // Personal
      Colors.pink, // Teamworks
      Colors.green, // Home
      Colors.purple, // Meet
    ];

    return index < colors.length ? colors[index] : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Projects',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: FadeTransition(
              opacity: _animation,
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: projects.length + 1, // +1 for the "Add" button
                itemBuilder: (context, index) {
                  if (index == projects.length) {
                    // This is the "Add" button card
                    return _buildAddProjectCard();
                  } else {
                    // These are the project cards
                    return _buildProjectCard(index);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(int index) {
    Project project = projects[index];
    Color projectColor = _getProjectColor(index);

    return GestureDetector(
      onTap: () {
        // Navigate to project details
        print('Navigate to ${project.title} details');
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: projectColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: projectColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                project.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${project.tasks.length} Tasks',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddProjectCard() {
    return GestureDetector(
      onTap: _navigateToAddProject,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[400],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

// Basic Task stub to make the example work
// You'll actually use your imported Task class
class Task {
  // Your Task model properties
}
