import 'package:flutter/material.dart';

enum Options { Edit, Delete, Access }

class TaskWidget extends StatelessWidget {
  const TaskWidget({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120, // Lebar container
      height: 120, // Tinggi container
      decoration: BoxDecoration(
        color: color, // Warna latar menyerupai gambar
        borderRadius: BorderRadius.circular(10.0), // Sudut melengkung
      ),
      child: Stack(
        children: [
          // Teks utama yang ditampilkan di tengah
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
          // Posisi ikon titik tiga
          Positioned(
            top: 8, // Menyesuaikan posisi vertikal
            right: 8, // Menyesuaikan posisi horizontal agar tidak terlalu dekat dengan tepi kanan
            child: PopupMenuButton<Options>(
              icon: const Icon(
                Icons.more_vert, // Ikon titik tiga
                size: 24, // Ukuran ikon sedikit lebih besar untuk kejelasan
                color: Colors.white, // Warna ikon putih
              ),
              onSelected: (Options option) {
                // Menangani aksi yang dipilih
                switch (option) {
                  case Options.Edit:
                    print("Edit selected");
                    break;
                  case Options.Delete:
                    print("Delete selected");
                    break;
                  case Options.Access:
                    print("Access selected");
                    break;
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<Options>(
                  value: Options.Edit,
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10), // Remove padding to make it tighter
                  height: 20, // Reduce the height of each menu item
                  child: Text(
                    "Edit",
                    style: TextStyle(fontSize: 12, height: 1.0), // Smaller text with tight height
                  ),
                ),
                const PopupMenuItem<Options>(
                  value: Options.Delete,
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10), // Remove padding
                  height: 20, // Same as above, reduce height
                  child: Text(
                    "Delete",
                    style: TextStyle(fontSize: 12, height: 1.0), // Smaller text with tight height
                  ),
                ),
                const PopupMenuItem<Options>(
                  value: Options.Access,
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10), // Remove padding
                  height: 20, // Same reduced height
                  child: Text(
                    "Access",
                    style: TextStyle(fontSize: 12, height: 1.0), // Smaller text with tight height
                  ),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0), // Membuat sudut menu bulat
              ),
              color: Colors.white, // Background warna putih untuk pop-up menu
            ),
          ),
        ],
      ),
    );
  }
}
