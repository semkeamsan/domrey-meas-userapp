import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/helper/responsive.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/cart/cart_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';

class BottomCartView extends StatelessWidget {
  final Product product;
  BottomCartView({@required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Responsive.isTab() ? 70 : 60,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Colors.grey[
                  Provider.of<ThemeProvider>(context, listen: false).darkTheme
                      ? 700
                      : 300],
              blurRadius: 15,
              spreadRadius: 1)
        ],
      ),
      child: Row(children: [
        Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Stack(children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CartScreen()));
                  },
                  child: Image.asset(Images.cart_arrow_down_image,
                      width: Dimensions.iconSizeLarge,
                      color: ColorResources.getPrimary(context)),
                ),
                Positioned(
                  top: 0,
                  left: Dimensions.PADDING_SIZE_LARGE,
                  child:
                      Consumer<CartProvider>(builder: (context, cart, child) {
                    return Container(
                      height: Dimensions.iconSizeSmall,
                      width: Dimensions.iconSizeSmall,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorResources.RED,
                      ),
                      child: Text(
                        cart.cartList.length.toString(),
                        style: mulishBold.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall -
                                (Responsive.isTab() ? 10 : 0),
                            color: Theme.of(context).highlightColor),
                      ),
                    );
                  }),
                )
              ]),
            )),
        Expanded(
            flex: 11,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (con) => CartBottomSheet(
                          product: product,
                          callback: () {
                            showCustomSnackBar(
                                getTranslated('added_to_cart', context),
                                context,
                                isError: false);
                          },
                        ));
              },
              child: Container(
                height: 50,
                margin: EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorResources.getPrimary(context),
                ),
                child: Text(
                  getTranslated('add_to_cart', context),
                  style: mulishBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).highlightColor),
                ),
              ),
            )),
      ]),
    );
  }
}
