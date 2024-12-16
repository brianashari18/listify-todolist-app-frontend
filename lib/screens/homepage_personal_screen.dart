import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:listify/screens/homepage_workspace_screen.dart';
import 'package:listify/widgets/side_drawer.dart';
import 'package:listify/widgets/task_widget.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class HomePagePersonal extends StatefulWidget {
  const HomePagePersonal({super.key, required this.user});

  final User user;

  @override
  State<HomePagePersonal> createState() => _HomePagePersonalState();
}

class _HomePagePersonalState extends State<HomePagePersonal> {
  final TextEditingController _taskController = TextEditingController();

  List<Map<String, dynamic>> tasks = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService _apiService = ApiService();

  Color defaultColor = const Color.fromRGBO(123, 119, 148, 1);
  Color selectedColor = const Color.fromRGBO(123, 119, 148, 1);
  bool _isSelected = false;
  int? _editingTaskIndex;
  int? _deletingTaskIndex;
  int? _accessTaskIndex;

  @override
  void initState() {
    super.initState();
    getTask();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void addTask() async{
    try {
      final requestBody = <String, dynamic>{
        "name" : _taskController.text,
        "color" : selectedColor
      };
      
      final responseInput =
          await _apiService.addTask("/api/tasks", requestBody);

      if (responseInput.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Add Task Successful")),
        );

        print("Response: ${responseInput.body}");

      } else {
        // Registrasi gagal
        final responseData = jsonDecode(responseInput.body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Add Task Failed")),
        );
        print("Error: ${responseInput.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
      print("Exception: $e");
    }

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
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                  color: _isSelected ? selectedColor : defaultColor,  // Set the background color to the selected color
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.1),  // Optional border for better visibility
                  ),
                ),
                child: ElevatedButton(
                  onPressed: _colorOption,  // Open the color picker when clicked
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Make button background transparent
                    shadowColor: Colors.transparent, // Remove shadow
                    padding: EdgeInsets.zero,  // Remove default padding
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
                      if (_taskController.text.isNotEmpty) {
                        setState(() {
                          // Add task text and selected color to list
                          tasks.add({
                            'task': _taskController.text,
                            'color': selectedColor,
                          });
                          _isSelected = false;
                          _taskController.clear(); // Clear the text field
                        });
                      }
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(123, 119, 148, 1),
                      foregroundColor: const Color.fromRGBO(245, 245, 245, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
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

  void editTask(int index) {
    // Set the task index being edited
    setState(() {
      _editingTaskIndex = index;
      _taskController.text = tasks[index]['task'];
      selectedColor = tasks[index]['color'];
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                      if (_taskController.text.isNotEmpty) {
                        setState(() {
                          // Check if editing an existing task
                          if (_editingTaskIndex != null) {
                            // Update the existing task
                            tasks[_editingTaskIndex!] = {
                              'task': _taskController.text,
                              'color': selectedColor,
                            };
                          } else {
                            // Add new task
                            tasks.add({
                              'task': _taskController.text,
                              'color': selectedColor,
                            });
                          }
                          _isSelected = false;
                          _taskController.clear();
                          _editingTaskIndex = null; // Reset editing index
                        });
                      }
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(123, 119, 148, 1),
                      foregroundColor: const Color.fromRGBO(245, 245, 245, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
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

  void deleteTask(int index){
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
                      if (_taskController.text.isNotEmpty) {
                        setState(() {
                          // Check if editing an existing task
                          if (_editingTaskIndex != null) {
                            // Update the existing task
                            tasks[_editingTaskIndex!] = {
                              'task': _taskController.text,
                              'color': selectedColor,
                            };
                          } else {
                            // Add new task
                            tasks.add({
                              'task': _taskController.text,
                              'color': selectedColor,
                            });
                          }
                          _isSelected = false;
                          _taskController.clear();
                          _editingTaskIndex = null; // Reset editing index
                        });
                      }
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(123, 119, 148, 1),
                      foregroundColor: const Color.fromRGBO(245, 245, 245, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
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

  void accessTask(int index){

  }

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
                  selectedColor = color;  // Update selected color
                  _isSelected = true;      // Mark that a color has been selected
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
                  _isSelected = true; // Ensure that color change is applied immediately
                });
                Navigator.of(context).pop();  // Close the color picker dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void getTask() async {
    try {
      final responseInput =
          await _apiService.getTask("/api/users/${widget.user}/tasks");

      if (responseInput.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Retrieve Successful")),
        );
        print("Response: ${responseInput.body}");

        // Sample response body (already decoded)
        final Map<String, dynamic> responseBody = jsonDecode(responseInput.body);

// Extracting the "data" field (which is a list of maps)
        final List<dynamic> data = responseBody["data"];

// Initialize an empty list to hold the transformed tasks
        List<Map<String, dynamic>> tasks = [];

// Mapping the data to a new structure and adding to tasks
        data.map((item) {
          tasks.add({
            "text": item["name"],    // You can adjust the mapping as needed
            "color": item["color"],  // Example of mapping another field
            "isShared": item["isShared"], // Another field from the data
            // You can add more fields here if needed
          });
        });

// Now the tasks list contains the transformed data
        print(tasks);
      } else {

        final responseData = jsonDecode(responseInput.body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Task is Empty!")),
        );
        print("Error: ${responseInput.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred. Please try again.")),
      );
      print("Exception: $e");
    }
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
                  onPressed: (){
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (builder) => HomePageWorkspace(user: widget.user),
                      // ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(123, 119, 148, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    ),
                    child: const Text(
                      'Personal',
                      style: TextStyle(
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
                        onPressed: addTask, // Calls addTask when icon is pressed
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Color.fromRGBO(245, 245, 245, 1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 30.0,
                        mainAxisSpacing: 30.0,
                      ),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        String taskText = tasks[index]['task'];
                        Color taskColor = tasks[index]['color'];
                        return TaskWidget(
                          text: taskText,
                          color: taskColor,
                          index: index,
                          onEdit: (index) {
                            editTask(index);  // When Edit is selected
                          },
                          onDelete: (index) {
                            deleteTask(index); // When Delete is selected
                          },
                          onAccess: (index) {
                            accessTask(index);  // When Access is selected
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
}
