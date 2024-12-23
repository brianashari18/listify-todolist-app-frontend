import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';
import '../models/access_model.dart';

final userProvider = StateProvider<User?>((ref) => null);

final activeTaskProvider = StateProvider<Task?>((ref) => null);

final accessListProvider = StateProvider<List<Access>>((ref) => []);
