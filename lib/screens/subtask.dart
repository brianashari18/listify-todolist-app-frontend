import 'package:flutter/material.dart';

class SubTask extends StatefulWidget {
  const SubTask({super.key});

  @override
  State<SubTask> createState() => _SubTaskState();
}

class _SubTaskState extends State<SubTask> {
  final List<Map<String, dynamic>> _tasks = [
    {"title": "Make Power Point", "completed": false},
    {"title": "Review Documents", "completed": true},
    {"title": "Finalize Draft", "completed": true},
  ];

  void _addTask(String taskTitle) {
    setState(() {
      _tasks.add({"title": taskTitle, "completed": false});
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]["completed"] = !_tasks[index]["completed"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(68, 64, 77, 1),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Header dengan sudut membulat
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Container(
              height: 260, // Atur tinggi header sampai tombol plus
              width: double.infinity,
              color: const Color.fromRGBO(123, 119, 148, 1),
              padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Project Management",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const SizedBox(height: 8),
                  // const Text(
                  //   "3 of 4 Tasks Done",
                  //   style: TextStyle(
                  //     color: Colors.white70,
                  //     fontSize: 20,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          // Daftar Tugas
          Positioned.fill(
            top: 260, // Mulai setelah header
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  children: _tasks.asMap().entries.map((entry) {
                    int index = entry.key;
                    var task = entry.value;
                    return Column(
                      children: [
                        TaskItem(
                          title: task["title"],
                          completed: task["completed"],
                          onToggle: () => _toggleTaskCompletion(index),
                          onDelete: () => _deleteTask(index),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          // Tombol Plus
          Positioned(
            top: 230, // Sesuaikan posisi tombol
            left: MediaQuery.of(context).size.width / 2 - 28,
            child: FloatingActionButton(
              onPressed: () {
                // Tambahkan aksi menambah task
                showDialog(
                  context: context,
                  builder: (context) => AddTaskDialog(onSubmit: _addTask),
                );
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.add, color: Colors.black),
              shape: const CircleBorder(),
              elevation: 6,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget Task Item
class TaskItem extends StatelessWidget {
  final String title;
  final bool completed;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskItem({
    Key? key,
    required this.title,
    required this.completed,
    required this.onToggle,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Icon(
              completed ? Icons.check_circle : Icons.radio_button_unchecked,
              color: completed ? Colors.purple[200] : Colors.grey,
              size: 35,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: completed ? Colors.grey[400] : Colors.white,
                fontSize: 20,
                decoration: completed ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.grey),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

// Dialog untuk menambahkan tugas
class AddTaskDialog extends StatefulWidget {
  final Function(String) onSubmit;

  const AddTaskDialog({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Task"),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: "Enter task title",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSubmit(_controller.text);
            Navigator.pop(context);
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}
