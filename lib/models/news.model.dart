

class Article {
  int id;
  String title;
  DateTime createdAt;
  String author;
  int numComments;
  int points;
  String? url;

  Article({
        required this.id,
        required this.title,
        required this.createdAt,
        required this.author,
        required this.numComments,
        required this.points,
        required this.url,
    });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
      id: json["objectID"] is int ? json["objectID"] : int.parse(json["objectID"]),
      title: json["title"] ?? "",
      createdAt: DateTime.parse(json["created_at"]),
      author: json["author"] ?? "",
      numComments: json["num_comments"] ?? 0,
      points: json["points"] ?? 0,
      url: json["url"],
  );

  Map<String, dynamic> toJson() => {
      "objectID": id,
      "title": title,
      "created_at": createdAt.toIso8601String(),
      "author": author,
      "points": points,
      "num_comments": numComments,
      "url": url,
  };
}

