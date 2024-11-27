import 'package:flutter/material.dart';
import 'package:listify/widgets/task_widget.dart';

import '../models/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title, required this.user});

  final String title;
  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(68, 64, 77, 1),
        // Warna latar belakang AppBar
        title: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              width: 40,
              // Lebar lingkaran untuk ikon menu
              height: 40,
              // Tinggi lingkaran untuk ikon menu
              decoration: const BoxDecoration(
                color: Color.fromRGBO(245, 245, 245, 1),
                // Warna latar belakang lingkaran
                shape: BoxShape.circle, // Membuat lingkaran
              ),
              child: const Center(
                child: Icon(
                  Icons.menu,
                  size: 20, // Ukuran ikon
                  color: Color.fromRGBO(68, 64, 77, 1), // Warna ikon
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, ${widget.user.username}!',
                  style: const TextStyle(
                    fontSize: 16, // Ukuran font teks utama
                    color: Color.fromRGBO(245, 245, 245, 1), // Warna teks
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 14, // Ukuran font teks tambahan
                    color: Color.fromRGBO(245, 245, 245, 1), // Warna teks
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
            // Padding kanan untuk ikon profil
            child: Container(
              width: 40, // Lebar lingkaran untuk ikon profil
              height: 40, // Tinggi lingkaran untuk ikon profil
              decoration: const BoxDecoration(
                color: Color.fromRGBO(245, 245, 245, 1),
                // Warna latar belakang lingkaran
                shape: BoxShape.circle, // Membuat lingkaran
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.person,
                  size: 20, // Ukuran ikon profil
                  color: Color.fromRGBO(68, 64, 77, 1), // Warna ikon profil
                ),
                onPressed: () {
                  // Tambahkan aksi untuk ikon profil
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
                  height: 35, // Tinggi search bar
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search Task",
                      prefixIcon: const Icon(Icons.search, size: 20), // Ukuran ikon lebih kecil
                      isDense: true, // Mengurangi padding default
                      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15), // Padding di dalam field
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),

                // Hilangkan SizedBox atau kurangi jarak
                const SizedBox(height: 20.0), // Mengurangi jarak ke bawah
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(123, 119, 148, 1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text(
                    "Personal",
                    style: TextStyle(
                      color: Color.fromRGBO(245, 245, 245, 1),
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
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Color.fromRGBO(245, 245, 245, 1),
                          ))
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 30.0,
                        mainAxisSpacing: 30.0,
                      ),
                      itemCount: 6, // Ganti dengan jumlah data task yang ada
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
