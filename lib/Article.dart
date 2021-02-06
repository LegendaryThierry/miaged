//Classe représentant un article
class Article{
  String id;
  String title;
  String seller;
  double price;
  String size;
  List<String> urls;
  String category;
  double rating;

  Article(this.id, this.title, this.seller, this.price, this.size, this.urls, this.category, this.rating);
}