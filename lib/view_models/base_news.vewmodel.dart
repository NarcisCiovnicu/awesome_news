

import 'package:flutter/material.dart';

import 'article.viewmodel.dart';
import 'error.viewmodel.dart';

abstract class BaseNewsViewModel extends ChangeNotifier {
  bool _loading = false;
  ErrorViewModel? _error;
  List<ArticleViewModel> _news = [];

  ErrorViewModel? get error => _error;
  bool get loading => _loading;
  List<ArticleViewModel> get news => _news;

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  setNews(List<ArticleViewModel> news) {
    _news = news;
  }

  setError(ErrorViewModel errorVM) {
    _error = errorVM;
  }

  void fetchNews();
}
