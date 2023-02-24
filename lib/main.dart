import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imgur/data/network/network_manager.dart';
import 'package:imgur/data/remote_api/remote_api.dart';
import 'package:imgur/data/repositories/favorites_repository.dart';
import 'package:imgur/data/repositories/images_repository.dart';
import 'package:imgur/data/services/services.dart';
import 'package:imgur/routing/router.dart';
import 'package:imgur/ui/home_page/cubit/home_cubit.dart';

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
      child: const ImgurTestApp(),
    ),
  );
}

class ImgurTestApp extends StatelessWidget {
  const ImgurTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<DioHttpClient>(
            create: (context) => DioHttpClient(),
          ),
          RepositoryProvider<ImgurApi>(
            create: (context) =>
                ImgurApiImpl(dio: context.read<DioHttpClient>().dio),
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
          BlocProvider<HomePageCubit>(
            create: (context) => HomePageCubit(
                imagesRepository: context.read<ImagesRepository>(),
                favoritesRepository: context.read<FavoritesRepository>()),
          )
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData.dark(),
          routerConfig: router,
        ));
  }
}
