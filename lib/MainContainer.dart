import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miaged/AccueilTab.dart';
import 'package:miaged/BasketTab.dart';
import 'package:miaged/ProfileTab.dart';
import 'package:miaged/main.dart';
import 'Article.dart';
import 'Global.dart';
import 'User.dart';

class MainContainer extends StatefulWidget {
  MainContainer(this.user);
  User user;
  List<Article> articles;
  List<Article> basket;
  int bottomNavigationBarItemIndex = 0;

  @override
  MainContainerState createState() => new MainContainerState();
}

class MainContainerState extends State<MainContainer>{
  Future<bool> getData() async {
    await getArticles().then((data) {
        widget.articles = data;
    });

    await getBasket(widget.user, widget.articles).then((data) {
        widget.basket = data;
    });

    //PAS BESOIN D'UN SETSTATE PUISQU'ON UTILISE UN FUTUREBUILDER

    return true;
  }

  Future<bool> task;
  @override
  void initState() {
    super.initState();

    task = getData();
  }

  //Fonction de callback pour être notifié lorsqu'un article est supprimé du panier.
  callback(newBasket) {
    setState(() {
      widget.basket = newBasket;
    });
  }

  @override
  Widget build(BuildContext context) {
    Scaffold display(){
      List<Widget> tabs = [AccueilTab(widget.articles), BasketTab(widget.basket, callback), ProfileTab()];

      return Scaffold(
          body: Center(child: tabs[widget.bottomNavigationBarItemIndex]),
          bottomNavigationBar: _bottomNavigationBar(widget.basket.length)
      );
    }

    return FutureBuilder(
      future: task,
      builder: (context, snapshot){
        if(snapshot.data == true){
          return display();
        }
        else{
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _bottomNavigationBar(int nbBasketItems) {
    return BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Acheter',
          ),
          new BottomNavigationBarItem(
            label: 'Panier',
            icon: new Stack(
                children: <Widget>[
                  new Icon(Icons.shopping_basket),
                  new Positioned(  // draw a red marble
                      top: 0.0,
                      right: 0.0,
                      child: new Container(
                          decoration: new BoxDecoration(color: Colors.red),
                          padding: const EdgeInsets.only(top: 1.0, bottom: 1.0, left: 2.0, right: 2.0),
                          child: new Text(nbBasketItems.toString(), style: TextStyle(color: Colors.white, fontSize: 10))
                      )
                  )
                ]
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          )
        ],
        currentIndex: widget.bottomNavigationBarItemIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color.fromRGBO(9, 177, 186, 1)
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      widget.bottomNavigationBarItemIndex = index;
    });
  }
}

Future<List<Article>> getArticles() async {
  print("----- GET ARTICLES ------");
  List<Article> articles = new List<Article>();

  await FirebaseFirestore.instance
      .collection("articles")
      .get()
      .then((QuerySnapshot querySnapshot) => {
    querySnapshot.docs.forEach((doc) {
      List<String> urls = new List<String>();

      for(int i=1; i<=4; i++){
        if(doc.data().containsKey("url" + i.toString())){ //On test si la clé url1, url2, url3 ou url4 existe pour ce document
          if(doc["url" + i.toString()] != ""){
            urls.add(doc["url" + i.toString()]);
          }
        }
      }

      articles.add(new Article(doc.id, doc["title"], doc["seller"], doc["price"].toDouble(), doc["size"], urls));
    })
  });

  print("----- RETURN ARTICLES ------");
  return articles;
}

Future<List<Article>> getBasket(User user, List<Article> articles) async {
  List<String> articlesIDs = new List<String>();
  List<Article> basket = new List<Article>();

  await FirebaseFirestore.instance
      .collection("baskets")
      .where("userID", isEqualTo: user.id)
      .get()
      .then((QuerySnapshot querySnapshot) =>
  {
    querySnapshot.docs.forEach((doc) {
      articlesIDs.add(doc["articleID"]);
    })
  }).then(
          (value) =>
      {
        articlesIDs.forEach((id) {
          articles.forEach((article) {
            if (article.id == id) {
              basket.add(article);
            }
          });
        }),
      }
  );

  return basket;
}