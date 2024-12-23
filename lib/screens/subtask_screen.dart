import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/resource_provider.dart';
import '../widgets/calendar_bottom_sheet.dart';

class SubTask extends ConsumerStatefulWidget {
  const SubTask({super.key});

  @override
  ConsumerState<SubTask> createState() => _SubTaskState();
}

class _SubTaskState extends ConsumerState<SubTask> {
  final TextEditingController _subtaskController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  List<Map<String, dynamic>> tasks = [];
  String? _selectedStatus;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _subtaskController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final task = ref.read(activeTaskProvider);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(68, 64, 77, 1),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Container(
              height: 260,
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
                ],
              ),
            ),
          ),
          Positioned(
            top: 230,
            left: MediaQuery.of(context).size.width / 2 - 28,
            child: FloatingActionButton(
              onPressed: addTask,
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
              elevation: 6,
              child: const Icon(Icons.add, color: Colors.black),
            ),
          ),
          Positioned(
            top: 300,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                shrinkWrap: true,
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        setState(() {
                          toggleTaskDone(index);
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          tasks[index]["done"]
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color:
                              tasks[index]["done"] ? Colors.green : Colors.grey,
                        ),
                      ),
                    ),
                    title: Text(
                      "${tasks[index]["task"]} | ${tasks[index]["deadline"]} | ${tasks[index]["status"]}",
                      style: TextStyle(
                        color:
                            tasks[index]["done"] ? Colors.grey : Colors.white,
                        decoration: tasks[index]["done"]
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          tasks.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCalendarModal(BuildContext context) async {
    DateTime? selectedDate = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return CalendarBottomSheet();
      },
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
        _deadlineController.text =
        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      });
    }
  }

  void addTask() {
    final TextEditingController taskController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "ADD NEW TASK",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black54),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: taskController,
                  decoration: InputDecoration(
                    hintText: "Enter task",
                    hintStyle:
                    const TextStyle(fontSize: 14, color: Colors.black45),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    filled: true,
                    fillColor: const Color.fromRGBO(191, 191, 191, 1),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _deadlineController,
                  readOnly: true,
                  onTap: () => _showCalendarModal(context),
                  decoration: InputDecoration(
                    hintText: "Deadline",
                    hintStyle:
                    const TextStyle(fontSize: 14, color: Colors.black45),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    filled: true,
                    fillColor: const Color.fromRGBO(191, 191, 191, 1),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  hint: const Text("Status"),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: const Color.fromRGBO(191, 191, 191, 1),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStatus = newValue;
                    });
                  },
                  items: <String>['On Progress', 'Pending']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (taskController.text.isNotEmpty &&
                            _deadlineController.text.isNotEmpty &&
                            _selectedStatus != null) {
                          setState(() {
                            tasks.add({
                              "task": taskController.text,
                              "deadline": _deadlineController.text,
                              "status": _selectedStatus,
                              "done": false,
                            });
                            taskController.clear();
                            _deadlineController.clear();
                            _selectedStatus = null;
                          });
                        }
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(123, 119, 148, 1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                      ),
                      child: const Text("Done"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void toggleTaskDone(int index) {
    setState(() {
      // Toggle the "done" status
      tasks[index]["done"] = !(tasks[index]["done"] ?? false);

      // Menyusun ulang daftar tasks: tasks yang belum selesai di awal, dan tasks yang selesai di akhir
      tasks.sort((a, b) {
        if (a["done"] && !b["done"])
          return 1; // Pindahkan tugas selesai setelah tugas belum selesai
        if (!a["done"] && b["done"])
          return -1; // Tetap tugas belum selesai sebelum tugas selesai
        return 0; // Jaga urutan relatif jika keduanya sama
      });
    });
  }
}
