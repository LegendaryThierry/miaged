import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Article.dart';
import 'ArticleCard.dart';

class AccueilTab extends StatelessWidget {
  AccueilTab(this.articles, this.callbackAdd);
  List<Article> articles;
  List<Article> maillots = new List<Article>();
  List<Article> montres = new List<Article>();
  Function(Article) callbackAdd;

  @override
  Widget build(BuildContext context) {
    articles.forEach((element) {
      if(element.category == "Maillot"){
        maillots.add(element);
      }
      else if(element.category == "Montre"){
        montres.add(element);
      }
    });

    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Row (children: [Icon(Icons.all_inclusive), SizedBox(width:5), Text("Tous")]),
                Row (children: [Icon(Icons.accessibility), SizedBox(width:5), Text("Maillot")]),
                Row (children: [Icon(Icons.watch), SizedBox(width:5), Text("Montre")])
              ]
            ),
            title: Text('MIAGED'),
          ),
          body: TabBarView(
            children: [
              GridView.count(
                childAspectRatio: (200 / 350),
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                children: List.generate(articles.length, (index) {
                  return Center(
                      child: ArticleCard(articles[index], callbackAdd)
                  );
                }),
              ),
              GridView.count(
                childAspectRatio: (200 / 350),
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                children: List.generate(maillots.length, (index) {
                  return Center(
                      child: ArticleCard(maillots[index], callbackAdd)
                  );
                }),
              ),
              GridView.count(
                childAspectRatio: (200 / 350),
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                children: List.generate(montres.length, (index) {
                  return Center(
                      child: ArticleCard(montres[index], callbackAdd)
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}