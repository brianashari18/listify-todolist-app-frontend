import 'package:flutter/material.dart';
import 'package:listify/screens/homepagePersonal_screen.dart';
import 'package:listify/screens/homepageWorkspace_screen.dart';
import 'package:listify/widgets/task_widget.dart';
import '../models/user_model.dart';

class HomePageWorkspace extends StatefulWidget {
  const HomePageWorkspace({super.key, required this.user});

  final User user;

  @override
  State<HomePageWorkspace> createState() => _HomePageWorkspaceState();
}

class _HomePageWorkspaceState extends State<HomePageWorkspace> {
  List<String> tasks = [];

  void addTask() {
    setState(() {
      tasks.add('New Task ${tasks.length + 1}');
    });
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
                          builder: (builder) => HomePagePersonal(user: widget.user)));

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(
                          123, 119, 148, 1), // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    ),
                    child: const Text(
                      'Workspace',
                      style: TextStyle(
                        color: Color.fromRGBO(245, 245, 245, 1),
                        fontWeight: FontWeight.normal,
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
                        onPressed: addTask, // Panggil addTask saat ikon ditekan
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
                        return TaskWidget(index: index);
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
