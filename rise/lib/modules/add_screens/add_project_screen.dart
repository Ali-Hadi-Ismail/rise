import 'package:flutter/material.dart';
import 'package:rise/models/task.dart';

// Using your existing Project model
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

class AddProjectScreen extends StatefulWidget {
  final Function(Project)? onProjectAdded;

  const AddProjectScreen({Key? key, this.onProjectAdded}) : super(key: key);

  @override
  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _deadline;
  int _priority = 1; // Default priority

  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Color> _priorityColors = [
    Colors.green, // Low priority
    Colors.blue, // Medium priority
    Colors.orange, // High priority
    Colors.red, // Urgent priority
  ];

  final List<String> _priorityLabels = [
    'Low',
    'Medium',
    'High',
    'Urgent',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
  }

  void _selectDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[400]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  void _saveProject() {
    if (_formKey.currentState!.validate()) {
      // Convert deadline to Unix timestamp (milliseconds since epoch)
      int deadlineTimestamp = _deadline?.millisecondsSinceEpoch ?? 0;

      // Create new project using your model
      Project newProject = Project(
        _titleController.text,
        _descriptionController.text,
        deadlineTimestamp,
        _priority,
      );

      // Call the callback if provided
      if (widget.onProjectAdded != null) {
        widget.onProjectAdded!(newProject);
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project created successfully')),
      );

      // Navigate back to projects list
      Navigator.pop(context, newProject);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Add Project',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeTransition(
        opacity: _animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(_animation),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Project Details'),
                    const SizedBox(height: 16),
                    _buildProjectNameField(),
                    const SizedBox(height: 20),
                    _buildDescriptionField(),
                    const SizedBox(height: 24),
                    const SizedBox(height: 16),
                    const SizedBox(height: 40),
                    _buildCreateProjectButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.blue[800],
      ),
    );
  }

  Widget _buildProjectNameField() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Project Name',
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a project name';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: InputBorder.none,
          ),
          maxLines: 3,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildCreateProjectButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _saveProject,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[400],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Create Project',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
