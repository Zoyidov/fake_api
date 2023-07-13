import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:n8_default_project/ui/tab_box/products/selected_product.dart';
import 'package:n8_default_project/ui/tab_box/products/widgets/appbar_action.dart';
import 'package:n8_default_project/ui/tab_box/products/widgets/category_selector.dart';
import 'package:n8_default_project/ui/widgets/circles.dart';
import 'package:n8_default_project/ui/tab_box/products/widgets/shimmer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../data/models/product/product_model.dart';
import '../../../data/network/repositories/category_repo.dart';
import '../../../data/network/repositories/product_repo.dart';

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

  List<ProductModel> storeData = [];
  String selectedPopupMenuValue = 'All';
  int limit = 0;

  String activeCategoryName = "";

  List<ProductModel> products = [];
  List<String> categories = [];

  TextEditingController limitController = TextEditingController();

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

  _limitedData(String limit)async{
    setState(() {
      isLoading = true;
    });
    products = await widget.productRepo.getProductsByLimit(int.parse(limit));
    setState(() {
      isLoading = false;
    });
  }

  _getSortAZ()async{
    setState(() {
      isLoading =true;
    });
    products = await widget.productRepo.getSortedProducts("ASC");
    setState(() {
      isLoading = false;
    });
  }

  _getSortZA()async{
    setState(() {
      isLoading =true;
    });
    products = await widget.productRepo.getSortedProducts("desc");
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _init();
    _updateProducts();
    super.initState();
  }


  void _showLimitDialog() {
    showDialog(
      barrierColor: Colors.indigo,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set Limit'),
          content: TextField(
            controller: limitController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter a limit',
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.indigo),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _limitedData(limitController.text);
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.indigo,
        title: const Text("Products screen"),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              size: 30,
            ),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  onTap: (){
                    setState(() {
                      _getSortAZ();
                    });
                  },
                  value: 'Sort',
                  child: Text('Sort Up'),
                ),
                PopupMenuItem<String>(
                  onTap: (){
                    setState(() {
                      _getSortZA();
                    });
                  },
                  value: 'Sort',
                  child: Text('Sort Down'),
                ),
                PopupMenuItem<String>(
                  value: 'Limit',
                  child: Text('Give Limit to Products'),
                ),
              ];
            },
            onSelected: (value) {
              setState(() {
                selectedPopupMenuValue = value;
                if (value == 'Limit') {
                  _showLimitDialog();
                } else if (value == 'Sort') {

                }
              });
            },
          ),
        ],
      ),
      body: isLoading
          ? ShimmerScreen()
          : products.isEmpty
              ? Center(
                  child: Text(
                    'Data is empty!',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Stack(
                children:[
                  Circles(),
                  Column(
                    children: [
                      categories.isNotEmpty
                          ? CategorySelector(
                              categories: categories,
                              onCategorySelected: (selectedCategory) {
                                activeCategoryName = selectedCategory;
                                _updateProducts();
                              },
                            )
                          : const Center(
                              child: CupertinoActivityIndicator(
                              color: Colors.white,
                            )),
                      SizedBox(height: 15),
                      Expanded(
                        child: isLoading
                            ? ShimmerScreen()
                            : GridView.builder(
                                padding: const EdgeInsets.all(16.0),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 0.65,
                                ),
                                itemCount: products.length,
                                itemBuilder: (BuildContext context, int index) {
                                  ProductModel product = products[index];
                                  final item = product;
                                  return GridTile(
                                    child: ZoomTapAnimation(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductScreen(model: item),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              spreadRadius: 2,
                                              blurRadius: 4,
                                              offset: const Offset(0, 7),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                  top: Radius.circular(12.0),
                                                ),
                                                child: Center(
                                                  child: CachedNetworkImage(
                                                    imageUrl: product.image,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context, url) =>
                                                        CupertinoActivityIndicator(
                                                      color: Colors.black,
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Icon(Icons.error,
                                                            color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      product.title,
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 4.0),
                                                    Text(
                                                      product.category,
                                                      style: const TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.grey,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 8.0),
                                                    Row(
                                                      children: [
                                                        Icon(Icons
                                                            .monetization_on_outlined),
                                                        Text(
                                                          " " +
                                                              product.price
                                                                  .toStringAsFixed(
                                                                      2),
                                                          style: const TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),]
              ),
      backgroundColor: Colors.indigo,
    );
  }
}