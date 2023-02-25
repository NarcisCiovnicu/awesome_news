import 'package:awesome_news/models/sort_criteria.model.dart';
import 'package:flutter/material.dart';

class SearchCriteria {
  final int histPerPage = 200;
  int page;

  String? searchQuery;
  int? minPoints;
  int? maxPoints;
  DateTimeRange? dateTimeRange;
  NewsSortCriteria sortBy = NewsSortCriteria.None;
  DateTime? exactDay;

  SearchCriteria(
      {this.page = 0,
      this.searchQuery,
      this.minPoints,
      this.maxPoints,
      this.dateTimeRange,
      this.sortBy = NewsSortCriteria.None,
      this.exactDay});
}
