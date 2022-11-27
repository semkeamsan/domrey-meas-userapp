import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatelessWidget {
  final CartModel cartModel;
  final int index;
  final bool fromCheckout;
  const CartWidget(
      {Key key,
      this.cartModel,
      @required this.index,
      @required this.fromCheckout});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(
          //   children: [
          //     cartModel.shopInfo != null
          //         ? Text(cartModel.shopInfo,
          //             maxLines: 1,
          //             overflow: TextOverflow.ellipsis,
          //             style: mulishBold.copyWith(
          //               fontSize: Dimensions.fontSizeDefault,
          //               color: ColorResources.getSecondaryText(context),
          //             ))
          //         : SizedBox(),
          //   ],
          // ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.PADDING_SIZE_DEFAULT),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: FadeInImage.assetNetwork(
                      placeholder: Images.placeholder,
                      height: 100,
                      width: 100,
                      image:
                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${cartModel.thumbnail}',
                      imageErrorBuilder: (c, o, s) => Image.asset(
                          Images.placeholder,
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(child: SizedBox()),
                            !fromCheckout
                                ? InkWell(
                                    onTap: () {
                                      if (Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .isLoggedIn()) {
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .removeFromCartAPI(
                                                context, cartModel.id);
                                      } else {
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .removeFromCart(index);
                                      }
                                    },
                                    child: Container(
                                        width: 20,
                                        height: 20,
                                        child: Image.asset(
                                          Images.delete,
                                          scale: 1,
                                        )),
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(cartModel.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: mulishRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault,
                                    color: ColorResources.getSecondaryText(
                                        context),
                                  )),
                            ),
                            SizedBox(
                              width: Dimensions.PADDING_SIZE_SMALL,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Dimensions.PADDING_SIZE_SMALL,
                        ),
                        Row(
                          children: [
                            // cartModel.discount > 0
                            //     ? Text(
                            //         PriceConverter.convertPrice(
                            //             context, cartModel.price),
                            //         maxLines: 1,
                            //         overflow: TextOverflow.ellipsis,
                            //         style: mulishBold.copyWith(
                            //           color: ColorResources.getRed(context),
                            //           decoration: TextDecoration.lineThrough,
                            //         ),
                            //       )
                            //     : SizedBox(),
                            // SizedBox(
                            //   width: Dimensions.fontSizeDefault,
                            // ),
                            Text(
                              PriceConverter.convertPrice(
                                  context, cartModel.price,
                                  discount: cartModel.discount,
                                  discountType: 'amount'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: mulishRegular.copyWith(
                                  color: ColorResources.getPrimary(context),
                                  fontSize: Dimensions.fontSizeExtraLarge),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Dimensions.PADDING_SIZE_SMALL,
                        ),
                        Provider.of<AuthProvider>(context, listen: false)
                                .isLoggedIn()
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          child: QuantityButton(
                                            isIncrement: false,
                                            index: index,
                                            quantity: cartModel.quantity,
                                            maxQty: cartModel
                                                .productInfo.totalCurrentStock,
                                            cartModel: cartModel,
                                            minimumOrderQuantity: cartModel
                                                .productInfo.minimumOrderQty,
                                          ),
                                        ),
                                        Text(cartModel.quantity.toString(),
                                            style: mulishBold),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          child: QuantityButton(
                                            index: index,
                                            isIncrement: true,
                                            quantity: cartModel.quantity,
                                            maxQty: cartModel
                                                .productInfo.totalCurrentStock,
                                            cartModel: cartModel,
                                            minimumOrderQuantity: cartModel
                                                .productInfo.minimumOrderQty,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: Dimensions
                                            .PADDING_SIZE_EXTRA_LARGE),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Theme.of(context).highlightColor,
                                        border: Border.all(
                                            color: ColorResources.getPrimary(
                                                context),
                                            width: 1)),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Text(
                                          PriceConverter.convertPrice(
                                                  context, cartModel.discount,
                                                  discountType: 'amount') +
                                              ' OFF',
                                          style: mulishRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color:
                                                  Theme.of(context).hintColor)),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
                        //variation
                        (cartModel.variant != null &&
                                cartModel.variant.isNotEmpty)
                            ? Padding(
                                padding: EdgeInsets.only(
                                    top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                child: Row(children: [
                                  Text(
                                      getTranslated('variant', context) + ': '),
                                  Text(cartModel.variant,
                                      style: mulishRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: ColorResources
                                            .getReviewRattingColor(context),
                                      ))
                                ]),
                              )
                            : SizedBox(),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            cartModel.shippingType != 'order_wise' &&
                                    Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .isLoggedIn()
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        top: Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                    child: Row(children: [
                                      Text(
                                          '${getTranslated('shipping_cost', context)}: ',
                                          style: mulishBold.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeDefault,
                                              color: ColorResources
                                                  .getReviewRattingColor(
                                                      context))),
                                      Text(
                                          '${PriceConverter.convertPrice(context, cartModel.shippingCost)}',
                                          style: mulishRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color:
                                                Theme.of(context).disabledColor,
                                          )),
                                    ]),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
        ],
      ),
    );
  }
}

class QuantityButton extends StatelessWidget {
  final CartModel cartModel;
  final bool isIncrement;
  final int quantity;
  final int index;
  final int maxQty;
  final int minimumOrderQuantity;
  QuantityButton(
      {@required this.isIncrement,
      @required this.quantity,
      @required this.index,
      @required this.maxQty,
      @required this.cartModel,
      this.minimumOrderQuantity});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('--qqq-->$quantity/$minimumOrderQuantity');
        if (!isIncrement && quantity > minimumOrderQuantity) {
          Provider.of<CartProvider>(context, listen: false)
              .updateCartProductQuantity(
                  cartModel.id, cartModel.quantity - 1, context)
              .then((value) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(value.message),
              backgroundColor: value.isSuccess ? Colors.green : Colors.red,
            ));
          });
        } else if (isIncrement && quantity < maxQty) {
          Provider.of<CartProvider>(context, listen: false)
              .updateCartProductQuantity(
                  cartModel.id, cartModel.quantity + 1, context)
              .then((value) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(value.message),
              backgroundColor: value.isSuccess ? Colors.green : Colors.red,
            ));
          });
        }
      },
      child: Icon(
        isIncrement ? Icons.add_circle : Icons.remove_circle,
        color: isIncrement
            ? quantity >= maxQty
                ? ColorResources.getGrey(context)
                : ColorResources.getPrimary(context)
            : quantity > 1
                ? ColorResources.getPrimary(context)
                : ColorResources.getGrey(context),
        size: 30,
      ),
    );
  }
}
