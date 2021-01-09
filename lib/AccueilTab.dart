import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Article.dart';
import 'ArticleCard.dart';

class AccueilTab extends StatelessWidget {
  AccueilTab(this.articles);
  List<Article> articles;

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    articles.forEach((element) {
      totalPrice += element.price;
    });

    return Scaffold(
        appBar: AppBar(
          title: Text("MIAGED"),
        ),
        body: new Stack(
            children: <Widget>[
              Text("Total: " + totalPrice.toString(), style: TextStyle(fontSize: 20)),
              GridView.count(
                childAspectRatio: (200 / 350),
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                children: List.generate(articles.length, (index) {
                  return Center(
                      child: ArticleCard(articles[index])
                  );
                }),
              )
            ]
        )
    );
  }
}