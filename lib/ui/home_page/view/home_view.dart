import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:imgur/ui/home_page/cubit/home_cubit.dart';
import 'package:imgur/ui/home_page/cubit/home_state.dart';
import 'package:imgur/ui/home_page/models/imgur_image.dart';
import 'package:imgur/resources/margins.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  late final ScrollController _scrollController;

  late final TextEditingController _queryController;

  late final GlobalKey<ScaffoldState> scaffoldKey;

  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _queryController = TextEditingController();
    _scrollController = ScrollController();
    scaffoldKey = GlobalKey<ScaffoldState>();
    _focusNode.addListener(() {
      context.read<HomePageCubit>().changeFocus(_focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _queryController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    HomePageCubit homePageCubit = context.read<HomePageCubit>();
    homePageCubit.refreshRecentSearches();
    return Scaffold(
        key: scaffoldKey,
        drawer: _buildDrawer(homePageCubit),
        body: _buildBody(homePageCubit, context));
  }

  Widget _buildDrawer(HomePageCubit homePageCubit) {
    return Drawer(
      child: BlocBuilder<HomePageCubit, HomePageState>(
          bloc: homePageCubit,
          builder: (context, state) {
            return Column(
              children: [
                Text(
                  'favorites'.tr(),
                  style: TextStyle(fontSize: mediumSize),
                ),
                _buildFavoriteList(state, homePageCubit),
                Text(
                  'delete'.tr(),
                  style: TextStyle(fontSize: smallSize),
                ),
                SizedBox(
                  height: minimumSize,
                )
              ],
            );
          }),
    );
  }

  Widget _buildFavoriteList(HomePageState state, HomePageCubit homePageCubit) {
    return Expanded(
      child: ListView.builder(
        itemCount: state.listFavorites.length,
        itemBuilder: (context, index) {
          ImgurImage favorite = state.listFavorites[index];
          return _buildFavoriteItem(context, favorite, homePageCubit);
        },
      ),
    );
  }

  Widget _buildFavoriteItem(
      BuildContext context, ImgurImage favorite, HomePageCubit homePageCubit) {
    return InkWell(
        onTap: () => context.go('/details',
            extra: {'homePageCubit': homePageCubit, 'imgurImage': favorite}),
        onLongPress: () {
          _buildShowDialog(context, favorite, homePageCubit);
        },
        child: Card(
            child: Text(
          favorite.title,
          style: TextStyle(fontSize: smallSize),
        )));
  }

  Future<void> _buildShowDialog(
      BuildContext context, ImgurImage favorite, HomePageCubit homePageCubit) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('removeList'.tr()),
            content: Text(favorite.title),
            actions: [
              TextButton(
                onPressed: () {
                  homePageCubit.removeFavorite(favorite);
                  Navigator.of(context).pop();
                },
                child: Text('remove'.tr()),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('close'.tr()),
              ),
            ],
          );
        });
  }

  Widget _buildBody(HomePageCubit homePageCubit, BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        _buildSearchbar(homePageCubit, context),
        _buildWelcomeMesage(),
        _buildGridViewHeader(homePageCubit)
      ],
    ));
  }

  Widget _buildWelcomeMesage() {
    return Padding(
      padding: EdgeInsets.all(minimumSize),
      child: Text('welcome'.tr()),
    );
  }

  Widget _buildGridViewHeader(HomePageCubit homePageCubit) {
    return BlocBuilder<HomePageCubit, HomePageState>(
        bloc: homePageCubit,
        builder: (context, state) {
          return Expanded(
              child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  _focusNode.unfocus();
                },
                child: AbsorbPointer(
                  absorbing: state.hasFocus,
                  child: _buildGridView(homePageCubit, state),
                ),
              ),
              if (state.isLoading)
                Positioned(
                    bottom: smallSize,
                    left: 0,
                    right: 0,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ))
            ],
          ));
        });
  }

  GridView _buildGridView(HomePageCubit homePageCubit, HomePageState state) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        controller: _scrollController //
          ..addListener(() {
            if (_scrollController.offset ==
                _scrollController.position.maxScrollExtent) {
              if (_queryController.text.isNotEmpty) {
                homePageCubit.searchImages(_queryController.text,
                    page: homePageCubit.incrementPage());
              } else {
                homePageCubit.fetchMostPopularImages(
                    page: homePageCubit.incrementPage());
              }
            }
          }),
        itemCount: state.listImages.length,
        itemBuilder: (context, index) {
          return _gridViewItem(state, index, context, homePageCubit);
        });
  }

  Widget _gridViewItem(HomePageState state, int index, BuildContext context,
      HomePageCubit homePageCubit) {
    return InkWell(
      key: ValueKey<String>('${state.listImages[index].id}'
          '${state.listImages[index].favorite}'),
      onTap: () => context.go('/details', extra: {
        'homePageCubit': homePageCubit,
        'imgurImage': state.listImages[index]
      }),
      child: Card(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(minimumSize),
                  child: Text(
                    state.listImages[index].title,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: FadeInImage.assetNetwork(
                      placeholder: placeholderPath,
                      image:
                          state.listImages[index].imagesDetails?[0].link ?? '',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                SizedBox(
                  height: smallSize,
                )
              ],
            ),
            Positioned(
              bottom: minimumSize,
              right: minimumSize,
              child: IconButton(
                  onPressed: () {
                    homePageCubit.addFavorite(state.listImages[index]);
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: (state.listImages[index].favorite)
                        ? Colors.red
                        : Colors.white,
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchbar(HomePageCubit homePageCubit, BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
        bloc: homePageCubit,
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    homePageCubit.refreshLists();
                    scaffoldKey.currentState?.openDrawer();
                  },
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )),
              SizedBox(
                width: smallSize,
              ),
              SizedBox(
                  height: extraMediumSize,
                  width: extraLargeSize,
                  child: RawAutocomplete<String>(
                    focusNode: _focusNode,
                    textEditingController: _queryController,
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return state.listSearches.where((String option) {
                        return option
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController queryController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      return TextFormField(
                        controller: queryController,
                        focusNode: focusNode,
                        onFieldSubmitted: (String value) {
                          onFieldSubmitted();
                        },
                      );
                    },
                    optionsViewBuilder: (BuildContext context,
                        AutocompleteOnSelected<String> onSelected,
                        Iterable<String> options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          child: SizedBox(
                            height: extraLargeSize,
                            width: extraExtraLargeSize,
                            child: ListView.builder(
                              padding: EdgeInsets.all(minimumSize),
                              itemCount: state.listSearches.length,
                              itemBuilder: (BuildContext context, int index) {
                                final String option =
                                    state.listSearches.elementAt(index);
                                return Row(
                                  children: [
                                    GestureDetector(
                                        onTap: () => onSelected(option),
                                        child: Text(option)),
                                    Expanded(child: Container()),
                                    IconButton(
                                        onPressed: () => homePageCubit
                                            .removeRecentSearch(option),
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  )),
              SizedBox(
                width: smallSize,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_queryController.text.isNotEmpty) {
                      homePageCubit.searchImages(_queryController.text);
                      homePageCubit.addRecentSearch(_queryController.text);
                    } else {
                      homePageCubit.fetchMostPopularImages();
                    }
                  },
                  child: const Icon(Icons.search)),
            ],
          );
        });
  }
}

String placeholderPath = 'lib/resources/images/placeholder.png';
