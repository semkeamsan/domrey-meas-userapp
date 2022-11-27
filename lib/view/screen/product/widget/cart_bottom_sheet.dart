import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/helper/responsive.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/seller_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/cart/cart_screen.dart';
import 'package:provider/provider.dart';

class CartBottomSheet extends StatefulWidget {
  final Product product;
  final Function callback;
  CartBottomSheet({@required this.product, this.callback});

  @override
  _CartBottomSheetState createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  route(bool isRoute, String message) async {
    if (isRoute) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green));
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }

  @override
  void initState() {
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .initData(widget.product, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          ),
          child: Consumer<ProductDetailsProvider>(
            builder: (ctx, details, child) {
              Variation _variation;
              String _variantName = widget.product.colors.length != 0
                  ? widget.product.colors[details.variantIndex].name
                  : null;
              List<String> _variationList = [];
              for (int index = 0;
                  index < widget.product.choiceOptions.length;
                  index++) {
                _variationList.add(widget.product.choiceOptions[index]
                    .options[details.variationIndex[index]]
                    .trim());
              }
              String variationType = '';
              if (_variantName != null) {
                variationType = _variantName;
                _variationList.forEach(
                    (variation) => variationType = '$variationType-$variation');
              } else {
                bool isFirst = true;
                _variationList.forEach((variation) {
                  if (isFirst) {
                    variationType = '$variationType$variation';
                    isFirst = false;
                  } else {
                    variationType = '$variationType-$variation';
                  }
                });
              }
              double price = widget.product.unitPrice;
              int _stock = widget.product.currentStock;
              variationType = variationType.replaceAll(' ', '');
              for (Variation variation in widget.product.variation) {
                if (variation.type == variationType) {
                  price = variation.price;
                  _variation = variation;
                  _stock = variation.qty;
                  break;
                }
              }
              double priceWithDiscount = PriceConverter.convertWithDiscount(
                  context,
                  price,
                  widget.product.discount,
                  widget.product.discountType);
              double priceWithQuantity = priceWithDiscount * details.quantity;
              String ratting = widget.product.rating != null &&
                      widget.product.rating.length != 0
                  ? widget.product.rating[0].average
                  : "0";

              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Close Button
                    Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
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
                                    blurRadius: 5,
                                  )
                                ]),
                            child: Icon(Icons.clear,
                                size: Dimensions.iconSizeMedium),
                          ),
                        )),

                    // Product details
                    Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: ColorResources.getImageBg(context),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        width: .5,
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(.20))),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: Images.placeholder,
                                    image:
                                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${widget.product.thumbnail}',
                                    imageErrorBuilder: (c, o, s) =>
                                        Image.asset(Images.placeholder),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(widget.product.name ?? '',
                                                style: mulishRegular.copyWith(
                                                  fontSize: Responsive.isMobile(
                                                          context)
                                                      ? Dimensions.fontSizeLarge
                                                      : Dimensions
                                                          .fontSizeDefault,
                                                ),
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  PriceConverter.convertPrice(
                                                      context,
                                                      widget.product.unitPrice,
                                                      discountType: widget
                                                          .product.discountType,
                                                      discount: widget
                                                          .product.discount),
                                                  style: mulishBold.copyWith(
                                                    color: ColorResources
                                                        .getPrimary(context),
                                                    fontSize: Responsive
                                                            .isMobile(context)
                                                        ? Dimensions
                                                            .fontSizeLarge
                                                        : Dimensions
                                                            .fontSizeDefault,
                                                  ),
                                                ),
                                                Spacer(),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 1),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: Theme.of(context)
                                                          .highlightColor,
                                                      border: Border.all(
                                                          color: ColorResources
                                                              .getPrimary(
                                                                  context),
                                                          width: 1)),
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                    child: Text(
                                                        '${widget.product.discount}' +
                                                            '%' +
                                                            ' ' +
                                                            'OFF',
                                                        style: mulishRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .hintColor)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            widget.product.discount > 0
                                                ? Text(
                                                    PriceConverter.convertPrice(
                                                        context,
                                                        widget
                                                            .product.unitPrice),
                                                    style:
                                                        mulishRegular.copyWith(
                                                      color: Theme.of(context)
                                                          .hintColor,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      fontSize: Responsive
                                                              .isMobile(context)
                                                          ? Dimensions
                                                              .fontSizeDefault
                                                          : Dimensions
                                                              .fontSizeDefault,
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ]),
                                    ]),
                              ),
                            ]),
                      ],
                    ),

                    Row(children: [
                      Text(getTranslated('quantity', context),
                          style: mulishBold.copyWith(
                            fontSize: Responsive.isMobile(context)
                                ? Dimensions.fontSizeDefault
                                : Dimensions.fontSizeDefault,
                          )),
                      QuantityButton(
                          isIncrement: false,
                          quantity: details.quantity,
                          stock: _stock),
                      Text(details.quantity.toString(),
                          style: mulishRegular.copyWith(
                            fontSize: Responsive.isMobile(context)
                                ? Dimensions.fontSizeDefault
                                : Dimensions.fontSizeDefault,
                          )),
                      QuantityButton(
                          isIncrement: true,
                          quantity: details.quantity,
                          stock: _stock),
                    ]),

                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    // Variant
                    widget.product.colors.length > 0
                        ? Row(children: [
                            Text(
                                '${getTranslated('select_variant', context)} : ',
                                style: mulishBold.copyWith(
                                    fontSize: Dimensions.fontSizeDefault)),
                            SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                            SizedBox(
                              height: 40,
                              child: ListView.builder(
                                itemCount: widget.product.colors.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, index) {
                                  String colorString = '0xff' +
                                      widget.product.colors[index].code
                                          .substring(1, 7);
                                  return InkWell(
                                    onTap: () {
                                      Provider.of<ProductDetailsProvider>(
                                              context,
                                              listen: false)
                                          .setCartVariantIndex(
                                              widget.product, index, context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                          border: details.variantIndex == index
                                              ? Border.all(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .primaryColor)
                                              : null),
                                      child: Padding(
                                        padding: const EdgeInsets.all(Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                        child: Container(
                                          height: Dimensions.topSpace,
                                          width: Dimensions.topSpace,
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
                                    ),
                                  );
                                },
                              ),
                            ),
                          ])
                        : SizedBox(),
                    widget.product.colors.length > 0
                        ? SizedBox(height: Dimensions.PADDING_SIZE_SMALL)
                        : SizedBox(),

                    // Variation
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.product.choiceOptions.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  '${getTranslated('available', context)} ' +
                                      ' ' +
                                      '${widget.product.choiceOptions[index].title} : ',
                                  style: mulishRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault)),
                              SizedBox(
                                  width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                      childAspectRatio: (1 / .7),
                                    ),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: widget.product
                                        .choiceOptions[index].options.length,
                                    itemBuilder: (ctx, i) {
                                      return InkWell(
                                        onTap: () =>
                                            Provider.of<ProductDetailsProvider>(
                                                    context,
                                                    listen: false)
                                                .setCartVariationIndex(
                                                    widget.product,
                                                    index,
                                                    i,
                                                    context),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border:
                                                details.variationIndex[index] !=
                                                        i
                                                    ? null
                                                    : Border.all(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                          ),
                                          child: Center(
                                            child: Text(
                                                widget
                                                    .product
                                                    .choiceOptions[index]
                                                    .options[i]
                                                    .trim(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: mulishRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeDefault,
                                                  color: details.variationIndex[
                                                              index] !=
                                                          i
                                                      ? ColorResources
                                                          .getTextTitle(context)
                                                      : Theme.of(context)
                                                          .primaryColor,
                                                )),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ]);
                      },
                    ),
                    SizedBox(
                      height: Dimensions.PADDING_SIZE_SMALL,
                    ),

                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Text(getTranslated('total_price', context),
                          style: mulishBold),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Text(
                        PriceConverter.convertPrice(context, priceWithQuantity),
                        style: mulishBold.copyWith(
                            color: ColorResources.getPrimary(context),
                            fontSize: Dimensions.fontSizeLarge),
                      ),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Provider.of<CartProvider>(context).isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor,
                                  ),
                                ),
                              )
                            : Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: Dimensions.PADDING_SIZE_DEFAULT),
                                  child: CustomButton(
                                      buttonText: getTranslated(
                                          _stock <
                                                  widget.product
                                                      .minimumOrderQuantity
                                              ? 'out_of_stock'
                                              : 'add_to_cart',
                                          context),
                                      onTap: _stock <
                                              widget
                                                  .product.minimumOrderQuantity
                                          ? null
                                          : () {
                                              if (_stock >=
                                                  widget.product
                                                      .minimumOrderQuantity) {
                                                CartModel cart = CartModel(
                                                    widget.product.id,
                                                    widget.product.thumbnail,
                                                    widget.product.name,
                                                    widget.product.addedBy ==
                                                            'seller'
                                                        ? '${Provider.of<SellerProvider>(context, listen: false).sellerModel.seller.fName} '
                                                            '${Provider.of<SellerProvider>(context, listen: false).sellerModel.seller.lName}'
                                                        : 'admin',
                                                    price,
                                                    priceWithDiscount,
                                                    details.quantity,
                                                    _stock,
                                                    widget.product.colors.length >
                                                            0
                                                        ? widget
                                                            .product
                                                            .colors[details
                                                                .variantIndex]
                                                            .name
                                                        : '',
                                                    widget.product.colors
                                                                .length >
                                                            0
                                                        ? widget
                                                            .product
                                                            .colors[details
                                                                .variantIndex]
                                                            .code
                                                        : '',
                                                    _variation,
                                                    widget.product.discount,
                                                    widget.product.discountType,
                                                    widget.product.tax,
                                                    widget.product.taxType,
                                                    1,
                                                    '',
                                                    widget.product.userId,
                                                    '',
                                                    '',
                                                    '',
                                                    widget
                                                        .product.choiceOptions,
                                                    Provider.of<ProductDetailsProvider>(
                                                            context,
                                                            listen: false)
                                                        .variationIndex,
                                                    widget.product.isMultiPly ==
                                                            1
                                                        ? widget.product
                                                                .shippingCost *
                                                            details.quantity
                                                        : widget.product
                                                                .shippingCost ??
                                                            0,
                                                    widget.product
                                                        .minimumOrderQuantity);

                                                // cart.variations = _variation;
                                                if (Provider.of<AuthProvider>(
                                                        context,
                                                        listen: false)
                                                    .isLoggedIn()) {
                                                  Provider.of<CartProvider>(
                                                          context,
                                                          listen: false)
                                                      .addToCartAPI(
                                                    cart,
                                                    route,
                                                    context,
                                                    widget
                                                        .product.choiceOptions,
                                                    Provider.of<ProductDetailsProvider>(
                                                            context,
                                                            listen: false)
                                                        .variationIndex,
                                                  );
                                                } else {
                                                  Provider.of<CartProvider>(
                                                          context,
                                                          listen: false)
                                                      .addToCart(cart);
                                                  Navigator.pop(context);
                                                  showCustomSnackBar(
                                                      getTranslated(
                                                          'added_to_cart',
                                                          context),
                                                      context,
                                                      isError: false);
                                                }
                                              }
                                            }),
                                ),
                              ),
                      ],
                    ),
                  ]);
            },
          ),
        ),
      ],
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CartScreen()));
  }
}

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final int quantity;
  final bool isCartWidget;
  final int stock;
  QuantityButton({
    @required this.isIncrement,
    @required this.quantity,
    @required this.stock,
    this.isCartWidget = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (!isIncrement && quantity > 1) {
          Provider.of<ProductDetailsProvider>(context, listen: false)
              .setQuantity(quantity - 1);
        } else if (isIncrement && quantity < stock) {
          Provider.of<ProductDetailsProvider>(context, listen: false)
              .setQuantity(quantity + 1);
        }
      },
      icon: Icon(
        isIncrement ? Icons.add_circle_sharp : Icons.remove_circle,
        color: isIncrement
            ? quantity >= stock
                ? ColorResources.getLowGreen(context)
                : ColorResources.getPrimary(context)
            : quantity > 1
                ? ColorResources.getPrimary(context)
                : ColorResources.getLowGreen(context),
        size: Responsive.isMobile(context)
            ? Dimensions.iconSizeDefault
            : Dimensions.iconSizeDefault,
      ),
    );
  }
}
