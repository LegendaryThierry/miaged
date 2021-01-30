import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Article.dart';
import 'ArticleCard.dart';

class AccueilTab extends StatefulWidget {
  AccueilTab(this.articles, this.callbackAdd);
  List<Article> articles;
  Function(Article) callbackAdd;
  bool descPrice = true;

  @override
  AccueilTabState createState() => AccueilTabState();
}

class AccueilTabState extends State<AccueilTab> {
  List<Article> maillots = new List<Article>();
  List<Article> montres = new List<Article>();

  @override
  void initState(){
    widget.articles.sort((b, a) => a.price.compareTo(b.price));
  }

  @override
  Widget build(BuildContext context) {
    maillots.clear();
    montres.clear();
    widget.articles.forEach((element) {
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
            title: Text("MIAGED"),
            actions: <Widget>[ widget.descPrice == false ?
              FlatButton.icon(
                textColor: Colors.white,
                onPressed: () {
                  widget.articles.sort((b, a) => a.price.compareTo(b.price));
                  widget.descPrice = true;
                  setState(() {

                  });
                },
                label: Text("Trie par prix croissant"),
                icon: Icon(Icons.arrow_upward)
              ) :
              FlatButton.icon(
                  textColor: Colors.white,
                  onPressed: () {
                    widget.articles.sort((a, b) => a.price.compareTo(b.price));
                    widget.descPrice = false;
                    setState(() {

                    });
                  },
                  label: Text("Trie par prix décroissant"),
                  icon: Icon(Icons.arrow_downward)
              )
            ],
          ),
          body: TabBarView(
            children: [
              GridView.count(
                childAspectRatio: (200 / 350),
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                children: List.generate(widget.articles.length, (index) {
                  return Center(
                      child: ArticleCard(widget.articles[index], widget.callbackAdd)
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
                      child: ArticleCard(maillots[index], widget.callbackAdd)
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
                      child: ArticleCard(montres[index], widget.callbackAdd)
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