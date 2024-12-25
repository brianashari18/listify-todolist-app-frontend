import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listify/services/subtask_service.dart';

import '../models/access_model.dart';
import '../models/subtask_model.dart';
import '../models/user_model.dart';
import '../providers/access_provider.dart';
import '../providers/resource_provider.dart';

class TrashScreen extends ConsumerStatefulWidget {
  const TrashScreen({super.key});

  @override
  ConsumerState<TrashScreen> createState() {
    return _TrashScreenState();
  }
}

class _TrashScreenState extends ConsumerState<TrashScreen> {
  final SubTaskService _subTaskService = SubTaskService();
  List<SubTask> _subtasks = [];

  @override
  void initState() {
    final user = ref.read(userProvider);

    _getTrash(user!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);

    if (user == null) {
      return const CircularProgressIndicator();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF393646), // Background color
      appBar: AppBar(
        backgroundColor: const Color(0xFF393646),
        // Same as background
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Action for back button
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 90,
        title: const Text(
          "Trash",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 10),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _subtasks.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _subtasks[index].taskData,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).primaryColorLight,
                          decoration: TextDecoration.none,
                        ),
                  ),
                  Text(
                    '${_subtasks[index].deadline} | ${_subtasks[index].status}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).primaryColorLight,
                          decoration: TextDecoration.none,
                        ),
                  )
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        ref
                            .read(accessProvider.notifier)
                            .fetchAccessByTrash(user, _subtasks[index]);

                        final accessState = ref.watch(accessProvider);
                        final accessList =
                            accessState['accessList'] as List<Access>?;
                        final owner = accessState['owner'] as Access?;

                        if (accessList == null || owner == null) {
                          ref
                              .read(accessProvider.notifier)
                              .showNoPermissionMessage(context);
                        }

                        final access = ref
                            .read(accessProvider.notifier)
                            .getPermission(user, accessList!);
                        final isOwner = user.email == owner!.email;
                        final hasPermission =
                            access.access == 'Edit' || isOwner;

                        if (hasPermission) {
                          _restoreSubtask(index, user, _subtasks[index]);
                        } else {
                          ref
                              .read(accessProvider.notifier)
                              .showNoPermissionMessage(context);
                        }
                      },
                      icon: Icon(
                        Icons.restore,
                        color: Colors.grey,
                      )),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.grey),
                    onPressed: () async {
                      ref
                          .read(accessProvider.notifier)
                          .fetchAccessByTrash(user, _subtasks[index]);

                      final accessState = ref.watch(accessProvider);
                      final accessList =
                      accessState['accessList'] as List<Access>?;
                      final owner = accessState['owner'] as Access?;

                      if (accessList == null || owner == null) {
                        ref
                            .read(accessProvider.notifier)
                            .showNoPermissionMessage(context);
                      }

                      final access = ref
                          .read(accessProvider.notifier)
                          .getPermission(user, accessList!);
                      final isOwner = user.email == owner!.email;
                      final hasPermission =
                          access.access == 'Edit' || isOwner;

                      if (hasPermission) {
                        _deleteSubtask(index, user, _subtasks[index]);
                      } else {
                        ref
                            .read(accessProvider.notifier)
                            .showNoPermissionMessage(context);
                      }
                    },
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Divider(
                height: 0,
                color: Theme.of(context).primaryColorLight.withOpacity(0.2),
              ),
            );
          },
        ),
      ),
    );
  }

  void _getTrash(User user) async {
    final result = await _subTaskService.fetchDeletedSubTasks(user);
    if (result['success']) {
      final data = result['data'] as List;
      setState(() {
        _subtasks = data.map((subtask) {
          return SubTask.fromJson(subtask);
        }).toList();
      });
    } else if (result['error'] == 'Subtask not found') {
      setState(() {
        _subtasks = [];
      });
    } else {
      final errorMessage = result['error'];
      print(errorMessage);
    }
  }

  void _deleteSubtask(int index, User user, SubTask subtask) async {
    final result =
        await _subTaskService.deleteSubTaskPermanently(user, subtask.id);
    if (result['success']) {
      setState(() {
        _subtasks.removeAt(index);
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Subtask was removed permanently')));
    } else {
      final errorMessage = result['error'];
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  void _restoreSubtask(int index, User user, SubTask subtask) async {
    final result = await _subTaskService.restoreSubTask(user, subtask.id);
    if (result['success']) {
      setState(() {
        _subtasks.removeAt(index);
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Subtask was restored')));
    } else {
      final errorMessage = result['error'];
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }
}
