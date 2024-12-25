import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listify/models/access_model.dart';
import 'package:listify/services/workspace_service.dart';
import '../models/subtask_model.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';

class AccessNotifier extends StateNotifier<Map<String, dynamic>> {
  final WorkspaceService _workspaceService;

  AccessNotifier(this._workspaceService)
      : super({
          'owner': Access(email: 'No Owner Found', access: 'Owner'),
          'accessList': <Access>[],
        });

  Future<void> fetchAccess(User user, Task task) async {
    final result = await _workspaceService.getPeopleAccess(user, task);
    if (result['success'] == 'true') {
      final data = result['users'] as List;
      state = {
        'owner': data.isNotEmpty
            ? Access(email: data.last['email'], access: 'Owner')
            : Access(email: 'No Owner Found', access: 'Owner'),
        'accessList': data.isNotEmpty
            ? data
                .sublist(0, data.length - 1)
                .map((accessJson) => Access.fromJson(accessJson))
                .toList()
            : [],
      };
    } else {
      final errorMessage = result['error'];
      print(errorMessage);
    }
  }

  Future<void> fetchAccessByTrash(User user, SubTask subtask) async {
    final result =
        await _workspaceService.getPeopleAccessByTrash(user, subtask);
    if (result['success'] == 'true') {
      final data = result['users'] as List;
      state = {
        'owner': data.isNotEmpty
            ? Access(email: data.last['email'], access: 'Owner')
            : Access(email: 'No Owner Found', access: 'Owner'),
        'accessList': data.isNotEmpty
            ? data
                .sublist(0, data.length - 1)
                .map((accessJson) => Access.fromJson(accessJson))
                .toList()
            : [],
      };
    } else {
      final errorMessage = result['error'];
      print(errorMessage);
    }
  }

  Future<void> addAccess(User user, Task task, Access access) async {
    final result = await _workspaceService.addPeopleAccess(user, task, access);
    if (result['success'] == 'true') {
      final newAccess = Access.fromJson(result['access']);
      if ((state['accessList'] as List<Access>).contains(newAccess)) {
        throw Exception('Access was added before!');
      }
      state = {
        ...state,
        'accessList': [...(state['accessList'] as List<Access>), newAccess],
      };
    } else {
      throw Exception(result['error']);
    }
  }

  Future<void> editAccess(
      User user, Task task, Access access, int index) async {
    final result = await _workspaceService.addPeopleAccess(user, task, access);
    if (result['success'] == 'true') {
      final updatedAccess = Access.fromJson(result['access']);
      final accessList = [...(state['accessList'] as List<Access>)];
      accessList[index] = updatedAccess;
      state = {
        ...state,
        'accessList': accessList,
      };
    } else {
      throw Exception(result['error']);
    }
  }

  Future<void> deleteAccess(
      User user, Task task, Access access, int index) async {
    final result =
        await _workspaceService.deletePeopleAccess(user, task, access);
    if (result['success'] == 'true') {
      final updatedAccessList = [...(state['accessList'] as List<Access>)];
      updatedAccessList.removeAt(index);
      state = {
        ...state,
        'accessList': updatedAccessList,
      };
    } else {
      throw Exception(result['error']);
    }
  }

  void showNoPermissionMessage(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You don\'t have permission!')),
    );
  }

  Access getPermission(User user, List<Access> accessList) {
    return accessList.firstWhere(
      (access) => access.email == user.email,
      orElse: () => Access(email: user.email, access: 'None'),
    );
  }
}

final accessProvider =
    StateNotifierProvider<AccessNotifier, Map<String, dynamic>>((ref) {
  return AccessNotifier(WorkspaceService());
});
