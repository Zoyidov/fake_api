import 'package:flutter/material.dart';
import 'package:n8_default_project/data/models/product/product_model.dart';
import 'package:n8_default_project/data/network/providers/api_provider.dart';

import '../../../../data/network/repositories/product_repo.dart';

class MoreVert extends StatefulWidget {
  const MoreVert({Key? key}) : super(key: key);

  @override
  _MoreVertState createState() => _MoreVertState();
}

class _MoreVertState extends State<MoreVert> {
  final ProductRepo storeRepository = ProductRepo(apiProvider: ApiProvider());
  List<ProductModel> storeData = [];
  bool isLoading = false;
  String selectedPopupMenuValue = 'All';
  int limit = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final List<ProductModel> fetchedData = await storeRepository.getAllProducts();
      setState(() {
        storeData = fetchedData;
      });

      if (selectedPopupMenuValue == 'Sort') {
        final List<ProductModel> sortedData = await storeRepository.getSortedProducts("");
        setState(() {
          storeData = sortedData;
        });
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to load products.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<ProductModel> getLimitedData() {
    if (selectedPopupMenuValue == 'All' || selectedPopupMenuValue == 'Sort') {
      return storeData;
    } else {
      return storeData.take(limit).toList();
    }
  }

  void _showLimitDialog() {
    showDialog(
      barrierColor: Colors.indigo,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set Limit'),
          content: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                limit = int.tryParse(value) ?? 0;
              });
            },
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
                  storeData = getLimitedData();
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
    return Column(
      children: [
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            size: 30,
          ),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'Sort',
                child: Text('Sort'),
              ),
              PopupMenuItem<String>(
                value: 'All',
                child: Text('All Products'),
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
                fetchData();
              }
            });
          },
        ),
      ],
    );
  }
}
