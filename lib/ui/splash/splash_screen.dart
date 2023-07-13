import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:n8_default_project/ui/tab_box/products/products_screen.dart';

import '../../data/local/storage_repository.dart';
import '../../data/network/providers/api_provider.dart';
import '../../data/network/repositories/product_repo.dart';
import '../../utils/icons.dart';
import '../login/login_screen.dart';
import '../tab_box/tab_box.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _navigateToWelcomeScreen(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.indigo,
        ),
        backgroundColor: Colors.indigo,
        body: Column(
          children: [
            Text(
              "Online Shop",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 35,
                  color: Colors.white),
            ),
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Lottie.asset(
                AppImages.splash,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Welcome",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                  color: Colors.white),
            ),
          ],
        ));
  }

  void _navigateToWelcomeScreen(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 4));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => StorageRepository.getString("password").isEmpty
        ? LoginScreen()
        : TabBox(apiProvider: ApiProvider(), productRepo: ProductRepo(apiProvider: ApiProvider()),)));
  }
}