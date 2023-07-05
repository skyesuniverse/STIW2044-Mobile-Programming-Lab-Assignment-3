import 'dart:convert';
import 'dart:developer';

import 'package:barterit_appv2/myconfig.dart';
import 'package:barterit_appv2/screens/itemdetailsscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/item.dart';
import '../models/user.dart';

class HomeTabScreen extends StatefulWidget {
  final User user;
  const HomeTabScreen({super.key, required this.user});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  String maintitle = 'Home';
  List<Item> itemList = <Item>[];
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  //code below is for pagination
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  var color;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadItems(1);
    print('Home');
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
        actions: [
          IconButton(
              onPressed: () {
                showsearchDialog();
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: itemList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(children: [
              Container(
                height: 24,
                color: Theme.of(context).colorScheme.primary,
                alignment: Alignment.center,
                child: Text(
                  "${itemList.length} Items Found",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(
                        itemList.length,
                        (index) {
                          return Card(
                            child: InkWell(
                              onTap: () {
                                Item useritem =
                                    Item.fromJson(itemList[index].toJson());
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (content) => ItemDetailsScreen(
                                      user: widget.user,
                                      useritem: useritem,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    width: screenWidth,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${MyConfig().SERVER}/barterit3/assets/items/${itemList[index].itemId}_1.png",
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  Text(
                                    itemList[index].itemName.toString(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "RM ${double.parse(itemList[index].itemPrice.toString()).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "${itemList[index].itemQty} available",
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ))),
              ////section for pagination
              SizedBox(
                height: 28,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    //build the list for textbutton with scroll
                    if ((curpage - 1) == index) {
                      //set current page number active
                      color = Colors.black;
                    } else {
                      color = Colors.black38;
                    }
                    return TextButton(
                        onPressed: () {
                          curpage = index + 1;
                          loadItems(index + 1);
                        },
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ));
                  },
                ),
              ),
            ]),
    );
  }

  void loadItems(int page) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit3/php/load_items.php"),
        // body: {}).then((response) {
        body: {"pageno": page.toString()}).then((response) {
      // code for pagination purpose above is ori code without pagination
      //print(response.body);
      log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          //////////////////below code is for pagination purpose
          numofpage = int.parse(jsondata['numofpage']); //get number of pages
          numberofresult = int.parse(jsondata['numberofresult']);
          print(numberofresult);
          /////////////////above code is for pagination purpose
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          print(itemList[0].itemName);
        }
        setState(() {});
      }
    });
  }

  void showsearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: const Text(
            "Search?",
            style: TextStyle(),
          ),
          content: Container(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        labelStyle: TextStyle(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      String search = searchController.text;
                      searchItem(search);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Search"),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void searchItem(String search) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit3/php/load_items.php"),
        body: {"search": search}).then((response) {
      //print(response.body);
      log(response.body);
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Item.fromJson(v));
          });
          print(itemList[0].itemName);
        }
        setState(() {});
      }
    });
  }
}
