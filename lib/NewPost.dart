import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:miaged/Global.dart';
import 'package:miaged/MainContainer.dart';
import 'package:miaged/TakePictureScreen.dart';
import 'package:path/path.dart' show basename, join;
import 'package:path_provider/path_provider.dart';

// A screen that allows users to take a picture using a given camera.
class NewPost extends StatefulWidget {
  CameraDescription camera;

  @override
  NewPostState createState() => NewPostState();
}


class NewPostState extends State<NewPost> {
  final _formKey = GlobalKey<FormState>();

  String categoryValue = 'Maillot';

  TextEditingController titleController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  String _imagePath = "";

  // Pass this method to the child page.
  void _update(String imagePath) {
    setState(() => _imagePath = imagePath);
  }

  BoxDecoration border() {
    return BoxDecoration(
      border: Border.all(),
    );
  }

  Future<void> createPostInFirebase(String category, double price, String seller, String size, String title, String url1) async {

    await FirebaseFirestore.instance.collection("articles")
        .add({
          'category': category,
          'price': price,
          "seller": seller,
          "size": size,
          "title": title,
          "url1": url1
        })
        .then((value) => print("SUCCESS"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> createPost(String category, double price, String seller, String size, String title) async {
    FirebaseStorage _storage = FirebaseStorage.instance;
    String fileName = basename(_imagePath);
    File _imageFile = File(_imagePath);

    try {
      await _storage.ref("$fileName").putFile(_imageFile);
      String imageURL = await _storage.ref("$fileName").getDownloadURL();
      await createPostInFirebase(category, price, seller, size, title, imageURL);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainContainer(Global.user)), (Route<dynamic> route) => false);
    } on FirebaseException catch (e) {
      print("ERREUR");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer une nouvelle annonce')),
      body: SingleChildScrollView(
        child: Center(
            child: Form(
                key: _formKey,
                child : Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TakePictureScreen(update: _update,))
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          height: 400,
                          child: Center(
                              child: _imagePath != "" ? Image.file(File(_imagePath)) : Text("Appuyer ici pour prendre une photo", style: TextStyle(fontSize: 20),)
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text("Catégorie: ", style: TextStyle(fontSize: 15)),
                          Container(
                            decoration: border(),
                            width: 300.0,
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  value: categoryValue,
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: TextStyle(color: Colors.black, fontSize: 18),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      categoryValue = newValue;
                                    });
                                  },
                                  items: <String>['Maillot', 'Montre']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.title),
                            hintText: "Titre de l'annonce",
                            labelText: 'Titre'
                        ),
                        onSaved: (String value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                        validator: (String value) {
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: sizeController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.height),
                          hintText: "Taille du produit",
                          labelText: 'Taille',
                        ),
                        onSaved: (String value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                        validator: (String value) {
                          return value.contains('@') ? 'Do not use the @ char.' : null;
                        },
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: priceController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.euro),
                          hintText: 'Prix de vente',
                          labelText: 'Prix',
                        ),
                        onSaved: (String value) {
                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        },
                        validator: (String value) {
                          return value.contains('@') ? 'Do not use the @ char.' : null;
                        },
                      ),
                      MaterialButton(
                          minWidth: 300.0,
                          height: 35,
                          color: Color.fromRGBO(9, 177, 186, 1),
                          child: new Text('Valider',
                              style: new TextStyle(fontSize: 16.0, color: Colors.white)),
                          onPressed: () {
                            createPost(categoryValue, double.parse(priceController.text), Global.user.login, sizeController.text, titleController.text);
                          }
                      )
                    ]
                )
            )
        ),
      )
    );
  }

}