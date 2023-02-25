import 'package:awesome_news/models/search_criteria.model.dart';
import 'package:awesome_news/models/sort_criteria.model.dart';
import 'package:flutter/material.dart';

class FiltersViewModel extends ChangeNotifier {
  String? searchQuery;
  int? minPoints;
  int? maxPoints;
  DateTimeRange? dateRange;
  NewsSortCriteria sortBy = NewsSortCriteria.None;

  FiltersViewModel();

  FiltersViewModel._internal(this.searchQuery, this.minPoints, this.maxPoints,
      this.sortBy, this.dateRange);

  factory FiltersViewModel.copy(FiltersViewModel filtersVM) =>
      FiltersViewModel._internal(
        filtersVM.searchQuery,
        filtersVM.minPoints,
        filtersVM.maxPoints,
        filtersVM.sortBy,
        filtersVM.dateRange,
      );

  void updateUI() {
    notifyListeners();
  }

  SearchCriteria toSeachCriteria() {
    return SearchCriteria(
      page: 0,
      searchQuery: searchQuery,
      minPoints: minPoints,
      maxPoints: maxPoints,
      dateTimeRange: dateRange,
      sortBy: sortBy
    );
  }

  void copy(FiltersViewModel filtersVM) {
    searchQuery = filtersVM.searchQuery;
    minPoints = filtersVM.minPoints;
    maxPoints = filtersVM.maxPoints;
    sortBy = filtersVM.sortBy;
    dateRange = filtersVM.dateRange;
  }
}
