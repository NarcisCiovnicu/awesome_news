
import 'news.model.dart';

class SearchResult {
  final List<Article> news;
  final int page;
  final int noPages;
  
  SearchResult(this.news, this.page, this.noPages);
}