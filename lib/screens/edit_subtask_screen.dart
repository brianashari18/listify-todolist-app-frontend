import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:listify/models/recomendation_model.dart';
import 'package:listify/models/subtask_model.dart';
import 'package:listify/providers/resource_provider.dart';
import 'package:listify/services/ai_service.dart';
import 'package:listify/services/subtask_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/task_model.dart';
import '../models/user_model.dart';
import '../widgets/calendar_bottom_sheet.dart';

class EditSubTaskScreen extends ConsumerStatefulWidget {
  const EditSubTaskScreen({super.key, required this.subTask});

  final SubTask subTask;

  @override
  ConsumerState<EditSubTaskScreen> createState() => _EditSubTaskScreenState();
}

class _EditSubTaskScreenState extends ConsumerState<EditSubTaskScreen> {
  final TextEditingController _subTaskController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final SubTaskService _subTaskService = SubTaskService();
  final AIService _aiService = AIService();
  List<Recommendation> _recommendations = [];
  String? _selectedStatus;
  DateTime? _selectedDate;
  User? user;
  Task? task;

  @override
  void initState() {
    super.initState();
    user = ref.read(userProvider);
    task = ref.read(activeTaskProvider);

    _getRecommendation();

    _subTaskController.addListener(_onAutoSave);
    _deadlineController.addListener(_onAutoSave);

    _subTaskController.text = widget.subTask.taskData;
    _selectedStatus = widget.subTask.status;

    if (widget.subTask.deadline.isNotEmpty) {
      try {
        _selectedDate = DateFormat('dd/MM/yyyy').parse(widget.subTask.deadline);
        _deadlineController.text =
            "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
      } catch (e) {
        print("Invalid date format for deadline: ${widget.subTask.deadline}");
      }
    }
  }

  @override
  void dispose() {
    _subTaskController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  void _onAutoSave() async {
    print("Auto-saving task: ${_subTaskController.text}");
    print("Auto-saving deadline: ${_deadlineController.text}");
    print("Auto-saving status: $_selectedStatus");

    // Check if any field is empty and validate _selectedStatus before using it
    if (_subTaskController.text.isNotEmpty ||
        _deadlineController.text.isNotEmpty ||
        (_selectedStatus != null && _selectedStatus!.isNotEmpty)) {
      try {
        final result = await _subTaskService.updateSubTask(
          user!,
          task!.id,
          widget.subTask.id,
          _subTaskController.text,
          _deadlineController.text,
          _selectedStatus!,
        );

        _getRecommendation();
      } catch (e) {
        print("Error updating subtask: $e");
      }
    } else {
      print("Skipping auto-save: Missing required fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
      child: Scaffold(
        resizeToAvoidBottomInset: false, // Prevent bottom sheet from moving
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: deviceHeight,
                padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: deviceHeight - deviceHeight * 0.93),
                decoration: const BoxDecoration(
                  color: Color(0xFF44404D),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 70),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _subTaskController,
                        style: const TextStyle(
                          color: Color(0xFFF5F5F5),
                          fontSize: 20,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: widget.subTask.taskData,
                          hintStyle: const TextStyle(
                            color: Color(0xFFF5F5F5),
                            fontSize: 20,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onChanged: (value) {
                          _onAutoSave();
                        },
                      ),
                    ),

                    const SizedBox(height: 5),

                    // Input for deadline
                    _buildInputField(
                      controller: _deadlineController,
                      hintText: widget.subTask.deadline,
                      isReadOnly: true,
                      onTap: () => _showCalendarModal(context),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    const SizedBox(height: 20),

                    _buildStyledDropdown(
                      value: _selectedStatus,
                      items: ['On Progress', 'Done'],
                      hintText: widget.subTask.status,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedStatus = newValue;
                        });
                        _onAutoSave();
                      },
                    ),
                  ],
                ),
              ),
            ),

            DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.1,
              maxChildSize: 0.4,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E1E2A),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: _buildRecommendationBottomSheet(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    bool isReadOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return GestureDetector(
      onTap: onTap, // Trigger the calendar or other onTap actions
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: ShapeDecoration(
          color: const Color(0xFF7B7794),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                readOnly: isReadOnly,
                style: const TextStyle(
                  color: Color(0xFFF5F5F5),
                  fontSize: 12,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    color: Color(0xFFF5F5F5),
                    fontSize: 12,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            if (suffixIcon != null)
              GestureDetector(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: suffixIcon,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledDropdown({
    required String? value,
    required List<String> items,
    required String hintText,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: ShapeDecoration(
        color: const Color(0xFF7B7794),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        hint: Text(
          hintText,
          style: const TextStyle(
            color: Color(0xFFF5F5F5),
            fontSize: 12,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        dropdownColor: const Color(0xFF7B7794),
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFF5F5F5)),
        style: const TextStyle(
          color: Color(0xFFF5F5F5),
          fontSize: 12,
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
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

  void _onSaveChanges() {
    print(
        "Task saved: ${_subTaskController.text}, Deadline: ${_deadlineController.text}, Status: $_selectedStatus");
  }

  Widget _buildRecommendationBottomSheet() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 30.0),
            child: Text(
              'Recommendation',
              style: TextStyle(
                color: Color(0xFFF5F5F5),
                fontSize: 20,
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _recommendations.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(child: const CircularProgressIndicator()),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 20),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recommendations.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () async {
                            final uri = Uri.parse(_recommendations[index].link);
                            if (!await launchUrl(uri)) {
                              print("Could not launch URL");
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                truncateText(_recommendations[index].title),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                    color: Theme.of(context).primaryColorLight,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _recommendations[index].link,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .primaryColorLight),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  String truncateText(String text, {int wordLimit = 7}) {
    List<String> words = text.split(' ');

    if (words.length > wordLimit) {
      words = words.sublist(0, wordLimit);
      return '${words.join(' ')}...';
    } else {
      return text;
    }
  }


  void _getRecommendation() async {
    final result = await _aiService.getRecommendation(widget.subTask);
    if (result['success']) {
      final data = result['data'] as List;
      setState(() {
        _recommendations = data
            .map((recommendation) => Recommendation.fromJson(recommendation))
            .toList();
      });
    } else if (result['error'] == 'Recommendation not found') {
      setState(() {
        _recommendations = [];
      });
    } else {
      final errorMessage = result['error'];
      print(errorMessage);
    }
  }
}
