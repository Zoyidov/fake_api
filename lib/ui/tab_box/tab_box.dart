import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:n8_default_project/data/network/providers/api_provider.dart';
import 'package:n8_default_project/data/network/repositories/category_repo.dart';
import 'package:n8_default_project/data/network/repositories/product_repo.dart';
import 'package:n8_default_project/data/network/repositories/user_repo.dart';
import 'package:n8_default_project/ui/tab_box/products/add_product.dart';
import 'package:n8_default_project/ui/tab_box/products/products_screen.dart';
import 'package:n8_default_project/ui/tab_box/users/users_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class TabBox extends StatefulWidget {
  TabBox({Key? key, required this.apiProvider, required this.productRepo}) : super(key: key);

  final ApiProvider apiProvider;
  final ProductRepo productRepo;



  @override
  State<TabBox> createState() => _TabBoxState();
}

class _TabBoxState extends State<TabBox> {
  List<Widget> screens = [];
  int activePage = 0;

  late ProductRepo productRepo;
  late UserRepo userRepo;
  late CategoryRepo categoryRepo;

  @override
  void initState() {
    productRepo = ProductRepo(apiProvider: widget.apiProvider);
    userRepo = UserRepo(apiProvider: widget.apiProvider);
    categoryRepo = CategoryRepo(apiProvider: widget.apiProvider);

    screens.add(ProductsScreen(
      productRepo: productRepo,
      categoryRepo: categoryRepo,
    ));
    screens.add(UsersScreen(
      userRepo: userRepo,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: screens,
        index: activePage,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.indigo,
        currentIndex: activePage,
        onTap: (index) {
          setState(() {
            activePage = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopify, color: Colors.grey),
            label: "Products",
            activeIcon: Icon(Icons.shopify, color: Colors.white, size: 30),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.profile_circled,
              color: Colors.grey,
            ),
            label: "Users",
            activeIcon: Icon(
              CupertinoIcons.profile_circled,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      floatingActionButton: activePage == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return AddProduct(productRepo: widget.productRepo);
                }));
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.indigo,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
