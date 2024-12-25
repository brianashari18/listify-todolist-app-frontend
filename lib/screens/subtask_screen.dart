import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listify/screens/edit_subtask_screen.dart';
import 'package:listify/services/subtask_service.dart';
import '../models/access_model.dart';
import '../models/subtask_model.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';
import '../providers/access_provider.dart';
import '../providers/resource_provider.dart';
import '../widgets/calendar_bottom_sheet.dart';

class SubTaskScreen extends ConsumerStatefulWidget {
  const SubTaskScreen({super.key});

  @override
  ConsumerState<SubTaskScreen> createState() => _SubTaskScreenState();
}

class _SubTaskScreenState extends ConsumerState<SubTaskScreen> {
  final TextEditingController _subtaskController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final SubTaskService _subTaskService = SubTaskService();
  final GlobalKey _containerKey = GlobalKey();
  double _containerHeight = 0;
  List<SubTask> _subtasks = [];
  List<SubTask> _uncompletedSubtasks = [];
  List<SubTask> _completedSubtasks = [];

  // Use a list of SubTask objects
  String? _selectedStatus;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final user = ref.read(userProvider);
      final task = ref.read(activeTaskProvider);

      if (user != null && task != null) {
        _getSubtasks(user, task);
        ref.read(accessProvider.notifier).fetchAccess(user, task);
      } else {
        debugPrint('User or Task is null in TaskWidget.');
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final containerContext = _containerKey.currentContext;
      if (containerContext != null) {
        final renderBox = containerContext.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          setState(() {
            _containerHeight = renderBox.size.height;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _subtaskController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accessState = ref.watch(accessProvider);
    final user = ref.read(userProvider);
    final task = ref.read(activeTaskProvider);
    final accessList = accessState['accessList'] as List<Access>?;
    final owner = accessState['owner'] as Access?;

    if (accessList == null || owner == null || user == null) {
      return const CircularProgressIndicator();
    }

    final access =
        ref.read(accessProvider.notifier).getPermission(user, accessList);
    final isOwner = user.email == owner.email;
    final hasPermission = access.access == 'Edit' || isOwner;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(68, 64, 77, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  key: _containerKey,
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
                  constraints: BoxConstraints(
                    minHeight: 350,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                      BoxShadow(
                        color: Theme.of(context).primaryColor,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(40)),
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Theme.of(context).cardColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          task!.title,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: Theme.of(context).primaryColorLight,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '${_completedSubtasks.length} of ${_completedSubtasks.length + _uncompletedSubtasks.length} Tasks Done',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  color: Theme.of(context)
                                      .primaryColorLight
                                      .withOpacity(0.9)),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_containerHeight > 0)
                  Positioned(
                    top: _containerHeight - 30,
                    left: MediaQuery.of(context).size.width / 2 - 28,
                    child: FloatingActionButton(
                      onPressed: () {
                        if (hasPermission) {
                          _addSubTask(user, task);
                        } else {
                          ref
                              .read(accessProvider.notifier)
                              .showNoPermissionMessage(context);
                        }
                      },
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 6,
                      child: const Icon(Icons.add, color: Colors.black),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _uncompletedSubtasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: ClipRect(
                      child: InkWell(
                        onTap: () {
                          if (hasPermission) {
                            setState(() {
                              toggleTaskDone(index, user, task,
                                  _uncompletedSubtasks[index]);
                              print(
                                  _uncompletedSubtasks[index].status == 'Done');
                            });
                          } else {
                            ref
                                .read(accessProvider.notifier)
                                .showNoPermissionMessage(context);
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            _uncompletedSubtasks[index].status == 'Done'
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: _uncompletedSubtasks[index].status == 'Done'
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    title: InkWell(
                      onTap: () async {
                        bool? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditSubTaskScreen(subTask: _subtasks[index]),
                          ),
                        );

                        if (result == true) {
                          setState(() {
                            _getSubtasks(user, task);
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _uncompletedSubtasks[index].taskData,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: _uncompletedSubtasks[index].status ==
                                            'Done'
                                        ? Theme.of(context)
                                            .primaryColorLight
                                            .withOpacity(0.5)
                                        : Theme.of(context).primaryColorLight
                                  ),
                            ),
                            Text(
                              '${_uncompletedSubtasks[index].deadline} | ${_uncompletedSubtasks[index].status}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: _uncompletedSubtasks[index].status ==
                                            'Done'
                                        ? Theme.of(context)
                                            .primaryColorLight
                                            .withOpacity(0.5)
                                        : Theme.of(context).primaryColorLight,
                                    decoration:
                                        _uncompletedSubtasks[index].status ==
                                                'Done'
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                  ),
                            )
                          ],
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      onPressed: () async {
                        if (hasPermission) {
                          final success = await _deleteSubtask(
                              index, user, task, _uncompletedSubtasks[index]);

                          if (success) {
                            setState(() {
                              _uncompletedSubtasks.removeAt(index);
                            });
                          }
                        } else {
                          ref
                              .read(accessProvider.notifier)
                              .showNoPermissionMessage(context);
                        }
                      },
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Divider(
                      height: 0,
                      color:
                          Theme.of(context).primaryColorLight.withOpacity(0.2),
                    ),
                  );
                },
              ),
            ),
            if (_completedSubtasks.isNotEmpty)
              Text(
                'COMPLETED (${_completedSubtasks.length})',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color:
                          Theme.of(context).primaryColorLight.withOpacity(0.5),
                    ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 40),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _completedSubtasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: ClipRect(
                      child: InkWell(
                        onTap: () {
                          if (hasPermission) {
                            setState(() {
                              toggleTaskDone(
                                  index, user, task, _completedSubtasks[index]);
                              print(_completedSubtasks[index].status == 'Done');
                            });
                          } else {
                            ref
                                .read(accessProvider.notifier)
                                .showNoPermissionMessage(context);
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            _completedSubtasks[index].status == 'Done'
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: _completedSubtasks[index].status == 'Done'
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    title: InkWell(
                      onTap: () async {
                        bool? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditSubTaskScreen(subTask: _subtasks[index]),
                          ),
                        );

                        if (result == true) {
                          setState(() {
                            _getSubtasks(user, task);
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _completedSubtasks[index].taskData,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color:
                                        _completedSubtasks[index].status == 'Done'
                                            ? Theme.of(context)
                                                .primaryColorLight
                                                .withOpacity(0.5)
                                            : Theme.of(context).primaryColorLight,
                                    decoration:
                                        _completedSubtasks[index].status == 'Done'
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                  ),
                            ),
                            Text(
                              '${_completedSubtasks[index].deadline} | ${_completedSubtasks[index].status}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color:
                                        _completedSubtasks[index].status == 'Done'
                                            ? Theme.of(context)
                                                .primaryColorLight
                                                .withOpacity(0.5)
                                            : Theme.of(context).primaryColorLight,
                                    decoration:
                                        _completedSubtasks[index].status == 'Done'
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                  ),
                            )
                          ],
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.grey),
                      onPressed: () async {
                        final success = await _deleteSubtask(
                            index, user, task, _completedSubtasks[index]);

                        if (success) {
                          setState(() {
                            _completedSubtasks.removeAt(index);
                          });
                        }
                      },
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Divider(
                      height: 0,
                      color:
                          Theme.of(context).primaryColorLight.withOpacity(0.2),
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

  void _showCalendarModal(BuildContext context) async {
    DateTime? selectedDate = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return CalendarBottomSheet();
      },
    );

    if (selectedDate != null) {
      setState(() {
        print("TEST $selectedDate");
        _selectedDate = selectedDate;
        _deadlineController.text =
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      });
    }
  }

  void _addSubTask(User user, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Add New Subtask",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black54),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _subtaskController,
                  decoration: InputDecoration(
                    hintText: "Enter Subtask",
                    hintStyle:
                        const TextStyle(fontSize: 14, color: Colors.black45),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    filled: true,
                    fillColor: const Color.fromRGBO(191, 191, 191, 1),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _deadlineController,
                  readOnly: true,
                  onTap: () => _showCalendarModal(context),
                  decoration: InputDecoration(
                    hintText: "Deadline",
                    hintStyle:
                        const TextStyle(fontSize: 14, color: Colors.black45),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    filled: true,
                    fillColor: const Color.fromRGBO(191, 191, 191, 1),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  hint: const Text("Status"),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: const Color.fromRGBO(191, 191, 191, 1),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStatus = newValue;
                    });
                  },
                  items: <String>['On Progress', 'Done']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _onAddSubmit(user, task);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(123, 119, 148, 1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                      ),
                      child: const Text("Create"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onAddSubmit(User user, Task task) async {
    if (_subtaskController.text.isNotEmpty) {
      final result = await _subTaskService.addSubTask(user, task.id,
          _subtaskController.text, _deadlineController.text, _selectedStatus!);
      if (result['success']) {
        SubTask subTask = SubTask.fromJson(result['data']);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Subtask was added!')));
        setState(() {
          _subtasks.add(subTask);
          _splitSubtask();
          _subtaskController.clear();
          _deadlineController.clear();
          _selectedStatus = null;
        });
      } else {
        final errorMessage = result['error'];
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }

  void _getSubtasks(User user, Task task) async {
    final result = await _subTaskService.fetchSubTasks(user, task.id);
    if (result['success']) {
      final data = result['data'] as List;
      setState(() {
        _subtasks = data.map((subtask) => SubTask.fromJson(subtask)).toList();
        _splitSubtask();
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

  void _updateSubtask(int index, User user, Task task, SubTask subtask) async {
    final result = await _subTaskService.updateSubTask(user, task.id,
        subtask.id, subtask.taskData, subtask.deadline, subtask.status);
    if (result['success']) {
      setState(() {
        if (subtask.status == 'Done') {
          _uncompletedSubtasks.removeAt(index);
          _completedSubtasks.add(subtask);
          _completedSubtasks.sort((a, b) => a.id.compareTo(b.id));
        } else {
          _completedSubtasks.removeAt(index);
          _uncompletedSubtasks.add(subtask);
          _uncompletedSubtasks.sort((a, b) => a.id.compareTo(b.id));
        }
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Subtask was updated')));
      });
    } else {
      final errorMessage = result['error'];
      print('error update: $errorMessage');
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  Future<bool> _deleteSubtask(
      int index, User user, Task task, SubTask subtask) async {
    final result =
        await _subTaskService.deleteSubTask(user, task.id, subtask.id);
    if (result['success']) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Subtask was moved to trash')));

      return true;
    } else {
      final errorMessage = result['error'];
      print('error update: $errorMessage');
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));

      return false;
    }
  }

  void toggleTaskDone(int index, User user, Task task, SubTask subtask) {
    final updatedTask = SubTask(
        id: subtask.id,
        taskData: subtask.taskData,
        deadline: subtask.deadline,
        status: subtask.status == 'Done' ? 'On Progress' : 'Done',
        taskId: task.id);

    _updateSubtask(index, user, task, updatedTask);
  }

  void _splitSubtask() {
    _completedSubtasks = _subtasks
        .where(
          (element) => element.status == 'Done',
        )
        .toList();
    _uncompletedSubtasks = _subtasks
        .where(
          (element) => element.status == 'On Progress',
        )
        .toList();
  }
}
