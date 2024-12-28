import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listify/models/access_model.dart';
import 'package:listify/providers/resource_provider.dart';

import '../models/task_model.dart';
import '../models/user_model.dart';
import '../providers/access_provider.dart';

class AccessScreen extends ConsumerStatefulWidget {
  const AccessScreen({super.key});

  @override
  ConsumerState<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends ConsumerState<AccessScreen> {
  final TextEditingController _accessController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<String> accessTypes = ['View', 'Edit'];
  String? _selectedAccessAdd = 'View';
  String? _selectedAccessUpdate;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    final task = ref.read(activeTaskProvider);
    ref.read(accessProvider.notifier).fetchAccess(user!, task!);
  }

  @override
  void dispose() {
    super.dispose();
    _accessController.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accessState = ref.watch(accessProvider);
    final owner = accessState['owner'] as Access;
    final accessList = accessState['accessList'] as List<Access>;
    final user = ref.read(userProvider);
    final task = ref.read(activeTaskProvider);
    final isOwner = user!.email == owner.email;

    if (owner.email == 'No Owner Found') {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
        body: Container(
      color: Theme.of(context).primaryColorDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 350,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 70),
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
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(40))),
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
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back_ios_new,
                              color: Theme.of(context).cardColor),
                        ],
                      )),
                ),
                Text(
                  task!.title,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Theme.of(context).primaryColorLight,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _accessController,
                    enabled: isOwner,
                    // TextField hanya dapat diakses jika pengguna adalah owner
                    style:
                        Theme.of(context).primaryTextTheme.bodyMedium!.copyWith(
                              color: isOwner
                                  ? Theme.of(context).primaryColorLight
                                  : Theme.of(context)
                                      .primaryColorLight
                                      .withOpacity(0.5),
                            ),
                    decoration: InputDecoration(
                      hintText:
                          isOwner ? "Add People" : "You don't have permission",
                      hintStyle: Theme.of(context)
                          .primaryTextTheme
                          .bodyMedium!
                          .copyWith(
                            fontSize: 14,
                            color: Theme.of(context)
                                .primaryColorLight
                                .withOpacity(isOwner ? 0.47 : 0.25),
                          ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      filled: true,
                      fillColor: const Color(0xFF2D2C37).withOpacity(0.75),
                      prefixIcon: Icon(
                        Icons.person_add_alt_1,
                        color: Theme.of(context)
                            .primaryColorLight
                            .withOpacity(isOwner ? 0.6 : 0.3),
                        size: 20,
                      ),
                    ),
                    onChanged: isOwner
                        ? (value) {
                            if (value.isNotEmpty) {
                              _addBuildPopUp(user, task);
                            }
                          }
                        : null, // Tidak ada aksi jika bukan owner
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'People With Access',
                    style: Theme.of(context)
                        .primaryTextTheme
                        .headlineSmall!
                        .copyWith(
                            color: Theme.of(context).primaryColorLight,
                            fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                      height: 0,
                      color:
                          Theme.of(context).primaryColorLight.withOpacity(0.2)),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    title: Text(owner.email,
                        style: Theme.of(context)
                            .primaryTextTheme
                            .bodyMedium!
                            .copyWith(
                                color: Theme.of(context).primaryColorLight)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      // Ensure the Row only takes necessary space
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 24),
                          child: Text(
                            'Owner',
                            style: Theme.of(context)
                                .primaryTextTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context).primaryColorLight),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                      height: 0,
                      color:
                          Theme.of(context).primaryColorLight.withOpacity(0.2)),
                  Expanded(
                      child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: accessList.length,
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    itemBuilder: (context, index) {
                      Access userAccess = accessList[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        title: Text(userAccess.email,
                            style: Theme.of(context)
                                .primaryTextTheme
                                .bodyMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).primaryColorLight)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          // Ensure the Row only takes necessary space
                          children: [
                            Text(
                              userAccess.access,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color:
                                          Theme.of(context).primaryColorLight),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              onPressed: () {
                                if (isOwner) {
                                  _editBuildPopUp(
                                      user, task, accessList, index);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'You don\'t have permission to set an access')));
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 0,
                        color: Theme.of(context)
                            .primaryColorLight
                            .withOpacity(0.2),
                      );
                    },
                  )),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }

  void _addBuildPopUp(User user, Task task) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColorDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Share ${task.title}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Theme.of(context).primaryColorLight),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _accessController,
                          focusNode: _focusNode,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context).primaryColorLight),
                          decoration: InputDecoration(
                            hintText: "Add People",
                            hintStyle: Theme.of(context)
                                .primaryTextTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .primaryColorLight
                                      .withOpacity(0.47),
                                ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            filled: true,
                            fillColor:
                                const Color(0xFF2D2C37).withOpacity(0.75),
                            prefixIcon: Icon(
                              Icons.person_add_alt_1,
                              color: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(0.6),
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D2C37).withOpacity(0.75),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedAccessAdd,
                            onChanged: (String? newValue) {
                              print("Changing access type to: $newValue");
                              setState(() {
                                _selectedAccessAdd = newValue;
                              });
                            },
                            items: accessTypes
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: Text(
                                    value,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
                                  ),
                                ),
                              );
                            }).toList(),
                            underline: const SizedBox(),
                            isExpanded: true,
                            dropdownColor:
                                const Color(0xFF2D2C37).withOpacity(0.75),
                            iconEnabledColor:
                                Theme.of(context).primaryColorLight,
                            iconDisabledColor: Theme.of(context)
                                .primaryColorLight
                                .withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).primaryColorLight,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                          ),
                          child: const Text('Cancel')),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Access access = Access(
                              email: _accessController.text,
                              access: _selectedAccessAdd!);
                          _addAccess(user, task, access);
                          _accessController.clear();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          backgroundColor:
                              const Color(0xFF2D2C37).withOpacity(0.75),
                          foregroundColor: Theme.of(context).primaryColorLight,
                        ),
                        child: const Text("Add"),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _editBuildPopUp(
      User user, Task task, List<Access> accessList, int index) {
    _selectedAccessUpdate = accessList[index].access;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColorDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              Access currentAccess = accessList[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Share ${task.title}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).primaryColorLight),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color:
                                    const Color(0xFF2D2C37).withOpacity(0.75),
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              currentAccess.email,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color:
                                          Theme.of(context).primaryColorLight),
                            ),
                          )),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2D2C37).withOpacity(0.75),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedAccessUpdate,
                            onChanged: (String? newValue) {
                              print("Changing access type to: $newValue");
                              setState(() {
                                _selectedAccessUpdate = newValue!;
                              });
                            },
                            items: accessTypes
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: Text(
                                    value,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
                                  ),
                                ),
                              );
                            }).toList()
                              ..add(DropdownMenuItem<String>(
                                value: 'Remove',
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  child: Text(
                                    'Remove',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
                                  ),
                                ),
                              )),
                            underline: const SizedBox(),
                            isExpanded: true,
                            dropdownColor:
                                const Color(0xFF2D2C37).withOpacity(0.75),
                            iconEnabledColor:
                                Theme.of(context).primaryColorLight,
                            iconDisabledColor: Theme.of(context)
                                .primaryColorLight
                                .withOpacity(0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).primaryColorLight,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 24),
                          ),
                          child: const Text('Cancel')),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_selectedAccessUpdate == 'Remove') {
                            _deleteAccess(user, task, currentAccess, index);
                          } else {
                            Access access = Access(
                                email: currentAccess.email,
                                access: _selectedAccessUpdate!);
                            _editAccess(user, task, access, index);
                          }
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                          backgroundColor:
                              const Color(0xFF2D2C37).withOpacity(0.75),
                          foregroundColor: Theme.of(context).primaryColorLight,
                        ),
                        child: const Text("Send"),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _addAccess(User user, Task task, Access access) async {
    if (access.email.isEmpty || !EmailValidator.validate(access.email) ) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email not valid!')),
      );
      return;
    }

    try {
      await ref.read(accessProvider.notifier).addAccess(user, task, access);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Access was added!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _editAccess(User user, Task task, Access access, int index) async {
    try {
      await ref
          .read(accessProvider.notifier)
          .editAccess(user, task, access, index);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Access was updated!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _deleteAccess(User user, Task task, Access access, int index) async {
    try {
      await ref
          .read(accessProvider.notifier)
          .deleteAccess(user, task, access, index);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Access was removed!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}


