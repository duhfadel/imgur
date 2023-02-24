import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:imgur/ui/details_page/details.dart';
import 'package:imgur/ui/home_page/view/home_view.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePageView();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'details',
          builder: (BuildContext context, GoRouterState state) {
            Map<String, dynamic> args = state.extra as Map<String, dynamic>;
            return DetailsPage(
              homePageCubit: args['homePageCubit'],
              imgurImage: args['imgurImage'],
            );
          },
        ),
      ],
    ),
  ],
);
