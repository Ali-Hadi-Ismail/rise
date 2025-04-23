import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rise/models/project.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _project = "";
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isAnytime = true;
  List<String> _members = [];
  late AnimationController _animationController;
  late Animation<double> _animation;
  late List<Project> P = [
    Project("Project 1", "Description 1", 0, 0),
    Project("Project 2", "Description 2", 0, 0),
    Project("Project 3", "Description 3", 0, 0),
    Project("Project 4", "Description 4", 0, 0),
    Project("Project 5", "Description 5", 0, 0),
    Project("Project 6", "Description 6", 0, 0),
    Project("Project 7", "Description 7", 0, 0),
    Project("Project 8", "Description 8", 0, 0),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  // Function to handle back button press
  void _handleBackPress() {
    Navigator.pop(context);
  }

  // Function to handle date selection
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(
          const Duration(days: 365)), // Allow past dates for personal tracking
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.red,
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
        _selectedDate = picked;
        _isAnytime = false;

        // If we've just selected a date and there's no time yet, open the time picker
        if (_selectedTime == null) {
          _selectTime(context);
        }
      });
    }
  }

  // Function to handle time selection
  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.red,
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
        _selectedTime = picked;
        _isAnytime = false;
      });
    }
  }

  // Function to toggle between Anytime and specific date
  void _toggleDateSelection() {
    setState(() {
      _isAnytime = !_isAnytime;
      if (_isAnytime) {
        _selectedDate = null;
        _selectedTime = null;
      } else if (_selectedDate == null) {
        _selectedDate = DateTime.now();
        _selectTime(context);
      }
    });
  }

  // Function to format date and time for display
  String _formatDateTime() {
    if (_isAnytime) {
      return "Anytime";
    } else if (_selectedDate != null) {
      String dateStr = DateFormat('MMM d').format(_selectedDate!);
      if (_selectedTime != null) {
        return "$dateStr at ${_selectedTime!.format(context)}";
      }
      return dateStr;
    }
    return "Anytime";
  }

  void _createTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'project': _project,
        'dueDate': _isAnytime ? 'Anytime' : _selectedDate,
        'dueTime': _selectedTime?.format(context),
        'createdAt': DateTime.now().toString(),
      };

      _animationController.reverse().then((_) {
        _titleController.clear();
        _descriptionController.clear();
        _selectedDate = null;
        _selectedTime = null;
        _isAnytime = true;
        _members = [];

        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('New Task'),
        backgroundColor: Colors.red,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBackPress,
        ),
      ),
      body: FadeTransition(
        opacity: _animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.1),
            end: Offset.zero,
          ).animate(_animation),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAssigneProject(),
                      const SizedBox(height: 20),
                      _buildTitleField(),
                      const SizedBox(height: 20),
                      _buildDescriptionField(),
                      const SizedBox(height: 20),
                      _buildDueDateTimeSelector(),
                      const SizedBox(height: 20),
                      const SizedBox(height: 32),
                      _buildAddTaskButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // UI Components

  Widget _buildAssigneProject() {
    return Row(
      children: [
        const Text('Project : ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(width: 16),
        _buildDropdownButton('Project', _project, (value) {
          setState(() {
            _project = value ?? '';
          });
        }, P),
      ],
    );
  }

  Widget _buildDropdownButton(String hint, String value,
      Function(String?) onChanged, List<Project> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(hint),
          value: value.isEmpty ? null : value,
          onChanged: onChanged,
          items: items.map((Project project) {
            return DropdownMenuItem<String>(
              value: project.title,
              child: Text(project.title),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Title',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a task title';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 5,
      decoration: InputDecoration(
        labelText: 'Description',
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        // Note: Removed the attachment icon as requested
      ),
    );
  }

  Widget _buildDueDateTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Due Date & Time',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isAnytime
                            ? "Select date"
                            : DateFormat('MMM d, yyyy').format(_selectedDate!),
                        style: TextStyle(
                          color: _isAnytime ? Colors.grey : Colors.black,
                        ),
                      ),
                      const Icon(Icons.calendar_today, size: 18),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InkWell(
                onTap: () =>
                    _selectedDate != null ? _selectTime(context) : null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: _selectedDate == null
                        ? Colors.grey.shade100
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedTime == null
                            ? "Select time"
                            : _selectedTime!.format(context),
                        style: TextStyle(
                          color: _selectedTime == null
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                      const Icon(Icons.access_time, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _toggleDateSelection,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(
                  _isAnytime ? Icons.check_box_outline_blank : Icons.check_box,
                  color: Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Anytime (no specific deadline)",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddTaskButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _createTask,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        child: const Text(
          'Add Task',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
