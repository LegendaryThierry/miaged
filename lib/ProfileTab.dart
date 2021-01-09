import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Global.dart';
import 'main.dart';

class ProfileTab extends StatefulWidget{
  DateTime selectedDate = DateTime.now();

  @override
  ProfileTabState createState() => new ProfileTabState();
}

class ProfileTabState extends State<ProfileTab>{
  final _formKey = GlobalKey<FormState>();

  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController anniversaireController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController codePostaleController = TextEditingController();
  TextEditingController villeController = TextEditingController();

  @override
  void initState(){
    super.initState();

    loginController.text = Global.user.login;
    passwordController.text = Global.user.password;
    anniversaireController.text = Global.user.birthday;
    adresseController.text = Global.user.address;
    codePostaleController.text = Global.user.postalCode;
    villeController.text = Global.user.city;
  }

  @override
  Widget build(BuildContext context) {
    void updateUserData(String login, String password, String birthday, String address, String postalCode, String city) async{
      DocumentReference documentReference = FirebaseFirestore.instance.collection("users").doc(Global.user.id);

      Map<String, dynamic> userData = {
        "login": login,
        "password": password,
        "birthday": birthday,
        "address": address,
        "postalCode": postalCode,
        "city": city
      };

      await documentReference.set(userData).whenComplete(() => {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Les modifications ont été sauvegardé avec succès'))),
            Global.user.login = login,
            Global.user.password = password,
            Global.user.birthday = birthday,
            Global.user.address = address,
            Global.user.postalCode = postalCode,
            Global.user.city = city
          }
      );
    }

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

    return Scaffold(
        appBar: AppBar(
          title: Text("MIAGED"),
        ),
        body: Form(
          key: _formKey,
          child : Column(
            children: <Widget>[
              TextFormField(
                controller: loginController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Votre adresse email',
                  labelText: 'Login',
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
                controller: codePostaleController,
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
              MaterialButton(
                  minWidth: 300.0,
                  height: 35,
                  color: Color.fromRGBO(9, 177, 186, 1),
                  child: new Text('Valider',
                      style: new TextStyle(fontSize: 16.0, color: Colors.white)),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      updateUserData(loginController.text, passwordController.text, anniversaireController.text, adresseController.text, codePostaleController.text, villeController.text);
                    }
                  }
              ),
              Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: new Container(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: MaterialButton(
                        minWidth: 300.0,
                        height: 35,
                        color: Color.fromRGBO(213, 0, 0, 1),
                        child: new Text('Se déconnecter',
                            style: new TextStyle(fontSize: 16.0, color: Colors.white)),
                        onPressed: () {
                          Global.user = null;
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyApp()), (Route<dynamic> route) => false);
                        }
                      )
                    )
                  )
              ),
            ]
        )
      )
    );
  }

}