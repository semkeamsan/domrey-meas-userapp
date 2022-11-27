import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/product_details_screen.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatelessWidget {
  final Product productModel;
  ProductWidget({@required this.productModel});

  @override
  Widget build(BuildContext context) {
    String ratting =
        productModel.rating != null && productModel.rating.length != 0
            ? productModel.rating[0].average
            : "0";

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 1000),
              pageBuilder: (context, anim1, anim2) =>
                  ProductDetails(product: productModel),
            ));
      },
      child: Container(
        height: MediaQuery.of(context).size.width / 1.7,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).highlightColor,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5)
          ],
        ),
        child: Stack(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Product Image
            Container(
              height: MediaQuery.of(context).size.width / 2.9,
              decoration: BoxDecoration(
                color: ColorResources.getIconBg(context),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: FadeInImage.assetNetwork(
                  placeholder: Images.placeholder,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.width / 2.45,
                  image:
                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${productModel.thumbnail}',
                  imageErrorBuilder: (c, o, s) => Image.asset(
                      Images.placeholder_1x1,
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.width / 2.45),
                ),
              ),
            ),

            // Product Details
            Padding(
              padding: EdgeInsets.only(
                  top: Dimensions.PADDING_SIZE_SMALL,
                  bottom: 5,
                  left: 5,
                  right: 5),
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(productModel.name ?? '',
                        textAlign: TextAlign.start,
                        style: mulishRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w400),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      // RatingBar(
                      //   rating: double.parse(ratting),
                      //   size: 18,
                      // ),
                      // Text('(${productModel.reviewCount.toString() ?? '0.0'})',
                      //     style: mulishRegular.copyWith(
                      //       fontSize: Dimensions.fontSizeSmall,
                      //     )),
                    ]),
                    // SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    // productModel.discount != null && productModel.discount > 0
                    //     ? Text(
                    //         PriceConverter.convertPrice(
                    //             context, productModel.unitPrice),
                    //         style: mulishTitleRegular.copyWith(
                    //           color: ColorResources.getRed(context),
                    //           decoration: TextDecoration.lineThrough,
                    //           fontSize: Dimensions.fontSizeExtraSmall,
                    //         ),
                    //       )
                    //     : SizedBox.shrink(),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          PriceConverter.convertPrice(
                              context, productModel.unitPrice,
                              discountType: productModel.discountType,
                              discount: productModel.discount),
                          style: mulishRegular.copyWith(
                              color: ColorResources.getPrimary(context)),
                        ),
                        Row(
                          children: [
                            Text(
                                '${productModel.reviewCount.toString() ?? 0.0}',
                                style: mulishRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: ColorResources.YELLOW)),
                            Icon(
                              Icons.star,
                              size: Dimensions.iconSizeSmall,
                              color: ColorResources.YELLOW,
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),

          // Off

          productModel.discount > 0
              ? Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    height: Dimensions.iconSizeDefault,
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 234, 7, 7),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                    ),
                    child: Center(
                      child: Text(
                        PriceConverter.percentageCalculation(
                            context,
                            productModel.unitPrice,
                            productModel.discount,
                            productModel.discountType),
                        style: mulishRegular.copyWith(
                            color: Theme.of(context).highlightColor,
                            fontSize: Dimensions.fontSizeSmall),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ]),
      ),
    );
  }
}
