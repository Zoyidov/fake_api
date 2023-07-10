import 'package:n8_default_project/data/models/universal_model.dart';
import 'package:n8_default_project/data/models/user/user_model.dart';
import 'package:n8_default_project/data/network/providers/api_provider.dart';

class UserRepo {
  UserRepo({required this.apiProvider});

  final ApiProvider apiProvider;

  Future<List<UserModel>> getAllUsers({
    required String username,
    required String password,
  }) async {
    UniversalResponse universalResponse = await apiProvider.getAllUsers();
    if (universalResponse.error.isEmpty) {
      return universalResponse.data as List<UserModel>;
    }
    return [];
  }
}
