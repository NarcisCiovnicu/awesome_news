import 'dart:convert';

import 'package:awesome_news/models/news.model.dart';
import 'package:awesome_news/models/search_criteria.model.dart';
import 'package:awesome_news/models/search_result.model.dart';
import 'package:awesome_news/models/sort_criteria.model.dart';
import 'package:awesome_news/utils/custom_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../utils/constants.dart';

abstract class INewsService {
  Future<SearchResult> fetchNews(SearchCriteria searchCriteria);
}

class NewsApiService implements INewsService {

  @override
  Future<SearchResult> fetchNews(SearchCriteria searchCriteria) async {
    Response response = await http.get(
        Uri.parse("${Constants.NEWS_API_URL}${_getSearchQuery(searchCriteria)}"));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      
      int page = jsonResponse["page"];
      int noPages = jsonResponse["nbPages"];
      
      List<Article> news = (jsonResponse["hits"] as List)
          .map((e) => Article.fromJson(e))
          .toList();
      news = _applyFiltering(news, searchCriteria);

      return SearchResult(news, page, noPages == 0 ? 0 : noPages - 1);
    } else {
      throw CustomException(
          "Error during getting news from API: status code=${response.statusCode}");
    }
  }

  List<Article> _applyFiltering(
      List<Article> news, SearchCriteria searchCriteria) {
    if (searchCriteria.exactDay != null) {
      DateTimeRange oneDay = DateTimeRange(
        start: searchCriteria.exactDay!,
        end: searchCriteria.exactDay!,
      );
      news = _rangeDate(news, oneDay);
    } else {
      if (searchCriteria.searchQuery != null) {
        news = _searchQuery(news, searchCriteria.searchQuery!);
      }
      if (searchCriteria.dateTimeRange != null) {
        news = _rangeDate(news, searchCriteria.dateTimeRange!);
      }
      if (searchCriteria.maxPoints != null) {
        news = news
            .where((article) => article.points <= searchCriteria.maxPoints!)
            .toList();
      }
      if (searchCriteria.minPoints != null) {
        news = news
            .where((article) => article.points >= searchCriteria.minPoints!)
            .toList();
      }
      if (searchCriteria.sortBy != NewsSortCriteria.None) {
        news.sort((a, b) {
          if (searchCriteria.sortBy == NewsSortCriteria.Points) {
            return a.points - b.points;
          } else if (searchCriteria.sortBy == NewsSortCriteria.PublishedDate) {
            return a.createdAt.millisecondsSinceEpoch -
                b.createdAt.millisecondsSinceEpoch;
          }
          return 0;
        });
      }
    }
    return news;
  }

  List<Article> _searchQuery(List<Article> news, String query) {
    return news
        .where((article) =>
            article.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<Article> _rangeDate(List<Article> news, DateTimeRange range) {
    var start = range.start;
    var end = range.end.add(const Duration(hours: 24));
    return news
        .where((article) =>
            article.createdAt.millisecondsSinceEpoch >=
                start.millisecondsSinceEpoch &&
            article.createdAt.millisecondsSinceEpoch <
                end.millisecondsSinceEpoch)
        .toList();
  }

  String _getSearchQuery(SearchCriteria searchCriteria) {
    return "/search?tags=front_page&page=0&hitsPerPage=${searchCriteria.histPerPage}";
  }
}
