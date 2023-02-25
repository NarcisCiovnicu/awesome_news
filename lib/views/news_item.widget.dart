import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../view_models/article.viewmodel.dart';
import '../view_models/favorite_news.viewmodel.dart';

class NewsItemWidget extends StatelessWidget {
  final ArticleViewModel _articleVM;

  const NewsItemWidget(this._articleVM, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Theme.of(context).backgroundColor.withOpacity(0.4),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 17,
              child: ArticleItemWidget(_articleVM),
            ),
            Expanded(
              flex: 3,
              child: NewsOptionItemWidget(_articleVM),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleItemWidget extends StatelessWidget {
  final ArticleViewModel articleVM;

  const ArticleItemWidget(this.articleVM, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        _title(context),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 6,
                child: _author(context),
              ),
              Expanded(
                flex: 4,
                child: _date(context),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              _points(),
              _url(),
              _comments(),
            ],
          ),
        ),
      ],
    );
  }

  Text _title(BuildContext context) {
    return Text(
      articleVM.title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Container _author(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Text(
        articleVM.author,
        style: Theme.of(context).textTheme.subtitle2,
      ),
    );
  }

  Row _points() {
    return Row(
      children: [
        const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        Text(articleVM.points.toString()),
      ],
    );
  }

  Widget _url() {
    return GestureDetector(
      onTap: articleVM.openUrl,
      child: Icon(
        Icons.language,
        color: articleVM.url == null ? Colors.blueGrey : Colors.blue,
      ),
    );
  }

  Row _comments() {
    return Row(
      children: [
        const Icon(Icons.comment),
        Text(articleVM.numComments.toString()),
      ],
    );
  }

  Widget _date(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.all(10),
      child: Text(
        DateFormat.yMMMd().format(articleVM.createdAt),
        style: Theme.of(context).textTheme.caption,
      ),
    );
  }
}

class NewsOptionItemWidget extends StatelessWidget {
  final ArticleViewModel _articleVM;

  const NewsOptionItemWidget(this._articleVM, {super.key});

  @override
  Widget build(BuildContext context) {
    FavoriteNewsViewModel favoriteNewsVM =
        context.watch<FavoriteNewsViewModel>();
    return Center(
      child: _articleVM.isFavorite
          ? _favoriteIcon(favoriteNewsVM)
          : _unfavoriteIcon(favoriteNewsVM),
    );
  }

  _favoriteIcon(FavoriteNewsViewModel favoriteNewsVM) {
    return GestureDetector(
      onTap: () async {
        await favoriteNewsVM.removeFromFavorites(_articleVM);
      },
      child: const Icon(
        Icons.favorite,
        color: Colors.red,
      ),
    );
  }

  _unfavoriteIcon(FavoriteNewsViewModel favoriteNewsVM) {
    return GestureDetector(
      onTap: () async {
        await favoriteNewsVM.addToFavorite(_articleVM);
      },
      child: const Icon(
        Icons.heart_broken_outlined,
      ),
    );
  }
}
