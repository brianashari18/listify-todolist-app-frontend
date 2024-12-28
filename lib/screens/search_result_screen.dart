import 'package:flutter/material.dart';
import 'package:listify/models/subtask_model.dart';
import 'package:listify/services/subtask_service.dart';

import '../models/user_model.dart';
import 'edit_subtask_screen.dart';

class SearchResultScreen extends StatefulWidget {
  final User user;
  final String query;

  const SearchResultScreen({super.key, required this.user, required this.query});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final SubTaskService _subTaskService = SubTaskService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<SubTask> _allSubtasks = []; // Menyimpan semua subtasks hasil pencarian
  List<SubTask> _subtasks = []; // Menyimpan subtasks yang difilter
  bool _isLoading = false;
  String? _selectedFilter; // Menyimpan status filter (null untuk semua)

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    _searchController.addListener(_onSearchChanged);
    if (widget.query.isNotEmpty) {
      _getSearchResult(widget.query);
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      _getSearchResult(query);
    } else {
      setState(() {
        _allSubtasks = [];
        _subtasks = [];
      });
    }
  }

  void _getSearchResult(String query) async {
    setState(() {
      _isLoading = true;
    });

    final result = await _subTaskService.searchSubtask(widget.user, query);
    if (result['success']) {
      final data = result['data'] as List;
      setState(() {
        _allSubtasks = data.map((subtask) => SubTask.fromJson(subtask)).toList();
        _subtasks = _applyFilter(_allSubtasks, _selectedFilter); // Terapkan filter
        _isLoading = false;
      });
    } else {
      setState(() {
        _allSubtasks = [];
        _subtasks = [];
        _isLoading = false;
      });
    }
  }

  List<SubTask> _applyFilter(List<SubTask> subtasks, String? filter) {
    if (filter == null) {
      return subtasks; // Tidak ada filter, tampilkan semua
    }
    return subtasks.where((subtask) => subtask.status == filter).toList();
  }

  void _onFilterChanged(String? filter) {
    setState(() {
      _selectedFilter = filter; // Ubah filter
      _subtasks = _applyFilter(_allSubtasks, filter); // Terapkan filter pada semua subtasks
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(68, 64, 77, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: Column(
            children: [
              SizedBox(
                height: 35,
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: "Search Task",
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black45,
                    ),
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.arrow_back, size: 20, color: Colors.black45),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  style: const TextStyle(fontSize: 14),
                  onChanged: (text) {
                    _onSearchChanged();
                  },
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFilterButton("On Progress"),
                    _buildFilterButton("Done"),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _subtasks.isEmpty
                    ? const Center(
                  child: Text(
                    "No subtasks found!",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
                    : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: _subtasks.length,
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  itemBuilder: (context, index) {
                    final subtask = _subtasks[index];
                    return ListTile(
                      title: Text(
                        subtask.taskData,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        '${subtask.status} | ${subtask.deadline ?? 'No deadline'}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditSubTaskScreen(subTask: subtask),
                          ),
                        );
                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white70,
                        size: 16,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildFilterButton(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => _onFilterChanged(isSelected ? null : label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.2)
              : const Color.fromRGBO(50, 47, 58, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

