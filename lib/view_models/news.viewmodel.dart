import 'package:awesome_news/models/news.model.dart';
import 'package:awesome_news/models/search_criteria.model.dart';
import 'package:awesome_news/models/search_result.model.dart';
import 'package:awesome_news/services/favorite_news.service.dart';
import 'package:awesome_news/services/news.service.dart';
import 'package:awesome_news/utils/custom_exception.dart';
import 'package:awesome_news/view_models/error.viewmodel.dart';

import '../utils/dependencies.dart';
import 'article.viewmodel.dart';
import 'base_news.vewmodel.dart';

class NewsViewModel extends BaseNewsViewModel {
  final INewsService _newsService = locator<INewsService>();
  final IFavoriteNewsService _favoriteNewsService =
      locator<IFavoriteNewsService>();

  int page = 0;
  int noPages = 1;

  SearchCriteria _searchCriteria = SearchCriteria();

  NewsViewModel() {
    fetchNews();
  }

  @override
  Future<void> fetchNews() async {
    await _loadNews(SearchCriteria());
  }

  Future<void> search() async {
    await _loadNews(_searchCriteria);
  }

  void updateFavorites(Set<int> favoriteIds) {
    setLoading(true);
    for (ArticleViewModel articleVM in news) {
      articleVM.isFavorite = favoriteIds.contains(articleVM.id);
    }
    setLoading(false);
  }

  Future<void> nextPage() async {
    if (loading || page == noPages) {
      return;
    }
    _searchCriteria.page = page + 1;
    await _loadNews(_searchCriteria);
  }

  Future<void> previousPage() async {
    if (loading || page == 0) {
      return;
    }
    _searchCriteria.page = page - 1;
    await _loadNews(_searchCriteria);
  }

  void setSearchCriteria(SearchCriteria searchCriteria) {
    _searchCriteria = searchCriteria;
  }

  Future<void> _loadNews(SearchCriteria criteria) async {
    setLoading(true);
    try {
      SearchResult result = await _newsService.fetchNews(criteria);
      List<Article> favorites = await _favoriteNewsService.fetchAllFavorites();
      Set<int> favIds = favorites.map((fav) => fav.id).toSet();

      var news = result.news
          .map((article) =>
              ArticleViewModel(article, favIds.contains(article.id)))
          .toList();
      super.setNews(news);

      page = result.page;
      noPages = result.noPages;
    } on CustomException catch (ex) {
      super.setError(ErrorViewModel(message: ex.message));
    } on Exception catch (ex) {
      super.setError(ErrorViewModel(message: ex.toString()));
    }
    setLoading(false);
  }
}
