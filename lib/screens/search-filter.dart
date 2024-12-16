import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String selectedFilter = 'On Going';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF393646), // Warna background ungu tua
      appBar: AppBar(
        backgroundColor: Color(0xFF393646),
        elevation: 0,
        automaticallyImplyLeading: false,

      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 4.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search your task",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.arrow_back),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
            ),
            SizedBox(height: 20),

            // Filter Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterButton(
                    title: 'On Going',
                    isSelected: selectedFilter == 'On Going',
                    onTap: () {
                      setState(() {
                        selectedFilter = 'On Going';
                      });
                    }),
                FilterButton(
                    title: 'Pending',
                    isSelected: selectedFilter == 'Pending',
                    onTap: () {
                      setState(() {
                        selectedFilter = 'Pending';
                      });
                    }),
                FilterButton(
                    title: 'Done',
                    isSelected: selectedFilter == 'Done',
                    onTap: () {
                      setState(() {
                        selectedFilter = 'Done';
                      });
                    }),
              ],
            ),
            SizedBox(height: 20),

            // Grid View
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 8, // Jumlah item grid
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget untuk Filter Button
class FilterButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  FilterButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF6D5D6E) : Color(0xFF4F4557),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
