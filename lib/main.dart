import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splashscreen/splashscreen.dart';

import 'Global.dart';
import 'MainContainer.dart';
import 'Article.dart';
import 'User.dart';
import 'SignUp.dart';

//Les différentes clés disponibles pour l'Alert Dialog
const List<Key> keys = [
  Key("Network"),
  Key("NetworkDialog"),
  Key("Flare"),
  Key("FlareDialog"),
  Key("Asset"),
  Key("AssetDialog")
];
List<Article> articles = []; //Liste de tous les articles en vente
List<Article> basket = []; //Liste du panier de l'utilisateur

//Fonction principale appelée lors du lancement de l'application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MaterialApp(
    home: new OpenApp(),
  ));
}

//----- Splash Screen de chargement de l'application -----//
class OpenApp extends StatefulWidget {
  @override
  OpenAppState createState() => new OpenAppState();
}

class OpenAppState extends State<OpenApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 5,
        navigateAfterSeconds: new MyApp(),
        title: new Text("Trouvez des produits d'exception",
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
            color: Color.fromRGBO(136, 109, 54, 1)
          ),),
        image: new Image.network('https://firebasestorage.googleapis.com/v0/b/vinted-869ac.appspot.com/o/logo.PNG?alt=media&token=afb6eef5-f542-4426-8870-c4926d5489f2'),
        backgroundColor: Color.fromRGBO(19, 50, 70, 1),
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 150.0,
        onClick: ()=>{},
        loaderColor: Colors.white
    );
  }
}

//----- Ecran de connexion -----//
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIAGED',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: "MIAGED"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController loginController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  //Fonction pour tester si les informations de connexion entrées par l'utilisateur correspondent à un utilisateur inscrit ou pas
  void login() {
    FirebaseFirestore.instance.collection("users")
        .where("login", isEqualTo: loginController.text)
        .where("password", isEqualTo: passwordController.text)
        .get()
        .then((value){
          if(value.size == 1){ //Les informations de connexion sont correctes
            List<QueryDocumentSnapshot> docs = value.docs;
            Global.user = new User(docs[0].id, docs[0]["login"], docs[0]["password"], docs[0]["birthday"], docs[0]["address"], docs[0]["postalCode"], docs[0]["city"], docs[0]["backgroundImage"]);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainContainer(Global.user)),
            );
          }
          else{ //Les informations de connexion sont incorrectes
            showDialog(
                context: context,
                builder: (_) => NetworkGiffyDialog(
                    key: keys[1],
                    image: Image.network(
                      "https://media3.giphy.com/media/KGTTNpVuGVhN6/giphy.gif?cid=ecf05e47mb7j3a60uu2oxlqhk0jiy4q5n0g27c1fjdxinfgt&rid=giphy.gif",
                      fit: BoxFit.cover,
                    ),
                    entryAnimation: EntryAnimation.DEFAULT,
                    title: Text(
                      'ECHEC',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.w600
                      ),
                    ),
                    description: Text(
                        'Identifiant ou mot de passe incorrect',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w600
                        )
                    ),
                    onlyCancelButton: true,
                    buttonCancelColor: Color.fromRGBO(9, 177, 186, 1),
                    buttonCancelText: Text(
                        "Ok",
                        style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1)
                        )
                    )
                ));
          }
      });
    }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container( //--- Logo ---
                  margin: const EdgeInsets.only(top: 100.0, bottom: 10),
                  child: RichText(
                    text: new TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: new TextStyle(
                          fontSize: 50.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                      children: <TextSpan>[
                        new TextSpan(text: 'M'),
                        new TextSpan(text: 'I', style: new TextStyle(color: Color.fromRGBO(9, 177, 186, 1))),
                        new TextSpan(text: 'A', style: new TextStyle(color: Color.fromRGBO(9, 177, 186, 1))),
                        new TextSpan(text: 'G'),
                        new TextSpan(text: 'E'),
                        new TextSpan(text: 'D'),
                      ],
                    ),
                  )
              ),
              SizedBox( //--- Texte animé ---
                width: 300.0,
                height: 75.0,
                child: TypewriterAnimatedTextKit(
                    onTap: () {
                      print("Tap Event");
                    },
                    text: [
                      "Prêt à faire du tri dans vos placards ?",
                      "Prêt à donner une seconde vie à vos produits ?",
                      "Prêt à gagner de l'argent ?",
                      "MIAGED le Bon Coin de l'élite"
                    ],
                    textStyle: TextStyle(
                        fontSize: 22.0,
                        fontFamily: "Horizon",
                        color: Color.fromRGBO(0, 0, 0, 1)
                    ),
                    textAlign: TextAlign.center,
                    alignment: AlignmentDirectional.center // or Alignment.topLeft
                ),
              ),
              Container(
                  margin: const EdgeInsets.all(3.0),
                  width: 300,
                  child: TextField(
                    controller: loginController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Login',
                    ),
                    autofocus: false,
                    obscureText: false,
                  )
              ),
              Container(
                  margin: const EdgeInsets.all(3.0),
                  width: 300,
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Password',
                    ),
                    autofocus: false,
                    obscureText: true,
                  )
              ),
              MaterialButton(
                  minWidth: 300.0,
                  height: 35,
                  color: Color.fromRGBO(9, 177, 186, 1),
                  child: new Text('Se connecter',
                      style: new TextStyle(fontSize: 16.0, color: Colors.white)),
                  onPressed: () {
                    login();
                  }
              ),
              ButtonTheme(
                minWidth: 300.0,
                child:   OutlineButton(
                  child: Text("S'inscrire", style: TextStyle(color: Color.fromRGBO(9, 177, 186, 1))),
                  borderSide: BorderSide(color: Color.fromRGBO(9, 177, 186, 1), width: 2),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}