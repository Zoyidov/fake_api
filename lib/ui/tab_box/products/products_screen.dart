import 'package:flutter/material.dart';
import 'package:n8_default_project/data/models/product/product_model.dart';
import 'package:n8_default_project/data/network/repositories/category_repo.dart';
import 'package:n8_default_project/data/network/repositories/product_repo.dart';
import 'package:n8_default_project/ui/tab_box/products/widgets/category_selector.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({
    Key? key,
    required this.productRepo,
    required this.categoryRepo,
  }) : super(key: key);

  final ProductRepo productRepo;
  final CategoryRepo categoryRepo;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String activeCategoryName = "";

  List<ProductModel> products = [];
  List<String> categories = [];

  bool isLoading = false;

  _updateProducts() async {
    setState(() {
      isLoading = true;
    });
    products =
        await widget.productRepo.getProductsByCategory(activeCategoryName);
    setState(() {
      isLoading = false;
    });
  }

  _init() async {
    categories = await widget.categoryRepo.getAllCategories();
  }

  @override
  void initState() {
    _init();
    _updateProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products screen"),
      ),
      body: Column(
        children: [
          categories.isNotEmpty
              ? CategorySelector(
                  categories: categories,
                  onCategorySelected: (selectedCategory) {
                    activeCategoryName = selectedCategory;
                    _updateProducts();
                  },
                )
              : const Center(child: CircularProgressIndicator()),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    children: List.generate(products.length, (index) {
                      ProductModel product = products[index];
                      return ListTile(
                        title: Text(product.title),
                        leading: Image.network(
                          product.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      );
                    }),
                  ),
          )
        ],
      ),
    );
  }
}
