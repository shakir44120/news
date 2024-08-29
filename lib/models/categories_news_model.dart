class CategoriesNewsModel {
  final List<Article> articles;

  CategoriesNewsModel({required this.articles});

  factory CategoriesNewsModel.fromJson(Map<String, dynamic> json) {
    var list = json['articles'] as List;
    List<Article> articlesList = list.map((i) => Article.fromJson(i)).toList();

    return CategoriesNewsModel(articles: articlesList);
  }
}

class Article {
  final String? title;
  final String? description;
  final String? urlToImage;

  Article({this.title, this.description, this.urlToImage});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'],
      description: json['description'],
      urlToImage: json['urlToImage'],
    );
  }
}
