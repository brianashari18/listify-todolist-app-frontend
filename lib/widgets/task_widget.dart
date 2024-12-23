import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listify/providers/auth_provider.dart';
import 'package:listify/screens/subtask_screen.dart';

import '../models/access_model.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';
import '../providers/access_provider.dart';
import '../providers/resource_provider.dart';

enum Options { Edit, Delete, Access }

class TaskWidget extends ConsumerStatefulWidget {
  const TaskWidget(
      {super.key,
      required this.task,
      required this.onEdit,
      required this.onDelete,
      required this.onAccess,
      required this.index});

  final Task task;
  final Function(int index) onEdit;
  final Function(int index) onDelete;
  final Function(int index) onAccess;
  final int index;

  @override
  ConsumerState<TaskWidget> createState() {
    return _TaskWidgetState();
  }
}

class _TaskWidgetState extends ConsumerState<TaskWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final user = ref.read(userProvider);
      final task = ref.read(activeTaskProvider);

      if (user != null && task != null) {
        ref.read(accessProvider.notifier).fetchAccess(user, task);
      } else {
        debugPrint('User or Task is null in TaskWidget.');
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    final accessState = ref.watch(accessProvider);
    final user = ref.read(userProvider);

    if (accessState['accessList'] == null || user == null) {
      return const CircularProgressIndicator();
    }

    return InkWell(
      onTap: () async {
        ref.read(activeTaskProvider.notifier).state = widget.task;

        // Fetch access data
        final user = ref.read(userProvider);
        if (user != null) {
          await ref.read(accessProvider.notifier).fetchAccess(user, widget.task);
        }
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SubTask()));
      },
      child: Container(
        width: 120, // Lebar container
        height: 120, // Tinggi container
        decoration: BoxDecoration(
          color: widget.task.color, // Warna latar menyerupai gambar
          borderRadius: BorderRadius.circular(10.0), // Sudut melengkung
        ),
        child: Stack(
          children: [
            // Teks utama yang ditampilkan di tengah
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.task.title, // Teks utama
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
              top: 8,
              // Menyesuaikan posisi vertikal
              right: 8,
              // Menyesuaikan posisi horizontal agar tidak terlalu dekat dengan tepi kanan
              child: PopupMenuButton<Options>(
                key: ValueKey(widget.task.id),
                icon: const Icon(
                  Icons.more_vert, // Ikon titik tiga
                  size: 24, // Ukuran ikon sedikit lebih besar untuk kejelasan
                  color: Colors.white, // Warna ikon putih
                ),
                onSelected: (Options option) async {
                  ref.read(activeTaskProvider.notifier).state = widget.task;

                  // Fetch access data
                  final user = ref.read(userProvider);
                  if (user != null) {
                    await ref.read(accessProvider.notifier).fetchAccess(user, widget.task);
                  }

                  // Read updated state
                  final accessState = ref.read(accessProvider);
                  final accessList = accessState['accessList'] as List<Access>?;
                  final owner = accessState['owner'] as Access?;
                  if (accessList == null || owner == null || user == null) {
                    _showNoPermissionMessage(context);
                    return;
                  }

                  final access = getPermission(user, accessList);
                  final isOwner = user.email == owner.email;
                  final hasPermission = access.access == 'Edit' || isOwner;

                  debugPrint('Active Task: ${widget.task.title}');
                  debugPrint('Owner: ${owner.email}');
                  debugPrint('Access List: $accessList');

                  switch (option) {
                    case Options.Edit:
                      if (hasPermission) {
                        widget.onEdit(widget.index);
                      } else {
                        _showNoPermissionMessage(context);
                      }
                      break;
                    case Options.Delete:
                      if (hasPermission) {
                        widget.onDelete(widget.index);
                      } else {
                        _showNoPermissionMessage(context);
                      }
                      break;
                    case Options.Access:
                      widget.onAccess(widget.index);
                      break;
                  }
                },

                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<Options>(
                    value: Options.Edit,
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    // Remove padding to make it tighter
                    height: 20,
                    // Reduce the height of each menu item
                    child: Text(
                      "Edit",
                      style: TextStyle(
                          fontSize: 12,
                          height: 1.0), // Smaller text with tight height
                    ),
                  ),
                  const PopupMenuItem<Options>(
                    value: Options.Delete,
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    // Remove padding
                    height: 20,
                    // Same as above, reduce height
                    child: Text(
                      "Delete",
                      style: TextStyle(
                          fontSize: 12,
                          height: 1.0), // Smaller text with tight height
                    ),
                  ),
                  const PopupMenuItem<Options>(
                    value: Options.Access,
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    // Remove padding
                    height: 20,
                    // Same reduced height
                    child: Text(
                      "Access",
                      style: TextStyle(
                          fontSize: 12,
                          height: 1.0), // Smaller text with tight height
                    ),
                  ),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12.0), // Membuat sudut menu bulat
                ),
                color: Colors.white, // Background warna putih untuk pop-up menu
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNoPermissionMessage(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You don\'t have permission!')),
    );
  }

  Access getPermission(User user, List<Access> accessList) {
    return accessList.firstWhere(
      (access) => access.email == user.email,
      orElse: () => Access(email: user.email, access: 'None'), // Nilai default
    );
  }
}
