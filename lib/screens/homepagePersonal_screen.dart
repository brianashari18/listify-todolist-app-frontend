import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:listify/screens/homepageWorkspace_screen.dart';
import 'package:listify/widgets/task_widget.dart';
import '../models/user_model.dart';

class HomePagePersonal extends StatefulWidget {
  const HomePagePersonal({super.key, required this.user});

  final User user;

  @override
  State<HomePagePersonal> createState() => _HomePagePersonalState();
}

class _HomePagePersonalState extends State<HomePagePersonal> {
  final TextEditingController _taskController = TextEditingController();
  List<String> tasks = [];
  Color selectedColor = const Color.fromRGBO(123, 119, 148, 1);

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void addTask() {
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
                  fontSize: 16,
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
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  filled: true,
                  fillColor: const Color.fromRGBO(191, 191, 191, 1),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Select Task Color",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_taskController.text.isNotEmpty) {
                        setState(() {
                          // Add task text and selected color to list
                          tasks.add(_taskController.text);
                          _taskController.text = ''; // Clear the text field
                        });
                      }
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(123, 119, 148, 1),
                      foregroundColor: const Color.fromRGBO(245, 245, 245, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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

  void _colorOption() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close the color picker dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: const Center(
                child: Icon(
                  Icons.menu,
                  size: 20,
                  color: Color.fromRGBO(68, 64, 77, 1),
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
                onPressed: () {},
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
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => HomePageWorkspace(user: widget.user),
                      ));
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
                        return TaskWidget(text: tasks[index]);
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
