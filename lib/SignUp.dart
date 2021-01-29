import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miaged/MainContainer.dart';

import 'Global.dart';
import 'User.dart';
import 'main.dart';

class SignUp extends StatefulWidget{
  DateTime selectedDate = DateTime.now();

  @override
  SignUpState createState() => new SignUpState();
}

class SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController loginController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController anniversaireController = new TextEditingController();
  TextEditingController adresseController = new TextEditingController();
  TextEditingController codePostalController = new TextEditingController();
  TextEditingController villeController = new TextEditingController();
  TextEditingController backgroundImageController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> datePicker() async{
      final DateTime picked  = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 150),
          lastDate: DateTime.now()
      );

      if (picked != null && picked != widget.selectedDate) {
        setState(() {
          widget.selectedDate = picked;
          anniversaireController.text = DateFormat('dd/MM/yyyy').format(widget.selectedDate);
        });
      }
    }

    Future<String> createUser(String login, String password, String birthday, String address, String zipCode, String city) async {
      String userID = "";

      await FirebaseFirestore.instance.collection("users")
          .add({
        'address': address,
        'birthday': birthday,
        "login": login,
        "city": city,
        "password": password,
        "postalCode": zipCode
          })
          .then((value) => userID = value.id)
          .catchError((error) => print("Failed to add user: $error"));

      return userID;

      // ----- Ajouter en spécifiant le nom du document -----
      // return await FirebaseFirestore.instance.collection("users")
      //     .doc("user2")
      //     .set({
      //   'address': "6 rue Auguste Lechesne",
      //   'birthday': "27/05/2000",
      //   "login": "t.tsang@studielgroup.fr",
      //   "city": "CAEN",
      //   "password": "123456",
      //   "postalCode": "14000"
      // });
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("MIAGED"),
      ),
      body:
        Form(
            key: _formKey,
            child : Column(
                children: <Widget>[
                  TextFormField(
                    controller: loginController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: 'Votre adresse email',
                        labelText: 'Login'
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
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.lock),
                      hintText: 'Votre mot de passe',
                      labelText: 'Password',
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
                    controller: anniversaireController,
                    onTap: () => {
                      FocusScope.of(context).requestFocus(FocusNode()),
                      datePicker()
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      hintText: "Votre date d'anniversaire",
                      labelText: 'Anniversaire',
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
                    controller: adresseController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.home),
                      hintText: 'Votre adresse de résidence',
                      labelText: 'Adresse',
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
                    controller: codePostalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.location_on),
                      hintText: 'Votre code postal de résidence',
                      labelText: 'Code Postal',
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
                    controller: villeController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.location_city),
                      hintText: 'Votre ville de résidence',
                      labelText: 'Ville',
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
                    controller: backgroundImageController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.image),
                      hintText: 'URL de votre image de fond',
                      labelText: 'Image de fond',
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
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          String userID = await createUser(loginController.text, passwordController.text, anniversaireController.text, adresseController.text, codePostalController.text, villeController.text);
                          Global.user = new User(userID, loginController.text, passwordController.text, anniversaireController.text, adresseController.text, codePostalController.text, villeController.text, backgroundImageController.text);
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainContainer(Global.user)), (Route<dynamic> route) => false);
                        }
                      }
                  )
                ]
            )
        ),
    );
  }
}