import 'package:n8_default_project/data/models/universal_model.dart';
import 'package:n8_default_project/data/network/providers/api_provider.dart';

class CategoryRepo {
  CategoryRepo({required this.apiProvider});

  final ApiProvider apiProvider;

  Future<List<String>> getAllCategories() async {
    UniversalResponse universalResponse = await apiProvider.getAllCategories();
    if (universalResponse.error.isEmpty) {
      return universalResponse.data as List<String>;
    }
    return [];
  }
}
