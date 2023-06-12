import 'dart:convert';
import 'dart:io';
import 'package:barterit_appv2/models/user.dart';
import 'package:barterit_appv2/myconfig.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class NewItemScreen extends StatefulWidget {
  final User user;

  const NewItemScreen({super.key, required this.user});

  @override
  State<NewItemScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
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

  late Position _currentPosition;

  String curaddress = "";
  String curstate = "";
  String prlat = "";
  String prlong = "";

  // List<File?> imageList = [
  //   null, null, null
  // ];

  List<File?> selectedImages = [null, null, null];

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Add New Item"), actions: [
        IconButton(
            onPressed: () {
              _determinePosition();
            },
            icon: const Icon(Icons.refresh))
      ]),
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
                          onTap: () {
                            selectFromGallery(i);
                          },
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
                      // Container(
                      //   margin: EdgeInsets.all(6.0),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8.0),
                      //     image: DecorationImage(
                      //       image: _image == null
                      //           ? AssetImage(pathAsset)
                      //           : FileImage(selectedImages[i]!)
                      //               as ImageProvider,
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      //   child: GestureDetector(onTap: () {
                      //     selectFromGallery(i);
                      //   }),
                      // ),

                      // //2nd Image of Slider
                      // Container(
                      //   margin: EdgeInsets.all(6.0),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8.0),
                      //     image: DecorationImage(
                      //       image: _image2 == null
                      //           ? AssetImage(pathAsset)
                      //           : FileImage(_image2!) as ImageProvider,
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),

                      // //3rd Image of Slider
                      // Container(
                      //   margin: EdgeInsets.all(6.0),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8.0),
                      //     image: DecorationImage(
                      //       image: _image3 == null
                      //           ? AssetImage(pathAsset)
                      //           : FileImage(_image3!) as ImageProvider,
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),
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
              )
                  // SizedBox(
                  //   child: Container(
                  //     width: screenWidth,
                  //     decoration: BoxDecoration(
                  //       image: DecorationImage(
                  //         image: _image == null
                  //             ? AssetImage(pathAsset)
                  //             : FileImage(_image!) as ImageProvider,
                  //         fit: BoxFit.contain,
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
                        children: [
                          //const Icon(Icons.category_rounded),
                          const SizedBox(width: 16),
                          // SizedBox(
                          //   height: 60,
                          //   child: DropdownButton(
                          //     //sorting dropdownoption
                          //     // Not necessary for Option 1
                          //     value: selectedCategory,
                          //     onChanged: (newValue) {
                          //       setState(() {
                          //         selectedCategory = newValue!;
                          //         print(selectedCategory);
                          //       });
                          //     },
                          //     items: categorylist.map((selectedType) {
                          //       return DropdownMenuItem(
                          //         value: selectedType,
                          //         child: Text(
                          //           selectedType,
                          //         ),
                          //       );
                          //     }).toList(),
                          //   ),
                          // ),
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

                      ////////
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
                          //icon: Icon(Icons.abc),
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
                            child: const Text("Add Item")),
                      )
                      // Flexible(
                      //   child: child,
                      // ),
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

  Future<void> cropImage(int index) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: true),
        //showCropGrid: true,
        //showRotationGrid: true,
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      int? sizeInBytes = _image?.lengthSync();
      double sizeInMb = sizeInBytes! / (1024 * 1024);
      print(sizeInMb);

      setState(() {
        selectedImages[index] = _image;
      });
    }
  }

  void insertDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please take 3 pictures")));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Insert new item?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                insertItem();
                //registerUser();
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
      },
    );
  }

  Future<void> insertItem() async {
    String itemname = _itemnameEditingController.text;
    String itemdesc = _itemdescEditingController.text;
    String itemprice = _itempriceEditingController.text;
    String itemqty = _itemqtyEditingController.text;
    String state = _prstateEditingController.text;
    String locality = _prlocalEditingController.text;
    List<String> base64Images = imagesToBase64();

    http.post(Uri.parse("${MyConfig().SERVER}/barterit2/php/insert_item.php"),
        body: {
          "userid": widget.user.id.toString(),
          "itemname": itemname,
          "itemdesc": itemdesc,
          "itemprice": itemprice,
          "itemqty": itemqty,
          "category": selectedCategory,
          "latitude": prlat,
          "longitude": prlong,
          "state": state,
          "locality": locality,
          "image1": base64Images.length >= 1 ? base64Images[0] : '',
          "image2": base64Images.length >= 2 ? base64Images[1] : '',
          "image3": base64Images.length >= 3 ? base64Images[2] : '',
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        print(jsondata);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pop(context);
      }
    });
  }

  // void _selectImage(int index, File? image) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return object of type Dialog
  //       return AlertDialog(
  //           title: const Text(
  //             "Select from",
  //             style: TextStyle(),
  //           ),
  //           content: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                     fixedSize: Size(screenWidth / 4, screenHeight / 6)),
  //                 child: const Text('Gallery'),
  //                 onPressed: () => {
  //                   Navigator.of(context).pop(),
  //                   _selectfromGallery(index, image),
  //                 },
  //               ),
  //               ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                     fixedSize: Size(screenWidth / 4, screenHeight / 6)),
  //                 child: const Text('Camera',
  //                     style: TextStyle(
  //                       fontSize: 13.5,
  //                     )),
  //                 onPressed: () => {
  //                   Navigator.of(context).pop(),
  //                   _selectFromCamera(),
  //                 },
  //               ),
  //             ],
  //           ));
  //     },
  //   );
  // }

  // List<File?> imageList = [ _image1, _image2, _image3 ];
  //  Future<void> _selectfromGallery(int index, File? image) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(
  //     source: ImageSource.gallery,
  //     maxHeight: 800,
  //     maxWidth: 800,
  //   );
  //   if (pickedFile != null) {
  //     imageList[index] = File(pickedFile.path);
  //     cropImage(image);
  //   } else {
  //     print('No image selected.');
  //   }
  // }

  Future<void> _selectfromGallery1() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      //_cropImage();
    } else {
      print('No image selected.');
    }
  }

  Future<void> _selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      //_image = File(pickedFile.path);

      //cropImage();
    } else {
      print('No image selected.');
    }
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    // Check location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request location permission if denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    // Handle permanently denied location permission
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    // Get the current position
    _currentPosition = await Geolocator.getCurrentPosition();
    // Get the address based on the current position
    _getAddress(_currentPosition);
    //return await Geolocator.getCurrentPosition();
  }

  _getAddress(Position pos) async {
    // Retrieve the list of placemarks (address) from coordinates
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) {
      // If no placemark is found, set default values for address
      _prlocalEditingController.text = "Changlun";
      _prstateEditingController.text = "Kedah";
      prlat = "6.443455345";
      prlong = "100.05488449";
    } else {
      // Set the address values based on the retrieved placemark
      _prlocalEditingController.text = placemarks[0].locality.toString();
      _prstateEditingController.text =
          placemarks[0].administrativeArea.toString();
      prlat = _currentPosition.latitude.toString();
      prlong = _currentPosition.longitude.toString();
    }
    setState(() {});
  }

  void onAlert() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Select only 3 photo')));
  }

  List<String> convertImagesToBase64(List<File> images) {
    List<String> base64Strings = [];

    for (var image in images) {
      List<int> imageBytes = image.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      base64Strings.add(base64Image);
    }

    return base64Strings;
  }

  Future<void> selectFromGallery(int i) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage(i);
    } else {
      print('No image selected.');
    }
  }

  List<String> imagesToBase64() {
    List<String> base64Images = [];

    for (var i = 0; i < selectedImages.length; i++) {
      final image = selectedImages[i];
      if (image != null) {
        List<int> imageBytes = File(image.path).readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        base64Images.add(base64Image);
      }
    }
    return base64Images;
  }
}
