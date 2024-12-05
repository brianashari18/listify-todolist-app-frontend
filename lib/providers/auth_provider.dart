import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listify/services/user_service.dart';

import '../models/user_model.dart';

final authProvider = FutureProvider<User?>((ref) async {
    return await UserService().getUser();
});
