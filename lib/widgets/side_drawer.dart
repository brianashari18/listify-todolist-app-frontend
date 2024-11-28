import 'package:flutter/material.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Drawer(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: deviceHeight - deviceHeight * 0.68,
              padding: const EdgeInsets.all(10),
              child: DrawerHeader(
                child: Center(
                  child: Image.asset("assets/images/logo.png")
                ),
              ),
            ),
            const SizedBox(height: 10,),
            ListTile(
              leading: const Icon(Icons.folder_copy_outlined),
              title: const Text('Task List'),
              onTap: () {},
            ),ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Trash'),
              onTap: () {},
            ),ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help Center'),
              onTap: () {},
            ),ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {},
            ), ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Us'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
  
}