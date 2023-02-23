import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imgur/data/repositories/favorites_repository.dart';
import 'package:imgur/data/repositories/images_repository.dart';
import 'package:imgur/ui/home_page/cubit/home_cubit.dart';
import 'package:imgur/ui/home_page/view/home_view.dart';

class HomePageProvider extends StatelessWidget {
  const HomePageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomePageCubit>(
      create: (context) => HomePageCubit(
          imagesRepository: context.read<ImagesRepository>(),
          favoritesRepository: context.read<FavoritesRepository>()),
      child: HomePageView(),
    );
  }
}
