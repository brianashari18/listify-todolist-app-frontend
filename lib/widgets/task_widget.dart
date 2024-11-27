import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120, // Lebar container
      height: 120, // Tinggi container
      decoration: BoxDecoration(
        color: const Color.fromRGBO(123, 119, 148, 1), // Warna latar menyerupai gambar
        borderRadius: BorderRadius.circular(10.0), // Sudut melengkung
      ),
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text, // Teks utama
                textAlign: TextAlign.center, // Teks di tengah
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white, // Warna teks putih
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 5, // Jarak dari atas
            right: 0, // Jarak dari kanan
            child:  IconButton(
              icon: const Icon(
                Icons.more_vert, // Ikon titik tiga
                size: 20, // Ukuran ikon sesuai gambar
                color: Colors.black,
              ),
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Pilih Aksi"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text("Edit"),
                            onTap: () {
                              print("Edit selected");
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: const Text("Delete"),
                            onTap: () {
                              print("Delete selected");
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: const Text("Access"),
                            onTap: () {
                              print("Access selected");
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },// Warna ikon hitam
            ),
          ),
        ],
      ),
    );
  }
}