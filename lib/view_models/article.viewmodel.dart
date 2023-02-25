import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/news.model.dart';

class ArticleViewModel {
  int id;
  String title;
  DateTime createdAt;
  String author;
  int numComments;
  int points;
  String? url;

  bool isFavorite;

  ArticleViewModel(Article article, [this.isFavorite = false])
      : id = article.id,
        title = article.title,
        createdAt = article.createdAt,
        author = article.author,
        numComments = article.numComments,
        points = article.points,
        url = article.url;

  Article toArticle() => Article(
      id: id,
      title: title,
      createdAt: createdAt,
      author: author,
      numComments: numComments,
      points: points,
      url: url,
    );

  void openUrl() async {
    try {
      if (url == null) {
        await _cantLaunchUrlToast();
        return;
      }
      Uri uri = Uri.parse(url!);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        await _cantLaunchUrlToast();
      }
    } on FormatException {
      await _cantLaunchUrlToast();
    }
  }

  _cantLaunchUrlToast() async {
    await Fluttertoast.cancel();
    await Fluttertoast.showToast(
        msg: "URL can't be launched: $url",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        fontSize: 16.0);
  }
}
