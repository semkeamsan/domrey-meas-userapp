import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/helper/responsive.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ProductTitleView extends StatelessWidget {
  final Product productModel;
  ProductTitleView({@required this.productModel});

  @override
  Widget build(BuildContext context) {
    String ratting = productModel != null &&
            productModel.rating != null &&
            productModel.rating.length != 0
        ? productModel.rating[0].average.toString()
        : "0";
    double _startingPrice = 0;
    double _endingPrice;
    if (productModel.variation != null && productModel.variation.length != 0) {
      List<double> _priceList = [];
      productModel.variation
          .forEach((variation) => _priceList.add(variation.price));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if (_priceList[0] < _priceList[_priceList.length - 1]) {
        _endingPrice = _priceList[_priceList.length - 1];
      }
    } else {
      _startingPrice = productModel.unitPrice;
    }

    return productModel != null
        ? Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Consumer<ProductDetailsProvider>(
              builder: (context, details, child) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          padding: EdgeInsets.only(
                              right: Dimensions.PADDING_SIZE_DEFAULT),
                          child: Text(
                            '${_startingPrice != null ? PriceConverter.convertPrice(context, _startingPrice, discount: productModel.discount, discountType: productModel.discountType) : ''}'
                            '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: productModel.discount, discountType: productModel.discountType)}' : ''}',
                            style: mulishBold.copyWith(
                                color: ColorResources.getPrimary(context),
                                fontSize: Dimensions.fontSizeLarge),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).highlightColor,
                              border: Border.all(
                                  color: ColorResources.getPrimary(context),
                                  width: 1)),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            child: Text(
                                '${productModel.discount}' + '%' + ' ' + 'OFF',
                                style: mulishRegular.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                    color: Theme.of(context).primaryColor)),
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            if (Provider.of<ProductDetailsProvider>(context,
                                        listen: false)
                                    .sharableLink !=
                                null) {
                              Share.share(Provider.of<ProductDetailsProvider>(
                                      context,
                                      listen: false)
                                  .sharableLink);
                            }
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Theme.of(context).highlightColor,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[
                                        Provider.of<ThemeProvider>(context,
                                                    listen: false)
                                                .darkTheme
                                            ? 700
                                            : 200],
                                    spreadRadius: 1,
                                    blurRadius: 5)
                              ],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.share,
                              color: ColorResources.getPrimary(context),
                              size: Responsive.isMobile(context)
                                  ? Dimensions.iconSizeMedium
                                  : Dimensions.iconSizeMedium,
                            ),
                          ),
                        ),
                      ]),
                      Column(
                        children: [
                          productModel.discount != null &&
                                  productModel.discount > 0
                              ? Text(
                                  '${PriceConverter.convertPrice(context, _startingPrice)}'
                                  '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
                                  style: mulishRegular.copyWith(
                                      color: Theme.of(context).hintColor,
                                      fontSize: Dimensions.fontSizeDefault,
                                      decoration: TextDecoration.lineThrough),
                                )
                              : SizedBox(),
                          SizedBox(
                              height:
                                  Dimensions.PADDING_SIZE_EXTRA_EXTRA_SMALL),
                        ],
                      ),
                      Text(productModel.name ?? '',
                          style: mulishTitleRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              fontWeight: FontWeight.w100),
                          maxLines: 2),
                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${productModel.rating != null ? productModel.rating.length > 0 ? double.parse(productModel.rating[0].average) : 0.0 : 0.0}' +
                                      ' ',
                                  style: mulishRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: ColorResources.YELLOW),
                                ),
                                RatingBar(
                                  rating: double.parse(ratting),
                                  size: 15,
                                ),
                              ],
                            ),
                            InkWell(
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                child: Row(
                                  children: [
                                    Text(
                                        '${details.reviewList != null ? details.reviewList.length : 0} reviews | ',
                                        style: mulishRegular.copyWith(
                                          color: Theme.of(context).hintColor,
                                          fontSize: Dimensions.fontSizeDefault,
                                        )),
                                    Text('${details.orderCount} orders | ',
                                        style: mulishRegular.copyWith(
                                          color: Theme.of(context).hintColor,
                                          fontSize: Dimensions.fontSizeDefault,
                                        )),
                                    Text('${details.wishCount} wish',
                                        style: mulishRegular.copyWith(
                                          color: Theme.of(context).hintColor,
                                          fontSize: Dimensions.fontSizeDefault,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      productModel.colors.length > 0
                          ? Row(children: [
                              Text(
                                  '${getTranslated('select_variant', context)} : ',
                                  style: mulishRegular.copyWith(
                                      fontSize: Dimensions.fontSizeLarge)),
                              SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  itemCount: productModel.colors.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    String colorString = '0xff' +
                                        productModel.colors[index].code
                                            .substring(1, 7);
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          padding: EdgeInsets.all(Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color:
                                                Color(int.parse(colorString)),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ])
                          : SizedBox(),
                      productModel.colors.length > 0
                          ? SizedBox(height: Dimensions.PADDING_SIZE_SMALL)
                          : SizedBox(),
                      productModel.choiceOptions != null &&
                              productModel.choiceOptions.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: productModel.choiceOptions.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          '${getTranslated('available', context)}' +
                                              ' ' +
                                              '${productModel.choiceOptions[index].title} :',
                                          style: mulishRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeLarge)),
                                      SizedBox(
                                          width: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: GridView.builder(
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 6,
                                              crossAxisSpacing: 5,
                                              mainAxisSpacing: 5,
                                              childAspectRatio: (1 / .7),
                                            ),
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: productModel
                                                .choiceOptions[index]
                                                .options
                                                .length,
                                            itemBuilder: (context, i) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: .3,
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                      productModel
                                                          .choiceOptions[index]
                                                          .options[i]
                                                          .trim(),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: mulishRegular
                                                          .copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeDefault,
                                                      )),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ]);
                              },
                            )
                          : SizedBox(),
                    ]);
              },
            ),
          )
        : SizedBox();
  }
}