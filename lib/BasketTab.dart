import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miaged/Article.dart';
import 'package:miaged/ArticleCardBasket.dart';
import 'package:miaged/main.dart';

import 'ArticleCard.dart';
import 'Global.dart';

class BasketTab extends StatefulWidget {
  BasketTab(this.basket, this.callback);
  final List<Article> basket;
  Function(List<Article>) callback;

  @override
  BasketTabState createState() => new BasketTabState();
}

class BasketTabState extends State<BasketTab>{
  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    widget.basket.forEach((element) {
      totalPrice += element.price;
    });

    return Scaffold(
        appBar: AppBar(
          title: Text("MIAGED"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Prix total du panier: " + totalPrice.toStringAsFixed(2) + " €", style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
            Expanded(
              child: GridView.count(
                childAspectRatio: (200 / 390),
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                children: List.generate(widget.basket.length, (index) {
                  return Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 15,
                              child: Center(
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  color: Colors.white,
                                  icon: Icon(Icons.clear),
                                  tooltip: 'Supprimer du panier',
                                  onPressed: () {
                                    deleteArticleFromBasket(widget.basket[index]);
                                    widget.basket.removeAt(index);
                                    //setState(() {});
                                    widget.callback(widget.basket);
                                  },
                                ),
                              )
                          ),
                          ArticleCardBasket(widget.basket[index])
                        ],
                      )
                  );
                }),
              )
            )
          ],
        )
    );
  }

  void deleteArticleFromBasket(Article article) async{
    await FirebaseFirestore.instance.collection("baskets")
        .where("articleID", isEqualTo: article.id)
        .where("userID", isEqualTo: Global.user.id)
        .get()
        .then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      })
    });
  }
}