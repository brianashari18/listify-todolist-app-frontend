import 'package:flutter/material.dart';

class SubTask extends StatelessWidget {
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
              width: double.infinity,
              //color: const Color.fromRGBO(123, 119, 148, 1),
              padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 50.0),
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
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "3 of 4 Tasks Done",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // List task
          Positioned.fill(
            top: 240,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 160),
                child: Column(
                  children: [
                    const TaskItem(title: "Make Power Point", completed: false),
                    const SizedBox(height: 10),
                    const TaskItem(title: "Review Documents", completed: true),
                    const SizedBox(height: 10),
                    const TaskItem(title: "Finalize Draft", completed: true),
                  ],
                ),
              ),
            ),
          ),
          // Floating Action Button
          Positioned(
            top: 310, // Posisi tombol antara area terang dan gelap
            left: MediaQuery.of(context).size.width / 2 - 28, // Pusatkan tombol
            child: FloatingActionButton(
              onPressed: () {
                // Tambahkan aksi untuk tombol tambah
                print("Add Task Tapped");
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

  const TaskItem({Key? key, required this.title, required this.completed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completed ? Colors.purple[200] : Colors.grey,
            size: 45,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: completed ? Colors.grey[400] : Colors.white,
                fontSize: 25,
                decoration: completed ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          if (!completed)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: () {
                // Tambahkan logika hapus task di sini
                print("Delete Task: $title");
              },
            ),
        ],
      ),
    );
  }
}
