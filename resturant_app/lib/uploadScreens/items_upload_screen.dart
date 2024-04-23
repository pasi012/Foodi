import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/model/items.dart';
import 'package:seller_app/model/menus.dart';
import 'package:seller_app/widgets/error_Dialog.dart';
import 'package:seller_app/widgets/progress_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;

class ItemsUploadScreen extends StatefulWidget {

  final Menus? model;
  final Items? items;

  const ItemsUploadScreen({super.key, this.items,this.model});

  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool uploading = false;

  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  String thumbnailUrl = "";

  bool isUpdate = false;

  bool isUploadMenu = false;

  @override
  void initState() {
    super.initState();
    // If we're editing an existing item, populate the text fields
    if (widget.items != null) {
      isUploadMenu = true;
      isUpdate = true;
      shortInfoController.text = widget.items!.shortInfo!;
      titleController.text = widget.items!.title!;
      thumbnailUrl = widget.items!.thumbnailUrl!;
      descriptionController.text = widget.items!.longDescription!;
      priceController.text = widget.items!.price!.toString();
      uniqueIdName = widget.items!.itemId!;
    }
  }

  defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.pinkAccent],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: const Text(
          "Add New Items",
          style: TextStyle(fontSize: 30, fontFamily: "Lobster"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.redAccent],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.shop_two,
                color: Colors.white,
                size: 200,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.red.shade300),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  isUploadMenu = true;
                  takeImage(context);
                },
                child: const Text(
                  'Add New Items',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              "Menu Image",
              style:
                  TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                onPressed: captureImageWithCamera,
                child: const Text(
                  "Capture with Phone Camera",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SimpleDialogOption(
                onPressed: pickImageFromGalary,
                child: const Text(
                  "Select from Galary",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SimpleDialogOption(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  captureImageWithCamera() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
        source: ImageSource.camera, maxHeight: 720, maxWidth: 1280);
    setState(() {
      imageXFile;
    });
  }

  pickImageFromGalary() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
        source: ImageSource.gallery, maxHeight: 720, maxWidth: 1280);
    setState(() {
      imageXFile;
    });
  }

  ItemsUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.pinkAccent],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          isUpdate == false ? "Uploading New Item" : "Updating Item",
          style: const TextStyle(fontSize: 20, fontFamily: "Lobster"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {
            clearMenuUploaddForm();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: uploading ? null : () => isUpdate == false ? validateUploadForm() : validateUpdateForm(),
            child: Text(
              isUpdate == false ? "Add" : "Update",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "Varela",
                  letterSpacing: 3),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading == true ? linearProgress() : Text(""),
          GestureDetector(
            onTap: (){
              takeImage(context);
            },
            child: SizedBox(
              height: 230,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageXFile == null ? NetworkImage(thumbnailUrl) : FileImage(File(imageXFile!.path)) as ImageProvider,
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.redAccent,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Colors.redAccent,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: titleController,
                decoration: const InputDecoration(
                    hintText: "title",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ),
          const Divider(
            color: Colors.redAccent,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(
              Icons.perm_device_information,
              color: Colors.redAccent,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: shortInfoController,
                decoration: const InputDecoration(
                    hintText: "info",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ),
          const Divider(
            color: Colors.redAccent,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(
              Icons.description,
              color: Colors.redAccent,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: descriptionController,
                decoration: const InputDecoration(
                    hintText: "Description",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ),
          const Divider(
            color: Colors.redAccent,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(
              Icons.currency_rupee_sharp,
              color: Colors.redAccent,
            ),
            title: Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                controller: priceController,
                decoration: const InputDecoration(
                    hintText: "Price",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none),
              ),
            ),
          ),
          const Divider(
            color: Colors.redAccent,
            thickness: 2,
          ),
        ],
      ),
    );
  }

  clearMenuUploaddForm() {
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      priceController.clear();
      descriptionController.clear();
      imageXFile = null;
    });

    Navigator.pop(context);

  }

  validateUploadForm() async {
    if (imageXFile != null) {
      if (shortInfoController.text.isNotEmpty &&
          titleController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
          priceController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });
        // start uploading the image
        String downloadUrl = await uploadImage(File(imageXFile!.path));
        //save info to firestore
        saveInfo(downloadUrl);
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(
                message: "Please write title and info for item",
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
              message: "Please Pick an image for item",
            );
          });
    }
  }

  validateUpdateForm() async {
    if (imageXFile != null || thumbnailUrl.isNotEmpty) {
      if (shortInfoController.text.isNotEmpty &&
          titleController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
          priceController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });
        final response = await http.get(Uri.parse(thumbnailUrl));
        final documentDirectory = await getApplicationDocumentsDirectory();

        final file = File('${documentDirectory.path}/downloadedImage.jpg');
        file.writeAsBytesSync(response.bodyBytes);

        String updateUrl = await uploadImage(imageXFile == null ? file : File(imageXFile!.path));
        //save info to firestore
        updateInfo(updateUrl);

        Navigator.pop(context);

      } else {
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorDialog(
                message: "Please write title and info for item",
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
              message: "Please Pick an image for item",
            );
          });
    }
  }

  saveInfo(String downloadUrl) {
    final ref = FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .doc(widget.model!.menuId)
        .collection("items");

    ref.doc(uniqueIdName).set({
      "itemId": uniqueIdName,
      "menuId": widget.model!.menuId,
      "sellerUID": sharedPreferences!.getString("uid"),
      "sellerName": sharedPreferences!.getString("name"),
      "shortInfo": shortInfoController.text.toString(),
      "longDescription": descriptionController.text.toString(),
      "price": int.parse(priceController.text),
      "title": titleController.text.toString(),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
    }).then(
      (value) {
        final itemsRef = FirebaseFirestore.instance.collection("items");

        itemsRef.doc(uniqueIdName).set({
          "itemId": uniqueIdName,
          "menuId": widget.model!.menuId,
          "sellerUID": sharedPreferences!.getString("uid"),
          "sellerName": sharedPreferences!.getString("name"),
          "shortInfo": shortInfoController.text.toString(),
          "longDescription": descriptionController.text.toString(),
          "price": int.parse(priceController.text),
          "title": titleController.text.toString(),
          "publishedDate": DateTime.now(),
          "status": "available",
          "thumbnailUrl": downloadUrl,
        });
      },
    ).then((value) {
      clearMenuUploaddForm();
      setState(() {
        uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
        uploading = false;
      });
    });
  }

  updateInfo(String downloadUrl) {
    final ref = FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .doc(widget.items!.menuId)
        .collection("items");

    ref.doc(uniqueIdName).update({
      "itemId": uniqueIdName,
      "menuId": widget.items!.menuId,
      "sellerUID": sharedPreferences!.getString("uid"),
      "sellerName": sharedPreferences!.getString("name"),
      "shortInfo": shortInfoController.text.toString(),
      "longDescription": descriptionController.text.toString(),
      "price": int.parse(priceController.text),
      "title": titleController.text.toString(),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
    }).then(
          (value) {
        final itemsRef = FirebaseFirestore.instance.collection("items");

        itemsRef.doc(uniqueIdName).update({
          "itemId": uniqueIdName,
          "menuId": widget.items!.menuId,
          "sellerUID": sharedPreferences!.getString("uid"),
          "sellerName": sharedPreferences!.getString("name"),
          "shortInfo": shortInfoController.text.toString(),
          "longDescription": descriptionController.text.toString(),
          "price": int.parse(priceController.text),
          "title": titleController.text.toString(),
          "publishedDate": DateTime.now(),
          "status": "available",
          "thumbnailUrl": downloadUrl,
        });
      },
    ).then((value) {
      clearMenuUploaddForm();
      setState(() {
        uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
        uploading = false;
      });
    });
  }

  uploadImage(mImageFile) async {
    storageRef.Reference reference =
        storageRef.FirebaseStorage.instance.ref().child("items");

    storageRef.UploadTask uploadTask =
        reference.child("$uniqueIdName.jpg").putFile(mImageFile);
    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return isUploadMenu == false && imageXFile == null ? defaultScreen() : ItemsUploadFormScreen();
  }
}
