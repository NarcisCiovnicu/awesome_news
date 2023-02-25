import 'package:awesome_news/view_models/favorite_news.viewmodel.dart';
import 'package:awesome_news/view_models/filters.viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/dependencies.dart';
import 'utils/themes.dart';
import 'view_models/news.viewmodel.dart';
import 'views/home.view.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsViewModel()),
        ChangeNotifierProvider(create: (_) => FavoriteNewsViewModel()),
        ChangeNotifierProvider(create: (_) => FiltersViewModel()),
      ],
      child: MaterialApp(
        title: 'Awesome news',
        theme: MyThemes.getLightTheme(),
        darkTheme: MyThemes.getDarkTheme(),
        themeMode: ThemeMode.system,
        home: const HomeView(),
      ),
    );
  }
}

