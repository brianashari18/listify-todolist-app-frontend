import 'package:flutter/material.dart';

class AccessScreen extends StatefulWidget {
  const AccessScreen({super.key});

  @override
  State<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> {
  final TextEditingController _accessController = TextEditingController();

  final List<String> accessTypes = ['View', 'Edit'];
  String? _selectedAccess = 'View';

  @override
  Widget build(BuildContext context) {
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
                  onTap: () {},
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
                  'Kalkulus',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Theme.of(context).primaryColorLight,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '1 of 5 Tasks Done',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .bodyLarge!
                      .copyWith(color: Theme.of(context).primaryColorLight),
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
                    style: Theme.of(context)
                        .primaryTextTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).primaryColorLight),
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
                            .withOpacity(0.6),
                        size: 20,
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _buildPopUp();
                      }
                    },
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
                    title: Text("brianashari18@gmail.com",
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
                    itemCount: 3,
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        title: Text("brianashari18@gmail.com",
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
                              'View',
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
                              onPressed: () {},
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

  void _buildPopUp() {
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
                    'Share "Kalkulus"',
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
                        child: TextField(
                          controller: _accessController,
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
                            value: _selectedAccess,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedAccess = newValue;
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
                          print("Email: ${_accessController.text}");
                          print("Akses: $_selectedAccess");
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
}
