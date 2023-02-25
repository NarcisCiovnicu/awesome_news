import 'package:flutter/material.dart';

import '../view_models/base_news.vewmodel.dart';
import 'error.widget.dart';
import 'loading.widget.dart';
import 'news_item.widget.dart';

class NewsListWidget extends StatelessWidget {
  final BaseNewsViewModel _newsViewModel;

  const NewsListWidget(this._newsViewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      child: Column(
        children: [
          _newsList(_newsViewModel),
        ],
      ),
    );
  }

  _newsList(BaseNewsViewModel newsVM) {
    if (newsVM.loading) {
      return const LoadingWidget();
    }
    if (newsVM.error != null) {
      return DisplayErrorWidget(newsVM.error!);
    }
    return Expanded(
      child: ListView.separated(
        itemBuilder: (context, index) {
          return NewsItemWidget(newsVM.news[index]);
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 8,
        ),
        itemCount: newsVM.news.length,
      ),
    );
  }
}
