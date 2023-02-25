
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/favorite_news.viewmodel.dart';
import 'news_list.widget.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    FavoriteNewsViewModel favoriteNewsVM = context.watch<FavoriteNewsViewModel>();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, favoriteNewsVM.getFavoriteIds());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Favorites"),
          centerTitle: true,
        ),
        body: NewsListWidget(favoriteNewsVM),
      ),
    );
  }
}
