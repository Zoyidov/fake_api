// import 'package:flutter/material.dart';
// import 'package:n8_default_project/data/network/repositories/user_repo.dart';
//
// class UsersScreen extends StatefulWidget {
//   const UsersScreen({Key? key, required this.userRepo}) : super(key: key);
//
//   final UserRepo userRepo;
//
//   @override
//   State<UsersScreen> createState() => _UsersScreenState();
// }
//
// class _UsersScreenState extends State<UsersScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.indigo,
//         title: const Text("Profile"),
//       ),
//       backgroundColor: Colors.indigo,
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:n8_default_project/data/local/storage_repository.dart';
import 'package:n8_default_project/data/network/repositories/user_repo.dart';
import 'package:n8_default_project/ui/widgets/circles.dart';
import 'package:n8_default_project/utils/icons.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../data/models/user/user_model.dart';
import '../../login/login_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key, required this.userRepo}) : super(key: key);

  final UserRepo userRepo;

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<UserModel> userModels = [];

  Future<void> _init() async {}

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _init();
    print(userModels);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.indigo,
        title: const Text("Users screen"),
      ),
      body: Stack(children: [
        Circles(),
        SingleChildScrollView(
          child: Column(
            children: [
              ZoomTapAnimation(
                  onTap: () {
                    showDialog(
                      barrierColor: Colors.indigo,
                      context: context,
                      builder: (context) {
                        return Dialog(
                          elevation: 0,
                          backgroundColor: Colors.indigo,
                          child: Container(
                            height: 400,
                              decoration: BoxDecoration(border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(30)),
                              child: Column(
                                children: [
                                  Center(child: Text("Other Users",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20,color: Colors.white),)),
                                  SizedBox(height: 10,),
                                  Expanded(
                                    child: FutureBuilder(
                                        future: widget.userRepo.getAllUsers(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child: CupertinoActivityIndicator(color: Colors.white,radius: 100,),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Center(
                                              child: Text('Error: ${snapshot.error}'),
                                            );
                                          } else if (!snapshot.hasData) {
                                            return const Center(
                                              child: Text('No data available'),
                                            );
                                          }

                                          final user = snapshot.data;

                                          return ListView(
                                            children: [
                                              ...List.generate(user.length, (index) {
                                                UserModel data = user[index];
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Icon(Icons.person),
                                                      Text(data.username,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.white)),
                                                      SizedBox(width: 10,),
                                                      Text(data.password,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Colors.white)),
                                                      SizedBox(width: 10,),
                                                      Text(data.email,style: TextStyle(fontSize: 11,fontWeight: FontWeight.w400,color: Colors.white)),
                                                    ],
                                                  ),
                                                );
                                              })
                                            ],
                                          );
                                        }),
                                  ),
                                ],
                              )),
                        );
                      },
                    );
                  },
                  child: Lottie.asset(AppImages.user, height: 250, width: 250)),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 50),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Text("Your Account",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.white),),
                      SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "UserName: ${StorageRepository.getString("username")}",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white)),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                  "Password: ${StorageRepository.getString("password")}",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 125),
                child: Container(
                  padding: EdgeInsets.only(top: 80),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  child: ZoomTapAnimation(
                    child: ElevatedButton(
                      onPressed: () {
                        _dialogBuilder(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white, // Set the background color
                        elevation: 4, // Add a shadow effect
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Log Out",
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
      backgroundColor: Colors.indigo,
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.indigo)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK', style: TextStyle(color: Colors.indigo)),
              onPressed: () {
                StorageRepository.deleteString("password");
                StorageRepository.deleteString("username");
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
            ),
          ],
        );
      },
    );
  }
}
