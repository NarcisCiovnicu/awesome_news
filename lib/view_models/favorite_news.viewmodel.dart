import 'package:awesome_news/models/news.model.dart';
import 'package:awesome_news/services/favorite_news.service.dart';
import 'package:awesome_news/view_models/error.viewmodel.dart';
import '../utils/dependencies.dart';
import 'article.viewmodel.dart';
import 'base_news.vewmodel.dart';

class FavoriteNewsViewModel extends BaseNewsViewModel {
  final IFavoriteNewsService _favoriteNewsService =
      locator<IFavoriteNewsService>();

  FavoriteNewsViewModel() {
    fetchNews();
  }

  @override
  fetchNews() async {
    setLoading(true);

    try {
      List<Article> response = await _favoriteNewsService.fetchAllFavorites();
      
      var news = response.map((article) => ArticleViewModel(article, true)).toList();
      super.setNews(news);

    } on Exception catch (ex) {
      super.setError(ErrorViewModel(message: ex.toString()));
    }
    
    setLoading(false);
  }

  Future<void> addToFavorite(ArticleViewModel articleVM) async {
    articleVM.isFavorite = true;
    super.news.add(articleVM);
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> removeFromFavorites(ArticleViewModel articleVM) async {
    articleVM.isFavorite = false;
    news.removeWhere((element) => element.id == articleVM.id);
    await _saveFavorites();
    notifyListeners();
  }

  Set<int> getFavoriteIds() {
    return news.map((fav) => fav.id).toSet();
  }

  _saveFavorites() async {
    await _favoriteNewsService
        .saveAllFavorites(news.map((avm) => avm.toArticle()).toList());
  }
}
