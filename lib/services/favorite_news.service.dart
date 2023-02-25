

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/news.model.dart';

abstract class IFavoriteNewsService {
  Future<List<Article>> fetchAllFavorites();
  Future<void> saveAllFavorites(List<Article> favoriteNews);
}

class FavoriteNewsLocalService implements IFavoriteNewsService {
  final String _FAV_NEWS_KEY = "favorite_news";

  @override
  Future<List<Article>> fetchAllFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = prefs.getStringList(_FAV_NEWS_KEY) ?? [];
    List<Article> news = jsonList.map((json) =>  Article.fromJson(jsonDecode(json))).toList();
    return news;
  }
  
  @override
  Future<void> saveAllFavorites(List<Article> favoriteNews) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = favoriteNews.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_FAV_NEWS_KEY, jsonList);
  }
}
