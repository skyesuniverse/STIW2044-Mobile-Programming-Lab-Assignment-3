import 'dart:convert';
import 'dart:developer';
import 'package:barterit_appv3/models/item.dart';
import 'package:barterit_appv3/models/user.dart';
import 'package:barterit_appv3/myconfig.dart';
import 'package:barterit_appv3/screens/edititemdetailsscreen.dart';
import 'package:barterit_appv3/screens/newitemscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SellerTabScreen extends StatefulWidget {
  final User user;

  const SellerTabScreen({super.key, required this.user});

  @override
  State<SellerTabScreen> createState() => _SellerTabScreenState();
}

class _SellerTabScreenState extends State<SellerTabScreen> {
  String maintitle = 'Seller';
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  List<Item> itemList = <Item>[];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadsellerItems();
    print('Seller');
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose');
  }

  Future<void> _refresh() async {
    loadsellerItems();
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
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: Scaffold(
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
            : Column(
                children: [
                  Container(
                    height: 24,
                    color: Theme.of(context).colorScheme.primary,
                    alignment: Alignment.center,
                    child: Text(
                      "${itemList.length} Item Found",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(itemList.length, (index) {
                        return Card(
                          child: InkWell(
                            onLongPress: () {
                              onDeleteDialog(index);
                            },
                            onTap: () async {
                              Item singleItem =
                                  Item.fromJson(itemList[index].toJson());
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) =>
                                          EditItemDetailsScreen(
                                            user: widget.user,
                                            useritem: singleItem,
                                          )));
                              loadsellerItems();
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
                      }),
                    ),
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => NewItemScreen(
                          user: widget.user,
                        )));
            loadsellerItems();
          },
          child: const Text(
            "+",
            style: TextStyle(fontSize: 32),
          ),
        ),
      ),
    );
  }

  void loadsellerItems() {
    if (widget.user.id == "na") {
      setState(() {
        // titlecenter = "Unregistered User";
      });
      return;
    }

    http.post(Uri.parse("${MyConfig().SERVER}/barterit3/php/load_items.php"),
        body: {"userid": widget.user.id}).then((response) {
      print(response.body);
      //log(response.body);
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

  void onDeleteDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(
              "Delete ${itemList[index].itemName}?",
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () {
                  deleteCatch(index);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void deleteCatch(int index) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit3/php/delete_item.php"),
        body: {
          "userid": widget.user.id,
          "itemid": itemList[index].itemId
        }).then((response) {
      print(response.body);
      //catchList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
          loadsellerItems();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Failed")));
        }
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
