import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miaged/MainContainer.dart';

import 'Article.dart';
import 'Global.dart';
import 'User.dart';



class ArticleDetails extends StatelessWidget {
  ArticleDetails(this.article);
  final Article article;

  int _currentIndex = 0;
  List cardList = [];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < 4; i++) {
      cardList.add(Container(
        margin: EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: NetworkImage(article.url),
            fit: BoxFit.cover,
          ),
        ),
      ));
    }

    return Scaffold(
        appBar: AppBar(
            title: Text("MIAGED")
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            children: <Widget>[
              Text(
                  article.title,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold)
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 400.0,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  pauseAutoPlayOnTouch: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    _currentIndex = index;
                  },
                ),
                items: cardList.map((card) {
                  return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.30,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: Card(
                            color: Colors.blueAccent,
                            child: card,
                          ),
                        );
                      }
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: map<Widget>(cardList, (index, url) {
                  return Container(
                    width: 10.0,
                    height: 10.0,
                    margin: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index ? Colors.blueAccent : Colors
                          .grey,
                    ),
                  );
                }),
              ),
              Text(
                  article.size + " - " + article.seller,
                  style: new TextStyle(fontSize: 16.0,)
              ),
              Text(
                  article.price.toString() + " €",
                  style: new TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold)
              ),
              Spacer(),
              new Container(
                  child: MaterialButton(
                      minWidth: double.infinity,
                      height: 50,
                      color: Color.fromRGBO(9, 177, 186, 1),
                      child: new Text('Ajouter au panier',
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white)),
                      onPressed: () async {
                        await addToBasket(Global.user, article);
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainContainer(Global.user)), (Route<dynamic> route) => false);
                      }
                  ))
            ],
          ),
        )
    );
  }

  Future<void> addToBasket(User user, Article article) async {
    await FirebaseFirestore.instance.collection("baskets")
        .add({
      "userID": user.id,
      "articleID": article.id
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}