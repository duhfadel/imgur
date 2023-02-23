import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imgur/data/network/network_manager.dart';
import 'package:imgur/data/repositories/favorites_repository.dart';
import 'package:imgur/data/repositories/images_repository.dart';
import 'package:imgur/data/services/services.dart';
import 'package:imgur/ui/home_page/view/home_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
      ],
      path: 'lib/l10n',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ImgurApi>(
          create: (context) => ImgurApi(),
        ),
        RepositoryProvider<DataService>(
          create: (context) =>
              DataServiceImpl(imgurApi: context.read<ImgurApi>()),
        ),
        RepositoryProvider<ImagesRepository>(
          create: (context) =>
              ImagesRepositoryImpl(dataService: context.read<DataService>()),
        ),
        RepositoryProvider<FavoritesRepository>(
          lazy: false,
          create: (context) => FavoritesRepositoryImpl(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData.dark(),
        home: const HomePageProvider(),
      ),
    );
  }
}
