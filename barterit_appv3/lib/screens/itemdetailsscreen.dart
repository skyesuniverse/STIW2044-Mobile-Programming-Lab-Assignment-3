import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../models/item.dart';
import '../models/user.dart';
import '../myconfig.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Item useritem;
  final User user;
  const ItemDetailsScreen(
      {super.key, required this.useritem, required this.user});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late double screenHeight, screenWidth, cardwitdh;
  List<File?> selectedImages = [null, null, null];
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Item",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stack(
          //   children: [
          //     Padding(
          //       padding: EdgeInsets.only(left: 10, top: 15),
          //       child: InkWell(
          //         onTap: () {
          //           Navigator.pop(context);
          //         },
          //         child: Icon(
          //           Icons.arrow_back_ios_new_outlined,
          //           size: 30,
          //         ),
          //       ),
          //     )
          //   ],
          // ),
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
              child: Card(
                child: ListView(
                  children: [
                    CarouselSlider(
                      items: [
                        for (var i = 0; i < selectedImages.length; i++)
                          Card(
                            child: Container(
                              width: screenWidth,
                              child: CachedNetworkImage(
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                imageUrl:
                                    "${MyConfig().SERVER}/barterit3/assets/items/${widget.useritem.itemId}_${i + 1}.png",
                                // fit: BoxFit.cover,
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
          // SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.useritem.itemName.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "RM ${double.parse(widget.useritem.itemPrice.toString()).toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  widget.useritem.itemCategory.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                ////////Price

                ////////Description
                Text(
                  widget.useritem.itemDesc.toString(),
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 22),
                ////////Location
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(width: 7),
                      Icon(Icons.location_on, color: Colors.grey),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          widget.useritem.itemLocality.toString(),
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(width: 25),
                      Icon(Icons.flag_sharp, color: Colors.grey),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          widget.useritem.itemState.toString(),
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
