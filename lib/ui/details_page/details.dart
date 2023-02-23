import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:imgur/ui/home_page/cubit/home_cubit.dart';
import 'package:imgur/ui/home_page/models/imgur_image.dart';
import 'package:imgur/resources/margins.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatelessWidget {
  final ImgurImage imgurImage;
  final HomePageCubit homePageCubit;
  const DetailsPage({
    Key? key,
    required this.imgurImage,
    required this.homePageCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildTopRow(context),
        _buildImage(),
        SizedBox(
          height: minimumSize,
        ),
        (imgurImage.description != null)
            ? Text(imgurImage.description as String)
            : const SizedBox.shrink(),
        Text('imageViews'.tr(namedArgs:{'number':'${imgurImage.views}'})),
        SizedBox(
          height: minimumSize,
        ),
        TextButton(
          onPressed: () async {
            await launchUrl(Uri.parse(imgurImage.link));
          },
          child: Text('directLink'.tr()),
        ),
        SizedBox(
          height: minimumSize,
        ),
      ],
    );
  }

  Expanded _buildImage() {
    return Expanded(
      child: FadeInImage.assetNetwork(
        placeholder: 'lib/resources/images/placeholder.png',
        image: imgurImage.imagesDetails?[0].link ?? '',
      ),
    );
  }

  Row _buildTopRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              size: extraMediumSize,
            )),
        Expanded(
          child: Text(
            imgurImage.title,
            style: TextStyle(fontSize: mediumSize),
            textAlign: TextAlign.center,
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              try {
                await homePageCubit.addFavorite(imgurImage);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('addedFavorite'.tr())),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('errorFavorite'.tr())),
                );
              }
            },
            child: Text('addFavorite'.tr())),
      ],
    );
  }
}
