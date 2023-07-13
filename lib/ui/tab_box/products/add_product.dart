import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:n8_default_project/data/models/product/product_model.dart';
import 'package:n8_default_project/data/network/repositories/product_repo.dart';
import 'package:n8_default_project/ui/tab_box/tab_box.dart';
import 'package:n8_default_project/ui/widgets/circles.dart';
import 'package:n8_default_project/utils/constants.dart';
import 'package:n8_default_project/utils/icons.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../data/models/product/rating_model.dart';
import '../../../data/network/providers/api_provider.dart';
import '../../../utils/utility_functions.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({
    Key? key,
    required this.productRepo,
  }) : super(key: key);
  final ProductRepo productRepo;

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String category = "";
  String imagePath = "";

  String dropdownValue = categoriesForAdd.first;

  final ImagePicker picker = ImagePicker();
  bool isLoading = false;
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Add Product"),
        leading: ZoomTapAnimation(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return TabBox(
                  apiProvider: ApiProvider(),
                  productRepo: ProductRepo(apiProvider: ApiProvider()),
                );
              }));
            },
            child: Icon(Icons.arrow_back_ios)),
        actions: [
          ZoomTapAnimation(
              onTap: () async {
                if (titleController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    imagePath.isNotEmpty) {
                  ProductModel? product = await
                  widget.productRepo.addProduct(
                      ProductModel(
                      id: 0,
                      title: titleController.text,
                      price: double.parse(priceController.text),
                      description: descriptionController.text,
                      category: dropdownValue,
                      image: imagePath,
                      rating: RatingModel(rate: 0,
                        count: 0
                      )));
                  if (product != null){

                    showCustomMessage(context, "Product Successfully added!");
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){return TabBox(apiProvider: ApiProvider(), productRepo: ProductRepo(apiProvider: ApiProvider()));}));
                  }
                  else{
                    showCustomMessage(context, "Something went wrong!");

                  }
                }
                else {
                  showCustomMessage(
                    context,
                    "Fields are not full",
                  );
                }
              },
              child: Container(
                width: 60,
                child: Icon(
                  CupertinoIcons.share_solid,
                  size: 25,
                ),
              ))
        ],
      ),
      body: Stack(
        children: [
          Circles(),
          SingleChildScrollView(
          child: Column(
          children: [
            SizedBox(height: 20,),
            SizedBox(height: 300,
                child: imagePath.isEmpty? Lottie.asset(AppImages.add):Image.asset(imagePath)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoActionSheet(
                              title: ZoomTapAnimation(
                                child: Text(
                                  'Gallery',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                    color: Colors.indigo,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  _getFromGallery();
                                },
                              ),
                              actions: [
                                CupertinoActionSheetAction(
                                  child: ZoomTapAnimation(
                                    child: Text(
                                      'Camera',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20,
                                        color: Colors.indigo,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _getFromCamera(); // Perform action for camera
                                  },
                                ),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                child: ZoomTapAnimation(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(
                        CupertinoIcons.photo,
                        color: Colors.indigo,
                        size: 40,
                      ),
                    ),
                  ),
                  DropdownButtonFormField(
                    value: dropdownValue,
                    elevation: 16,
                    style: TextStyle(
                      color: Colors.indigo,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: categoriesForAdd
                        .map<DropdownMenuItem<String>>((String? value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value!),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.indigo,
                    controller: titleController,
                    style: TextStyle(color: Colors.indigo),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelStyle: TextStyle(fontSize: 20, color: Colors.indigo),
                      labelText: 'Tittle',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.indigo,
                    controller: priceController,
                    style: TextStyle(color: Colors.indigo),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelStyle: TextStyle(fontSize: 20, color: Colors.indigo),
                      labelText: 'Price',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    cursorColor: Colors.indigo,
                    controller: descriptionController,
                    style: TextStyle(color: Colors.indigo),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelStyle: TextStyle(fontSize: 20, color: Colors.indigo),
                      labelText: 'Description',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
            ),
        ),]
      ),
    );
  }

  Future<void> _getFromCamera() async {
    XFile? xFile = await picker.pickImage(source: ImageSource.camera);
    if (xFile != null) {
      setState(() {
        imagePath = xFile.path;
      });
    }
  }

  Future<void> _getFromGallery() async {
    XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      setState(() {
        imagePath = xFile.path;
      });
    }
  }
}
