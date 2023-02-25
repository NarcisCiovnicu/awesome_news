import 'package:awesome_news/models/search_criteria.model.dart';
import 'package:awesome_news/view_models/news.viewmodel.dart';
import 'package:awesome_news/views/favorites.view.dart';
import 'package:awesome_news/views/filter.widget.dart';
import 'package:awesome_news/views/news_list.widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    NewsViewModel newsVM = context.watch<NewsViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
        centerTitle: true,
        leading: _filtersAction(context, newsVM),
        actions: <Widget>[
          _calendar(context, newsVM),
          _favoriteAction(context, newsVM),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: NewsListWidget(newsVM),
          ),
          //_paginationBar(context, newsVM),
        ],
      ),
    );
  }

  Widget _calendar(BuildContext context, NewsViewModel newsVM) {
    return Container(
      margin: const EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () async {
          DateTime? date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
          );
          if (date != null) {
            var sc = SearchCriteria(exactDay: date);
            newsVM.setSearchCriteria(sc);
            newsVM.search();
          }
          else {
            newsVM.fetchNews();
          }
        },
        child: const Icon(
          Icons.calendar_month_rounded,
        ),
      ),
    );
  }

  Container _filtersAction(BuildContext context, NewsViewModel newsVM) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0),
      child: GestureDetector(
        onTap: () async {
          var searchCriteria = await showDialog<SearchCriteria?>(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return FilterDialogWidget();
              // return MultiProvider(
              //   providers: [
              //     ChangeNotifierProvider(create: (_) => FiltersViewModel()),
              //   ],
              //   child: FilterDialogWidget(),
              // );
            },
          );
          if (searchCriteria != null) {
            newsVM.setSearchCriteria(searchCriteria);
            await newsVM.search();
          }
        },
        child: const Icon(
          Icons.tune,
          size: 26.0,
        ),
      ),
    );
  }

  Container _favoriteAction(BuildContext context, NewsViewModel newsVM) {
    return Container(
      padding: const EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavoritesView()),
          ).then((favoriteIds) {
            newsVM.updateFavorites(favoriteIds as Set<int>);
          });
        },
        child: const Icon(
          Icons.favorite_rounded,
          size: 26.0,
        ),
      ),
    );
  }

  Widget _paginationBar(BuildContext context, NewsViewModel newsVM) {
    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
      height: 40,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () async {
              await newsVM.previousPage();
            },
            child: Icon(
              Icons.arrow_back_outlined,
              color: newsVM.page > 0 ? Colors.white : Colors.black,
            ),
          ),
          Text("${newsVM.page} of ${newsVM.noPages}"),
          GestureDetector(
            onTap: () async {
              await newsVM.nextPage();
            },
            child: Icon(
              Icons.arrow_forward_outlined,
              color:
                  newsVM.page == newsVM.noPages ? Colors.black : Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
