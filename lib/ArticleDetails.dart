import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miaged/MainContainer.dart';
import 'package:status_alert/status_alert.dart';

import 'Article.dart';
import 'Global.dart';
import 'User.dart';


class ArticleDetails extends StatefulWidget{
  ArticleDetails(this.article, this.callbackAdd);
  final Article article;
  Function(Article) callbackAdd;

  int _currentIndex = 0;
  List cardList = [];

  @override
  ArticleDetailsState createState() => new ArticleDetailsState();
}

class ArticleDetailsState extends State<ArticleDetails> {
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    widget.cardList.clear();
    for (var i = 0; i < widget.article.urls.length; i++) {
      widget.cardList.add(Container(
        margin: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: NetworkImage(widget.article.urls[i]),
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
                  widget.article.title,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold)
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 400.0,
                  autoPlay: widget.cardList.length > 1 ? true : false,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  pauseAutoPlayOnTouch: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    //widget._currentIndex = index;
                    //print(index);
                    setState(() {
                      widget._currentIndex = index;
                    });
                  },
                ),
                items: widget.cardList.map((card) {
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
              Row( //LIGNE DE POINTS
                mainAxisAlignment: MainAxisAlignment.center,
                children: map<Widget>(widget.cardList, (index, url) {
                  return Container(
                    width: 10.0,
                    height: 10.0,
                    margin: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget._currentIndex == index ? Colors.blueAccent : Colors.grey,
                    ),
                  );
                }),
              ),
              Text(
                  widget.article.size + " - " + widget.article.seller,
                  style: new TextStyle(fontSize: 16.0,)
              ),
              Text(
                  widget.article.price.toString() + " €",
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
                        await addToBasket(Global.user, widget.article);
                        StatusAlert.show(
                          context,
                          duration: Duration(seconds: 2),
                          title: 'Ajouté avec succès',
                          configuration: IconConfiguration(icon: Icons.done),
                        );
                        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainContainer(Global.user)), (Route<dynamic> route) => false);
                        widget.callbackAdd(widget.article);
                        Navigator.pop(context);
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