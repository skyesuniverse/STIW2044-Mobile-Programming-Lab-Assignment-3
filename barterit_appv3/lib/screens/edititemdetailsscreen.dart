import 'dart:io';

import 'package:barterit_appv2/models/item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/user.dart';

class EditItemDetailsScreen extends StatefulWidget {
  final User user;
  final Item useritem;
  const EditItemDetailsScreen(
      {super.key, required this.user, required this.useritem});

  @override
  State<EditItemDetailsScreen> createState() => _EditItemDetailsScreenState();
}

class _EditItemDetailsScreenState extends State<EditItemDetailsScreen> {
  late double screenHeight, screenWidth, cardwitdh;
  File? _image;
  var pathAsset = "assets/images/camera.png";
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _itemnameEditingController =
      TextEditingController();
  final TextEditingController _itemdescEditingController =
      TextEditingController();
  final TextEditingController _itempriceEditingController =
      TextEditingController();
  final TextEditingController _itemqtyEditingController =
      TextEditingController();
  final TextEditingController _prstateEditingController =
      TextEditingController();
  final TextEditingController _prlocalEditingController =
      TextEditingController();

  String selectedCategory = "Electronics";
  List<String> categorylist = [
    "Electronics",
    "Fashion",
    "Furniture",
    "Health",
    "Sports",
    "Toys or Hobbies",
  ];

  // late Position _currentPosition;
  String curaddress = "";
  String curstate = "";
  String prlat = "";
  String prlong = "";

  List<File?> selectedImages = [null, null, null];

  @override
  void initState() {
    super.initState();
    // _determinePosition();
    _itemnameEditingController.text = widget.useritem.itemName.toString();
    _itemdescEditingController.text = widget.useritem.itemDesc.toString();
    _itempriceEditingController.text =
        double.parse(widget.useritem.itemPrice.toString()).toStringAsFixed(2);
    _itemqtyEditingController.text = widget.useritem.itemQty.toString();
    _prstateEditingController.text = widget.useritem.itemState.toString();
    _prlocalEditingController.text = widget.useritem.itemLocality.toString();
    selectedCategory = widget.useritem.itemCategory.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Updadte Item Details"),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         _determinePosition();
        //       },
        //       icon: const Icon(Icons.refresh))],
      ),
      body: Column(
        children: [
          Flexible(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Card(
                child: ListView(
                  children: [
                    CarouselSlider(
                      items: [
                        for (var i = 0; i < selectedImages.length; i++)
                          GestureDetector(
                            // onTap: () {
                            //   selectFromGallery(i);
                            // },
                            child: Card(
                              child: Container(
                                width: screenWidth,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: selectedImages[i] == null
                                        ? AssetImage(pathAsset)
                                        : FileImage(selectedImages[i]!)
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                      options: CarouselOptions(
                        height: 180.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: false,
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        viewportFraction: 0.8,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          SizedBox(width: 16),
                        ],
                      ),
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.category_rounded),
                        ),
                        value: selectedCategory,
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                            print(selectedCategory);
                          });
                        },
                        items: categorylist.map((selectedCategory) {
                          return DropdownMenuItem(
                            value: selectedCategory,
                            child: Text(
                              selectedCategory,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(width: 9),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty || (val.length < 3)
                            ? "Item name must be longer than 3"
                            : null,
                        onFieldSubmitted: (v) {},
                        controller: _itemnameEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Item Name',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.type_specimen),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ),
                        ),
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty
                            ? "Item description must be longer than 10"
                            : null,
                        onFieldSubmitted: (v) {},
                        maxLines: 4,
                        controller: _itemdescEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Item Description',
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(),
                          icon: Icon(
                            Icons.description,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                                textInputAction: TextInputAction
                                    .next, //used to enable text form field jump to next field
                                validator: (val) => val!.isEmpty
                                    ? "Item price must contain value"
                                    : null,
                                onFieldSubmitted: (v) {},
                                controller: _itempriceEditingController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Item Price',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.attach_money),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ))),
                          ),
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                validator: (val) => val!.isEmpty
                                    ? "Quantity should be more than 0"
                                    : null,
                                controller: _itemqtyEditingController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Item Quantity',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.numbers),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ))),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                validator: (val) =>
                                    val!.isEmpty || (val.length < 3)
                                        ? "Current State"
                                        : null,
                                enabled:
                                    false, //to restrict user from entering info
                                controller: _prstateEditingController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    labelText: 'Current State',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.flag),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ))),
                          ),
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                enabled:
                                    false, //to restrict user from entering info
                                validator: (val) =>
                                    val!.isEmpty || (val.length < 3)
                                        ? "Current Locality"
                                        : null,
                                controller: _prlocalEditingController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    labelText: 'Current Locality',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.location_on),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ))),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: screenWidth / 1.2,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              insertDialog();
                            },
                            child: const Text("Update Item")),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _determinePosition() {}

  // void selectFromGallery(int i) {}

  void insertDialog() {}
}
