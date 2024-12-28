import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listify/screens/about_screen.dart';
import 'package:listify/screens/help_center_screen.dart';
import 'package:listify/screens/homepage_screen.dart';
import 'package:listify/screens/setting_screen.dart';
import 'package:listify/screens/trash_screen.dart';

import '../providers/auth_provider.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final userAsyncValue = ref.watch(authProvider);

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
                child: Center(child: Image.asset("assets/images/logo.png")),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(Icons.folder_copy_outlined),
              title: const Text('Task List'),
              onTap: () {
                userAsyncValue.when(
                    data: (data) => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => HomepageScreen(user: data!))),
                    error: (error, stackTrace) => print(error),
                    loading: () {
                      const CircularProgressIndicator();
                    });
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Trash'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => TrashScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help Center'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HelpCenter()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => settingPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Us'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => AboutPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
