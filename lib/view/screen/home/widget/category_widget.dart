import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/helper/responsive.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/category.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;
  const CategoryWidget({Key key, @required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: (MediaQuery.of(context).size.width / 2.9),
        height: (MediaQuery.of(context).size.width / 4.3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
          color: Theme.of(context).highlightColor,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
          child: Stack(children: [
            Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                color: Colors.black26,
              ),
              child: CachedNetworkImage(
                colorBlendMode: BlendMode.color,
                height: Responsive.isMobile(context) ? 200 : 400,
                width: Responsive.isMobile(context) ? 200 : 400,
                fit: BoxFit.cover,
                imageUrl:
                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}'
                    '/${category.icon}',
                placeholder: (c, o) => Image.asset(Images.placeholder,
                    height: Responsive.isMobile(context) ? 200 : 400,
                    fit: BoxFit.cover),
              ),
            ),
            Positioned.fill(
              top: 60,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  category.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: mulishBold.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: ColorResources.WHITE),
                ),
              ),
            )
          ]),
        ),
      ),
      // SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      // Container(
      //   child: Center(
      //     child: Text(
      //       category.name,
      //       textAlign: TextAlign.center,
      //       maxLines: 1,
      //       overflow: TextOverflow.ellipsis,
      //       style: mulishRegular.copyWith(
      //           fontSize: Dimensions.fontSizeSmall,
      //           color: ColorResources.getTextTitle(context)),
      //     ),
      //   ),
      // ),
    ]);
  }
}
