import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imgur/data/repositories/favorites_repository.dart';
import 'package:imgur/data/repositories/images_repository.dart';
import 'package:imgur/ui/home_page/view/home_provider.dart';
import 'package:mockito/mockito.dart';
class MockImagesRepository extends Mock implements ImagesRepository {}
class MockFavoritesRepository extends Mock implements FavoritesRepository {}
void main() {
  
  group('HomePageView', () {
    late ImagesRepository imagesRepository;
    late FavoritesRepository favoritesRepository;

    setUp(() {
      imagesRepository = MockImagesRepository();
      favoritesRepository = MockFavoritesRepository();
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      // Build the widget tree with the provided dependencies.
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: imagesRepository),
            RepositoryProvider.value(value: favoritesRepository),
          ],
          child: const MaterialApp(home: HomePageProvider()),
        ),
      );

      // Find the widget you want to test.
      final titleFinder = find.text('welcome'.tr());
      expect(titleFinder, findsOneWidget);
    });
  });
}