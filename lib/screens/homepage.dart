import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(68, 64, 77, 1),

        leading: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(245, 245, 245, 1),
            borderRadius: BorderRadius.circular(100), // Membuat bentuk bulat
          ),
          child: const Icon(
            Icons.menu,
            size: 24, // Ukuran ikon
          ),
        )
        ,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi, Sari!', style: TextStyle(
              fontSize: 15,
              color: Color.fromRGBO(245, 245, 245, 1),
            ),),
            Text('Welcome back', style: TextStyle(
              fontSize: 15,
              color: Color.fromRGBO(245, 245, 245, 1),
            )),
          ],
        ),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.person)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search Task",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Chip(
                  label: Text("Personal"),
                  backgroundColor: Colors.purple[300],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Task List's",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: 6, // Replace with the actual task count
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: Text(
                        "Task ${index + 1}",
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your "add task" action here
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple[800],
      ),
    );
  }
}