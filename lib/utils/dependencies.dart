
import 'package:get_it/get_it.dart';

import '../services/favorite_news.service.dart';
import '../services/news.service.dart';


GetIt locator = GetIt.instance;

void setupDependencies() {
  locator.registerSingleton<INewsService>(NewsApiService());
  locator.registerSingleton<IFavoriteNewsService>(FavoriteNewsLocalService());
}