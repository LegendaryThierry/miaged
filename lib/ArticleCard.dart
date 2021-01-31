import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Article.dart';
import 'ArticleDetails.dart';

//Widget en forme de carte permettant d'afficher un article en vente
class ArticleCard extends StatelessWidget{
  ArticleCard(this.article, this.callbackAdd);
  final Article article;
  Function(Article) callbackAdd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector( //GestureDetector permet de créer un widget personnalisé et de gérer les évènements de ce widget
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ArticleDetails(article, callbackAdd))
          );
        },
        child: Container(
            width: 200,
            height: 350,
            child: Card(
              elevation: 3,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    title: Text(article.title),
                    subtitle: Text(
                        article.seller,
                        style: TextStyle(color: Colors.black.withOpacity(0.6))
                    ),
                  ),
                  Image.network(
                      article.urls[0],
                      width: 150,
                      height: 200
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      article.price.toStringAsFixed(2) + " €",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      article.size,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 15
                      ),
                    ),
                  )
                ],
              ),
            )
        )
    );
  }
}