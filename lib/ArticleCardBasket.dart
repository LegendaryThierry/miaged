import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miaged/BasketTab.dart';

import 'Article.dart';
import 'ArticleDetails.dart';
import 'Global.dart';

class ArticleCardBasket extends StatelessWidget{
  ArticleCardBasket(this.article);
  final Article article;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
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