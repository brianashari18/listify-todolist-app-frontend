import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:listify/screens/start_screen.dart';
import 'package:listify/services/task_service.dart';
import 'package:listify/services/user_service.dart';
import 'package:listify/services/workspace_service.dart';
import 'package:listify/widgets/side_drawer.dart';
import 'package:listify/widgets/task_widget.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key, required this.user});

  final User user;

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  final TextEditingController _taskController = TextEditingController();

  List<Task> tasks = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TaskService _taskService = TaskService();
  final UserService _userService = UserService();
  final WorkspaceService _workspaceService = WorkspaceService();

  Color defaultColor = const Color.fromRGBO(123, 119, 148, 1);
  Color selectedColor = const Color.fromRGBO(123, 119, 148, 1);
  bool _isSelected = false;
  int? _editingTaskIndex;
  int? _deletingTaskIndex;
  int? _accessTaskIndex;
  bool _isPersonal = true;

  @override
  void initState() {
    super.initState();
    getTasks(_isPersonal);
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideDrawer(),
      key: _scaffoldKey,
      endDrawerEnableOpenDragGesture: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(68, 64, 77, 1),
        title: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(245, 245, 245, 1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: IconButton(
                  icon: const Icon(
                    Icons.menu,
                    size: 20,
                    color: Color.fromRGBO(68, 64, 77, 1),
                  ),
                  onPressed: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, ${widget.user.username}!',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(245, 245, 245, 1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(245, 245, 245, 1),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(245, 245, 245, 1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.person,
                  size: 20,
                  color: Color.fromRGBO(68, 64, 77, 1),
                ),
                onPressed: () {
                  _userService.removeUser();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const StartScreen()),
                      (route) => false);
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(68, 64, 77, 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 35,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search Task",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black45,
                      ),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _isPersonal = !_isPersonal;
                      });
                      getTasks(_isPersonal);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(123, 119, 148, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                    ),
                    child: Text(
                      _isPersonal ? 'Personal' : 'Workspace',
                      style: const TextStyle(
                        color: Color.fromRGBO(245, 245, 245, 1),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: const Color.fromRGBO(45, 44, 55, 1),
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Task List's",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(245, 245, 245, 1),
                        ),
                      ),
                      IconButton(
                        onPressed: _addTask,
                        // Calls addTask when icon is pressed
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Color.fromRGBO(245, 245, 245, 1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Expanded(
                    child: tasks.isEmpty
                        ? const Center(
                            child: Text(
                              'List is Empty!',
                              style: TextStyle(color: Color(0xFFF5F5F5)),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 30.0,
                              mainAxisSpacing: 30.0,
                            ),
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              return TaskWidget(
                                task: tasks[index],
                                index: index,
                                onEdit: (index) {
                                  _editTask(index); // When Edit is selected
                                },
                                onDelete: (index) {
                                  _deleteTask(index); // When Delete is selected
                                },
                                onAccess: (index) {
                                  accessTask(index); // When Access is selected
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addTask() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the bottom sheet dynamic
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20), // Padding around bottom sheet
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Create New Task List",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _taskController,
                decoration: InputDecoration(
                  hintText: "Enter task description",
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  filled: true,
                  fillColor: const Color.fromRGBO(191, 191, 191, 1),
                ),
              ),
              const SizedBox(height: 10),
              // Display the selected color
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  color: _isSelected ? selectedColor : defaultColor,
                  // Set the background color to the selected color
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black.withOpacity(
                        0.1), // Optional border for better visibility
                  ),
                ),
                child: ElevatedButton(
                  onPressed: _colorOption, // Open the color picker when clicked
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    // Make button background transparent
                    shadowColor: Colors.transparent,
                    // Remove shadow
                    padding: EdgeInsets.zero, // Remove default padding
                  ),
                  child: const Text(
                    "Select Task Color",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _onAddSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(123, 119, 148, 1),
                      foregroundColor: const Color.fromRGBO(245, 245, 245, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 30),
                    ),
                    child: const Text("Create"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _onAddSubmit() async {
    if (_taskController.text.isNotEmpty) {
      final result = _isPersonal
          ? await _taskService.add(
              widget.user, _taskController.text, selectedColor)
          : await _workspaceService.add(
              widget.user, _taskController.text, selectedColor);
      if (result['success'] == 'true') {
        Task task = Task.fromJson(result['data']);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Task was added!')));
        setState(() {
          // Add task text and selected color to list
          tasks.add(task);
          _isSelected = false;
          _taskController.clear(); // Clear the text field
        });
      } else {
        final errorMessage = result['error'];
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
    Navigator.of(context).pop();
  }

  void _editTask(int index) {
    // Set the task index being edited
    setState(() {
      _editingTaskIndex = index;
      _taskController.text = tasks[index].title;
      selectedColor = tasks[index].color;
      _isSelected = true; // Mark that a task is being edited
    });

    // Show the bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit Task List",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _taskController,
                decoration: InputDecoration(
                  hintText: "Enter task description",
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black45,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  filled: true,
                  fillColor: const Color.fromRGBO(191, 191, 191, 1),
                ),
              ),
              const SizedBox(height: 10),
              // Display the selected color
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  color: _isSelected ? selectedColor : defaultColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: _colorOption,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    "Select Task Color",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _onEditSubmit(tasks[_editingTaskIndex!]);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(123, 119, 148, 1),
                      foregroundColor: const Color.fromRGBO(245, 245, 245, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 30),
                    ),
                    child: const Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _onEditSubmit(Task task) async {
    if (_taskController.text.isNotEmpty) {
      final result = _isPersonal
          ? await _taskService.edit(
              widget.user, task, _taskController.text, selectedColor)
          : await _workspaceService.edit(
              widget.user, task, _taskController.text, selectedColor);
      if (result['success'] == 'true') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Task was modified!')));
        setState(() {
          tasks[_editingTaskIndex!].title = _taskController.text;
          tasks[_editingTaskIndex!].color = selectedColor;

          _isSelected = false;
          _taskController.clear();
          _editingTaskIndex = null;
        });
      } else {
        final errorMessage = result['error'];
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
    Navigator.of(context).pop();
  }

  void _deleteTask(int index) {
    setState(() {
      _deletingTaskIndex = index;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Do you want to delete this task list?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _onDeleteSubmit(tasks[_deletingTaskIndex!]);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(123, 119, 148, 1),
                      foregroundColor: const Color.fromRGBO(245, 245, 245, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 30),
                    ),
                    child: const Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _onDeleteSubmit(Task task) async {
    final result = _isPersonal
        ? await _taskService.delete(widget.user, task)
        : await _workspaceService.delete(widget.user, task);
    if (result['success'] == 'true') {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Task was deleted!')));
      setState(() {
        tasks.removeAt(_deletingTaskIndex!);
        _isSelected = false;
        _deletingTaskIndex = null;
      });
    } else {
      final errorMessage = result['error'];
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
    Navigator.of(context).pop();
  }

  void accessTask(int index) {}

  void _colorOption() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _isSelected ? selectedColor : defaultColor,
              onColorChanged: (color) {
                // Immediate color update using setState
                setState(() {
                  selectedColor = color; // Update selected color
                  _isSelected = true; // Mark that a color has been selected
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _isSelected =
                      true; // Ensure that color change is applied immediately
                });
                Navigator.of(context).pop(); // Close the color picker dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void getTasks(bool isPersonal) async {
    print("TEST $isPersonal");
    final result = isPersonal
        ? await _taskService.loadTasks(widget.user)
        : await _workspaceService.loadTasks(widget.user);
    if (result['success'] == 'true') {
      final data = result['tasks'] as List;
      setState(() {
        tasks = data.map((taskJson) => Task.fromJson(taskJson)).toList();
      });
    } else if (result['error'] == 'Task not found') {
      setState(() {
        tasks = [];
      });
    } else {
      final errorMessage = result['error'];
      print(errorMessage);
    }
  }
}
