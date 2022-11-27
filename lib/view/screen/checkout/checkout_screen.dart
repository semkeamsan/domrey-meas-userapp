import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/helper/responsive.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/order_place_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/coupon_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/amount_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/my_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/address/saved_address_list_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/cart/cart_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/checkout/widget/custom_check_box.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/payment/payment_screen.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel> cartList;
  final bool fromProductDetails;
  final double totalOrderAmount;
  final double shippingFee;
  final double discount;
  final double tax;
  final int sellerId;

  CheckoutScreen(
      {@required this.cartList,
      this.fromProductDetails = false,
      @required this.discount,
      @required this.tax,
      @required this.totalOrderAmount,
      @required this.shippingFee,
      this.sellerId});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _orderNoteController = TextEditingController();
  final FocusNode _orderNoteNode = FocusNode();
  double _order = 0;
  bool _digitalPayment;
  bool _cod;
  double totalAmount = 0.0;
  // bool _billingAddress;

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false)
        .initAddressList(context);
    Provider.of<OrderProvider>(context, listen: false)
        .initPaymethMethodList(context);
    Provider.of<ProfileProvider>(context, listen: false)
        .initAddressTypeList(context);
    Provider.of<CouponProvider>(context, listen: false).removePrevCouponData();
    Provider.of<CartProvider>(context, listen: false).getCartDataAPI(context);
    Provider.of<CartProvider>(context, listen: false)
        .getChosenShippingMethod(context);
    _digitalPayment = Provider.of<SplashProvider>(context, listen: false)
        .configModel
        .digitalPayment;
    _cod = Provider.of<SplashProvider>(context, listen: false).configModel.cod;
    // _billingAddress = Provider.of<SplashProvider>(context, listen: false)
    //         .configModel
    //         .billingAddress ==
    //     1;
  }

  File _files = File('');
  String image = "";
  ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    _order = widget.totalOrderAmount + widget.discount;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      body: Column(
        children: [
          CustomAppBar(title: getTranslated('checkout', context)),
          Expanded(
            child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(0),
                children: [
                  // Shipping Details
                  Consumer<OrderProvider>(builder: (context, shipping, _) {
                    return Container(
                      padding:
                          EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_DEFAULT),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Text(
                                                '${getTranslated('SHIPPING_TO', context)}',
                                                style: mulishRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault))),
                                        InkWell(
                                          onTap: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      SavedAddressListScreen())),
                                          child: Row(
                                            children: [
                                              Visibility(
                                                  visible:
                                                      Provider.of<OrderProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .addressIndex ==
                                                          null,
                                                  child: Text(getTranslated(
                                                      'add_your_address',
                                                      context))),
                                              Visibility(
                                                  visible:
                                                      Provider.of<OrderProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .addressIndex !=
                                                          null,
                                                  child: Text(getTranslated(
                                                      'change_your_address',
                                                      context))),
                                              Image.asset(
                                                Images.address,
                                                width: 25,
                                                height: 25,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            child: Provider.of<OrderProvider>(
                                                            context,
                                                            listen: false)
                                                        .addressIndex !=
                                                    null
                                                ? Text(
                                                    getTranslated(
                                                        '${Provider.of<ProfileProvider>(context, listen: false).addressList[shipping.addressIndex].addressType}',
                                                        context),
                                                    style: mulishBold.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeLarge),
                                                    maxLines: 3,
                                                    overflow: TextOverflow.fade,
                                                  )
                                                : SizedBox(
                                                    width: 0,
                                                    height: 0,
                                                  )),
                                        Container(
                                            padding: EdgeInsets.only(
                                                top: Dimensions
                                                    .PADDING_SIZE_SMALL),
                                            child: Provider.of<OrderProvider>(
                                                            context,
                                                            listen: false)
                                                        .addressIndex !=
                                                    null
                                                ? Row(
                                                    children: [
                                                      Text(
                                                          getTranslated(
                                                                  'address',
                                                                  context) +
                                                              ': ',
                                                          style: mulishBold),
                                                      Text(
                                                        Provider.of<ProfileProvider>(
                                                                context,
                                                                listen: false)
                                                            .addressList[shipping
                                                                .addressIndex]
                                                            .address,
                                                        style: mulishRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall),
                                                        maxLines: 3,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ],
                                                  )
                                                : SizedBox(
                                                    width: 0,
                                                    height: 0,
                                                  )),
                                        Container(
                                            padding: EdgeInsets.only(
                                                top: Dimensions
                                                    .PADDING_SIZE_SMALL),
                                            child: Provider.of<OrderProvider>(
                                                            context,
                                                            listen: false)
                                                        .addressIndex !=
                                                    null
                                                ? Row(
                                                    children: [
                                                      Text(
                                                          getTranslated('city',
                                                                  context) +
                                                              ': ',
                                                          style: mulishBold),
                                                      Text(
                                                        Provider.of<ProfileProvider>(
                                                                context,
                                                                listen: false)
                                                            .addressList[shipping
                                                                .addressIndex]
                                                            .city,
                                                        style: mulishRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeDefault),
                                                        maxLines: 3,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ],
                                                  )
                                                : SizedBox(
                                                    width: 0,
                                                    height: 0,
                                                  )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Card(
                            //   child: Container(
                            //     padding: EdgeInsets.all(
                            //         Dimensions.PADDING_SIZE_DEFAULT),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(
                            //           Dimensions.PADDING_SIZE_DEFAULT),
                            //       color: Theme.of(context).cardColor,
                            //     ),
                            //     child: Column(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.start,
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Expanded(
                            //                 child: Text(
                            //                     '${getTranslated('shipping_address', context)}',
                            //                     style:
                            //                         mulishRegular.copyWith(
                            //                             fontWeight:
                            //                                 FontWeight.w600))),
                            //             InkWell(
                            //               onTap: () => Navigator.of(context)
                            //                   .push(MaterialPageRoute(
                            //                       builder: (BuildContext
                            //                               context) =>
                            //                           SavedAddressListScreen())),
                            //               child: Image.asset(Images.address,
                            //                   scale: 3),
                            //             ),
                            //           ],
                            //         ),
                            //         SizedBox(
                            //           height: Dimensions.PADDING_SIZE_DEFAULT,
                            //         ),
                            //         Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Container(
                            //               child: Text(
                            //                 Provider.of<OrderProvider>(context,
                            //                                 listen: false)
                            //                             .addressIndex ==
                            //                         null
                            //                     ? '${getTranslated('address_type', context)}'
                            //                     : Provider.of<ProfileProvider>(
                            //                             context,
                            //                             listen: false)
                            //                         .addressList[Provider.of<
                            //                                     OrderProvider>(
                            //                                 context,
                            //                                 listen: false)
                            //                             .addressIndex]
                            //                         .addressType,
                            //                 style: mulishBold.copyWith(
                            //                     fontSize:
                            //                         Dimensions.fontSizeLarge),
                            //                 maxLines: 3,
                            //                 overflow: TextOverflow.fade,
                            //               ),
                            //             ),
                            //             Divider(),
                            //             Container(
                            //               child: Text(
                            //                 Provider.of<OrderProvider>(context,
                            //                                 listen: false)
                            //                             .addressIndex ==
                            //                         null
                            //                     ? getTranslated(
                            //                         'add_your_address', context)
                            //                     : Provider.of<ProfileProvider>(
                            //                             context,
                            //                             listen: false)
                            //                         .addressList[
                            //                             shipping.addressIndex]
                            //                         .address,
                            //                 style: mulishRegular.copyWith(
                            //                     fontSize:
                            //                         Dimensions.fontSizeSmall),
                            //                 maxLines: 3,
                            //                 overflow: TextOverflow.fade,
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: Dimensions.PADDING_SIZE_SMALL,
                            // ),
                            // _billingAddress
                            //     ? Card(
                            //         child: Container(
                            //           padding: EdgeInsets.all(
                            //               Dimensions.PADDING_SIZE_DEFAULT),
                            //           decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(
                            //                 Dimensions.PADDING_SIZE_DEFAULT),
                            //             color: Theme.of(context).cardColor,
                            //           ),
                            //           child: Column(
                            //             crossAxisAlignment:
                            //                 CrossAxisAlignment.start,
                            //             children: [
                            //               Row(
                            //                 mainAxisAlignment:
                            //                     MainAxisAlignment.start,
                            //                 crossAxisAlignment:
                            //                     CrossAxisAlignment.start,
                            //                 children: [
                            //                   Expanded(
                            //                       child: Text(
                            //                           '${getTranslated('billing_address', context)}',
                            //                           style: mulishRegular
                            //                               .copyWith(
                            //                                   fontWeight:
                            //                                       FontWeight
                            //                                           .w600))),
                            //                   InkWell(
                            //                     onTap: () => Navigator.of(
                            //                             context)
                            //                         .push(MaterialPageRoute(
                            //                             builder: (BuildContext
                            //                                     context) =>
                            //                                 SavedBillingAddressListScreen())),
                            //                     child: Image.asset(
                            //                         Images.address,
                            //                         scale: 3),
                            //                   ),
                            //                 ],
                            //               ),
                            //               SizedBox(
                            //                 height:
                            //                     Dimensions.PADDING_SIZE_DEFAULT,
                            //               ),
                            //               Column(
                            //                 crossAxisAlignment:
                            //                     CrossAxisAlignment.start,
                            //                 children: [
                            //                   Container(
                            //                     child: Text(
                            //                       Provider.of<OrderProvider>(
                            //                                       context)
                            //                                   .billingAddressIndex ==
                            //                               null
                            //                           ? '${getTranslated('address_type', context)}'
                            //                           : Provider.of<
                            //                                       ProfileProvider>(
                            //                                   context,
                            //                                   listen: false)
                            //                               .billingAddressList[
                            //                                   Provider.of<OrderProvider>(
                            //                                           context,
                            //                                           listen:
                            //                                               false)
                            //                                       .billingAddressIndex]
                            //                               .addressType,
                            //                       style: mulishBold.copyWith(
                            //                           fontSize: Dimensions
                            //                               .fontSizeLarge),
                            //                       maxLines: 1,
                            //                       overflow: TextOverflow.fade,
                            //                     ),
                            //                   ),
                            //                   Divider(),
                            //                   Container(
                            //                     child: Text(
                            //                       Provider.of<OrderProvider>(
                            //                                       context)
                            //                                   .billingAddressIndex ==
                            //                               null
                            //                           ? getTranslated(
                            //                               'add_your_address',
                            //                               context)
                            //                           : Provider.of<
                            //                                       ProfileProvider>(
                            //                                   context,
                            //                                   listen: false)
                            //                               .billingAddressList[
                            //                                   shipping
                            //                                       .billingAddressIndex]
                            //                               .address,
                            //                       style:
                            //                           mulishRegular.copyWith(
                            //                               fontSize: Dimensions
                            //                                   .fontSizeSmall),
                            //                       maxLines: 3,
                            //                       overflow: TextOverflow.fade,
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       )
                            //     : SizedBox(),
                          ]),
                    );
                  }),
                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                  // Order Details

                  Container(
                    decoration:
                        BoxDecoration(color: Theme.of(context).highlightColor),
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                            vertical: Dimensions.PADDING_SIZE_DEFAULT),
                        child: Visibility(
                          visible:
                              Provider.of<CartProvider>(context, listen: false)
                                      .cartList
                                      .length >
                                  0,
                          child: TitleRow(
                              title: getTranslated('ORDER_DETAILS', context),
                              onTap: () {
                                //Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => CartScreen(
                                              fromCheckout: true,
                                            )));
                              }),
                        ),
                      ),
                      ListView.builder(
                          padding: EdgeInsets.only(top: 0),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              Provider.of<CartProvider>(context, listen: false)
                                  .cartList
                                  .length = 1,
                          itemBuilder: (ctx, index) {
                            return Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_SMALL),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions
                                            .PADDING_SIZE_EXTRA_EXTRA_SMALL),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.PADDING_SIZE_SMALL),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder,
                                      fit: BoxFit.cover,
                                      width: 70,
                                      height: 70,
                                      image:
                                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}'
                                          '/${Provider.of<CartProvider>(context, listen: false).cartList[index].thumbnail}',
                                      imageErrorBuilder: (c, o, s) =>
                                          Image.asset(Images.placeholder,
                                              fit: BoxFit.cover,
                                              width: 70,
                                              height: 70),
                                    ),
                                  ),
                                ),
                                SizedBox(width: Dimensions.MARGIN_SIZE_DEFAULT),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              Provider.of<CartProvider>(context,
                                                      listen: false)
                                                  .cartList[index]
                                                  .name,
                                              style: mulishRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeDefault,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: Dimensions.PADDING_SIZE_SMALL,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              PriceConverter.convertPrice(
                                                  context,
                                                  Provider.of<CartProvider>(
                                                          context,
                                                          listen: false)
                                                      .cartList[index]
                                                      .price),
                                              style: mulishBold.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                  color:
                                                      ColorResources.getPrimary(
                                                          context)),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: Dimensions
                                                      .PADDING_SIZE_EXTRA_LARGE),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Theme.of(context)
                                                      .highlightColor,
                                                  border: Border.all(
                                                      color: ColorResources
                                                          .getPrimary(context),
                                                      width: 1)),
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 3),
                                                child: Text(
                                                    PriceConverter.convertPrice(
                                                            context,
                                                            Provider.of<CartProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .cartList[index]
                                                                .discount) +
                                                        ' OFF',
                                                    style:
                                                        mulishRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall,
                                                            color: Theme.of(
                                                                    context)
                                                                .hintColor)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Row(
                                        //   children: [
                                        //     Expanded(
                                        //       child: Text(
                                        //         Provider.of<CartProvider>(context,
                                        //                 listen: false)
                                        //             .cartList[index]
                                        //             .name,
                                        //         style: mulishRegular.copyWith(
                                        //             fontSize: Dimensions
                                        //                 .fontSizeDefault,
                                        //             color:
                                        //                 ColorResources.getPrimary(
                                        //                     context)),
                                        //         maxLines: 2,
                                        //         overflow: TextOverflow.ellipsis,
                                        //       ),
                                        //     ),
                                        //     SizedBox(
                                        //       width:
                                        //           Dimensions.PADDING_SIZE_SMALL,
                                        //     ),
                                        //     Text(
                                        //       PriceConverter.convertPrice(
                                        //           context,
                                        //           Provider.of<CartProvider>(
                                        //                   context,
                                        //                   listen: false)
                                        //               .cartList[index]
                                        //               .price),
                                        //       style: mulishBold.copyWith(
                                        //           fontSize:
                                        //               Dimensions.fontSizeLarge),
                                        //     ),
                                        //   ],
                                        // ),
                                      ]),
                                ),
                              ],
                            );
                          }),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(children: [
                          Expanded(
                            child: SizedBox(
                              height: Responsive.isMobile(context) ? 40 : 55,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: TextField(
                                    style: mulishRegular.copyWith(
                                      fontSize: Responsive.isMobile(context)
                                          ? Dimensions.fontSizeDefault
                                          : Dimensions.fontSizeDefault,
                                    ),
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      hintText:
                                          // getTranslated('have_coupon', context)
                                          'Have a coupon?',
                                      hintStyle: mulishRegular.copyWith(
                                          fontSize: Responsive.isMobile(context)
                                              ? Dimensions.fontSizeSmall
                                              : Dimensions.fontSizeSmall,
                                          color:
                                              ColorResources.HINT_TEXT_COLOR),
                                      filled: true,
                                      fillColor:
                                          ColorResources.getIconBg(context),
                                      border: InputBorder.none,
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                          !Provider.of<CouponProvider>(context).isLoading
                              ? ElevatedButton(
                                  onPressed: () {
                                    if (_controller.text.isNotEmpty) {
                                      Provider.of<CouponProvider>(context,
                                              listen: false)
                                          .initCoupon(_controller.text, _order)
                                          .then((value) {
                                        if (value > 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                    'You got ${PriceConverter.convertPrice(context, value)} discount',
                                                    style:
                                                        mulishRegular.copyWith(
                                                      fontSize: Responsive
                                                              .isMobile(context)
                                                          ? Dimensions
                                                              .fontSizeDefault
                                                          : Dimensions
                                                              .fontSizeDefault,
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      Colors.green));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                              getTranslated(
                                                  'invalid_coupon_or', context),
                                              style: mulishRegular
                                                  .copyWith(
                                                    fontSize: Responsive
                                                            .isMobile(context)
                                                        ? Dimensions
                                                            .fontSizeDefault
                                                        : Dimensions
                                                            .fontSizeDefault,
                                                  )
                                                  .copyWith(
                                                    fontSize: Responsive
                                                            .isMobile(context)
                                                        ? Dimensions
                                                            .fontSizeDefault
                                                        : Dimensions
                                                            .fontSizeDefault,
                                                  ),
                                            ),
                                            backgroundColor: Colors.red,
                                          ));
                                        }
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: ColorResources.getPrimary(context),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  child: Text(
                                    getTranslated('APPLY', context),
                                    style: mulishRegular.copyWith(
                                      fontSize: Responsive.isMobile(context)
                                          ? Dimensions.fontSizeDefault
                                          : Dimensions.fontSizeDefault,
                                    ),
                                  ),
                                )
                              : CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor)),
                        ]),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.all(
                      //       Dimensions.PADDING_SIZE_DEFAULT),
                      //   child: Container(
                      //     height: 50,
                      //     width: MediaQuery.of(context).size.width,
                      //     decoration: BoxDecoration(
                      //       color: ColorResources.couponColor(context)
                      //           .withOpacity(.5),
                      //       borderRadius: BorderRadius.circular(
                      //           Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      //     ),
                      //     child: Row(children: [
                      //       Expanded(
                      //         child: SizedBox(
                      //           height: 50,
                      //           child: Padding(
                      //             padding: const EdgeInsets.only(
                      //                 left: Dimensions.PADDING_SIZE_SMALL,
                      //                 bottom: 5),
                      //             child: Center(
                      //               child: TextField(
                      //                   controller: _controller,
                      //                   decoration: InputDecoration(
                      //                     hintText: 'Have a coupon?',
                      //                     hintStyle: mulishRegular.copyWith(
                      //                         fontSize:
                      //                             Dimensions.fontSizeDefault),
                      //                     filled: false,
                      //                     fillColor:
                      //                         ColorResources.getIconBg(context),
                      //                     border: InputBorder.none,
                      //                   )),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      //       !Provider.of<CouponProvider>(context).isLoading
                      //           ? InkWell(
                      //               onTap: () {
                      //                 if (_controller.text.isNotEmpty) {
                      //                   Provider.of<CouponProvider>(context,
                      //                           listen: false)
                      //                       .initCoupon(
                      //                           _controller.text, _order)
                      //                       .then((value) {
                      //                     if (value > 0) {
                      //                       ScaffoldMessenger.of(context)
                      //                           .showSnackBar(SnackBar(
                      //                               content: Text(
                      //                                   'You got ${PriceConverter.convertPrice(context, value)} discount'),
                      //                               backgroundColor:
                      //                                   Colors.green));
                      //                     } else {
                      //                       _controller.clear();
                      //                       ScaffoldMessenger.of(context)
                      //                           .showSnackBar(SnackBar(
                      //                         content: Text(getTranslated(
                      //                             'invalid_coupon_or',
                      //                             context)),
                      //                         backgroundColor: Colors.red,
                      //                       ));
                      //                     }
                      //                   });
                      //                 }
                      //               },
                      //               child: Container(
                      //                   width: 100,
                      //                   height: 60,
                      //                   decoration: BoxDecoration(
                      //                       color:
                      //                           Theme.of(context).primaryColor,
                      //                       borderRadius: BorderRadius.only(
                      //                           bottomRight: Radius.circular(
                      //                               Dimensions
                      //                                   .PADDING_SIZE_EXTRA_SMALL),
                      //                           topRight: Radius.circular(Dimensions
                      //                               .PADDING_SIZE_EXTRA_SMALL))),
                      //                   child: Center(
                      //                       child: Text(
                      //                     getTranslated('APPLY', context),
                      //                     style: mulishTitleRegular.copyWith(
                      //                         color:
                      //                             Theme.of(context).cardColor,
                      //                         fontSize:
                      //                             Dimensions.fontSizeLarge),
                      //                   ))),
                      //             )
                      //           : CircularProgressIndicator(
                      //               valueColor: AlwaysStoppedAnimation<Color>(
                      //                   Theme.of(context).primaryColor)),
                      //     ]),
                      //   ),
                      // ),
                    ]),
                  ),
                  // Coupon

                  SizedBox(
                    height: Dimensions.PADDING_SIZE_SMALL,
                  ),

                  // Total bill
                  Container(
                    margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    color: Theme.of(context).highlightColor,
                    child: Consumer<OrderProvider>(
                      builder: (context, order, child) {
                        //_shippingCost = order.shippingIndex != null ? order.shippingList[order.shippingIndex].cost : 0;
                        double _couponDiscount =
                            Provider.of<CouponProvider>(context).discount !=
                                    null
                                ? Provider.of<CouponProvider>(context).discount
                                : 0;

                        totalAmount = (_order +
                            widget.shippingFee -
                            widget.discount -
                            _couponDiscount +
                            widget.tax);

                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleRow(title: getTranslated('total', context)),
                              AmountWidget(
                                  title: getTranslated('ORDER', context) + ':',
                                  amount: PriceConverter.convertPrice(
                                      context, _order)),
                              AmountWidget(
                                  title: getTranslated('SHIPPING_FEE', context),
                                  amount: PriceConverter.convertPrice(
                                      context, widget.shippingFee)),
                              AmountWidget(
                                  title: getTranslated('DISCOUNT', context),
                                  amount: PriceConverter.convertPrice(
                                      context, widget.discount)),
                              AmountWidget(
                                  title:
                                      getTranslated('coupons', context) + ':',
                                  amount: PriceConverter.convertPrice(
                                      context, _couponDiscount)),
                              AmountWidget(
                                  title: getTranslated('TAX', context),
                                  amount: PriceConverter.convertPrice(
                                      context, widget.tax)),
                              Divider(
                                  height: 5,
                                  color: Theme.of(context).hintColor),
                              AmountWidget(
                                  title:
                                      getTranslated('TOTAL_PAYABLE', context),
                                  amount: PriceConverter.convertPrice(
                                      context, totalAmount)),
                            ]);
                      },
                    ),
                  ),

                  // Payment Method
                  Container(
                    margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    color: Theme.of(context).highlightColor,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getTranslated('payment_method', context),
                            style: mulishBold.copyWith(
                                fontSize: Dimensions.fontSizeLarge),
                          ),
                          Column(
                            children: [
                              //Text(getTranslated('payment_method', context), style: mulishBold.copyWith(fontSize: Dimensions.fontSizeLarge),),
                              Consumer<OrderProvider>(
                                  builder: (context, orderProvider, _) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      top: Dimensions.PADDING_SIZE_SMALL),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                        orderProvider.paymentMethodList != null
                                            ? orderProvider
                                                .paymentMethodList.length
                                            : 0,
                                        (index) => Container(
                                          padding: EdgeInsets.only(
                                              top: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(Dimensions
                                                        .PADDING_SIZE_DEFAULT),
                                                border: Border.all(
                                                    color:
                                                        ColorResources.getHint(
                                                            context))),
                                            child: CustomCheckBox(
                                              imageUrl: orderProvider
                                                  .paymentMethodList[index]
                                                  .image,
                                              title: orderProvider
                                                  .paymentMethodList[index]
                                                  .name,
                                              desc:
                                                  '${orderProvider.paymentMethodList[index].accountName}\n${orderProvider.paymentMethodList[index].accountNumber}',
                                              index: index + 1,
                                            ),
                                          ),
                                        ),
                                      )),
                                );
                              }),

                              SizedBox(
                                height: Dimensions.PADDING_SIZE_SMALL,
                              ),
                              _cod
                                  ? Container(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions
                                                    .PADDING_SIZE_DEFAULT),
                                            border: Border.all(
                                                color: ColorResources.getHint(
                                                    context))),
                                        child: CustomCheckBox(
                                          image:
                                              'assets/images/cash_delivery.png',
                                          title: getTranslated(
                                              'cash_on_delivery', context),
                                          desc:
                                              'Pay your payment after getting item',
                                          index: 0,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: Dimensions.PADDING_SIZE_SMALL,
                              ),
                              _digitalPayment
                                  ? Container(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions
                                                    .PADDING_SIZE_DEFAULT),
                                            border: Border.all(
                                                color: ColorResources.getHint(
                                                    context))),
                                        child: CustomCheckBox(
                                          image: 'assets/images/pay_point.png',
                                          title: getTranslated(
                                              'pay_by_wallet', context),
                                          desc: 'Your points must be available',
                                          index: -1,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),

                              Visibility(
                                visible: Provider.of<OrderProvider>(context)
                                        .paymentMethodIndex >
                                    0,
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_SMALL,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: Dimensions.PADDING_SIZE_DEFAULT,
                                      ),
                                      Text(
                                        getTranslated(
                                            'upload_bank_invoice', context),
                                        style: mulishBold.copyWith(
                                            fontSize: Dimensions.fontSizeLarge),
                                      ),
                                      Text(
                                        getTranslated(
                                            'note_you_have_to_pay_first',
                                            context),
                                        style: mulishRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall),
                                      ),
                                      SizedBox(
                                          height:
                                              Dimensions.PADDING_SIZE_DEFAULT),
                                      InkWell(
                                        onTap: () async {
                                          PickedFile pickedFile =
                                              await imagePicker.getImage(
                                            source: ImageSource.gallery,
                                            maxWidth: 1024,
                                            maxHeight: 1024,
                                            imageQuality: 100,
                                          );
                                          if (pickedFile != null) {
                                            _files = File(pickedFile.path);
                                            await Provider.of<OrderProvider>(
                                                    context,
                                                    listen: false)
                                                .uploadImage(_files,
                                                    (String imageResponse) {
                                              image = imageResponse;
                                            });
                                            setState(() {});
                                          }
                                        },
                                        child: _files.path.isEmpty
                                            ? ClipRRect(
                                                borderRadius: BorderRadius
                                                    .circular(Dimensions
                                                        .PADDING_SIZE_SMALL),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Image.asset(
                                                    Images.placeholder_1x1,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            : ClipRRect(
                                                borderRadius: BorderRadius
                                                    .circular(Dimensions
                                                        .PADDING_SIZE_SMALL),
                                                child: CachedNetworkImage(
                                                    imageUrl: image,
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    fit: BoxFit.cover),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                          // _cod? CustomCheckBox(title: getTranslated('cash_on_delivery', context), index: 0):  SizedBox(),
                          // _digitalPayment ? CustomCheckBox(title: getTranslated('digital_payment', context), index: !_cod ? 0 : 1) : SizedBox(),
                        ]),
                  ),

                  // Container(
                  //   margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                  //   padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  //   color: Theme.of(context).highlightColor,
                  //   child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Row(
                  //           children: [
                  //             Text(
                  //               '${getTranslated('order_note', context)}',
                  //               style: mulishRegular.copyWith(
                  //                   fontSize: Dimensions.fontSizeLarge),
                  //             ),
                  //             Text(
                  //               '${getTranslated('extra_inst', context)}',
                  //               style: mulishRegular.copyWith(
                  //                   color: ColorResources.getHint(context)),
                  //             ),
                  //           ],
                  //         ),
                  //         SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  //         CustomTextField(
                  //           hintText: getTranslated('enter_note', context),
                  //           textInputType: TextInputType.multiline,
                  //           textInputAction: TextInputAction.done,
                  //           maxLine: 3,
                  //           focusNode: _orderNoteNode,
                  //           controller: _orderNoteController,
                  //         ),
                  //       ]),
                  // ),
                ]),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: Responsive.isTab() ? 90 : 80,
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_LARGE,
            vertical: Dimensions.PADDING_SIZE_DEFAULT),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Consumer<OrderProvider>(
          builder: (context, order, child) {
            return !Provider.of<OrderProvider>(context).isLoading
                ? Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'nothing',
                              style: mulishBold.copyWith(
                                  color: Theme.of(context).primaryColor),
                            ),
                            Text(
                                PriceConverter.convertPrice(
                                    context,
                                    (_order +
                                        widget.shippingFee -
                                        widget.discount +
                                        widget.tax)),
                                style: mulishBold.copyWith(
                                    color: Theme.of(context).highlightColor,
                                    fontSize: Dimensions.fontSizeExtraLarge)),
                            Builder(
                              builder: (context) => InkWell(
                                onTap: () async {
                                  if (Provider.of<OrderProvider>(context,
                                              listen: false)
                                          .addressIndex ==
                                      null) {
                                    showCustomSnackBar(
                                        getTranslated(
                                            'select_a_shipping_address',
                                            context),
                                        context);
                                  } else {
                                    List<CartModel> _cartList = [];
                                    _cartList.addAll(widget.cartList);

                                    for (int index = 0;
                                        index < widget.cartList.length;
                                        index++) {
                                      for (int i = 0;
                                          i <
                                              Provider.of<CartProvider>(context,
                                                      listen: false)
                                                  .chosenShippingList
                                                  .length;
                                          i++) {
                                        if (Provider.of<CartProvider>(context,
                                                    listen: false)
                                                .chosenShippingList[i]
                                                .cartGroupId ==
                                            widget
                                                .cartList[index].cartGroupId) {
                                          _cartList[index].shippingMethodId =
                                              Provider.of<CartProvider>(context,
                                                      listen: false)
                                                  .chosenShippingList[i]
                                                  .id;
                                          break;
                                        }
                                      }
                                    }

                                    String orderNote =
                                        _orderNoteController.text.trim();
                                    double couponDiscount =
                                        Provider.of<CouponProvider>(context,
                                                        listen: false)
                                                    .discount !=
                                                null
                                            ? Provider.of<CouponProvider>(
                                                    context,
                                                    listen: false)
                                                .discount
                                            : 0;
                                    String couponCode =
                                        Provider.of<CouponProvider>(
                                                            context,
                                                            listen: false)
                                                        .discount !=
                                                    null &&
                                                Provider.of<CouponProvider>(
                                                            context,
                                                            listen: false)
                                                        .discount !=
                                                    0
                                            ? Provider.of<CouponProvider>(
                                                    context,
                                                    listen: false)
                                                .coupon
                                                .code
                                            : '';
                                    if (_cod &&
                                        Provider.of<OrderProvider>(context,
                                                    listen: false)
                                                .paymentMethodIndex ==
                                            0) {
                                      Provider.of<OrderProvider>(context,
                                              listen: false)
                                          .placeOrder(
                                              OrderPlaceModel(
                                                CustomerInfo(
                                                    Provider.of<ProfileProvider>(
                                                            context,
                                                            listen: false)
                                                        .addressList[Provider
                                                                .of<OrderProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                            .addressIndex]
                                                        .id
                                                        .toString(),
                                                    Provider.of<ProfileProvider>(
                                                            context,
                                                            listen: false)
                                                        .addressList[Provider
                                                                .of<OrderProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                            .addressIndex]
                                                        .address,
                                                    orderNote),
                                                _cartList,
                                                'cash_on_delivery',
                                                couponDiscount,
                                                null,
                                                null,
                                              ),
                                              _callback,
                                              _cartList,
                                              Provider.of<ProfileProvider>(
                                                      context,
                                                      listen: false)
                                                  .addressList[Provider.of<
                                                              OrderProvider>(
                                                          context,
                                                          listen: false)
                                                      .addressIndex]
                                                  .id
                                                  .toString(),
                                              couponCode,
                                              orderNote);
                                    } else if (Provider.of<OrderProvider>(
                                                context,
                                                listen: false)
                                            .paymentMethodIndex ==
                                        -1) {
                                      if (Provider.of<ProfileProvider>(context,
                                                      listen: false)
                                                  .userInfoModel
                                                  .walletBalance !=
                                              null &&
                                          Provider.of<ProfileProvider>(context,
                                                      listen: false)
                                                  .userInfoModel
                                                  .walletBalance >=
                                              totalAmount) {
                                        Provider.of<OrderProvider>(context,
                                                listen: false)
                                            .placeOrder(
                                                OrderPlaceModel(
                                                  CustomerInfo(
                                                      Provider.of<ProfileProvider>(
                                                              context,
                                                              listen: false)
                                                          .addressList[Provider
                                                                  .of<OrderProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .addressIndex]
                                                          .id
                                                          .toString(),
                                                      Provider.of<ProfileProvider>(
                                                              context,
                                                              listen: false)
                                                          .addressList[Provider
                                                                  .of<OrderProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .addressIndex]
                                                          .address,
                                                      orderNote),
                                                  _cartList,
                                                  'pay_by_wallet',
                                                  couponDiscount,
                                                  null,
                                                  null,
                                                ),
                                                _callback,
                                                _cartList,
                                                Provider.of<ProfileProvider>(
                                                        context,
                                                        listen: false)
                                                    .addressList[Provider.of<
                                                                OrderProvider>(
                                                            context,
                                                            listen: false)
                                                        .addressIndex]
                                                    .id
                                                    .toString(),
                                                couponCode,
                                                orderNote);
                                      } else {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'your_wallet_not_enough_to_orders',
                                                context),
                                            context);
                                      }
                                    } else if (Provider.of<OrderProvider>(
                                                context,
                                                listen: false)
                                            .paymentMethodIndex >
                                        0) {
                                      if (image != null && image.isNotEmpty) {
                                        Provider.of<OrderProvider>(context, listen: false).placeOrder(
                                            OrderPlaceModel(
                                                CustomerInfo(
                                                    Provider.of<ProfileProvider>(
                                                            context,
                                                            listen: false)
                                                        .addressList[Provider.of<OrderProvider>(
                                                                context,
                                                                listen: false)
                                                            .addressIndex]
                                                        .id
                                                        .toString(),
                                                    Provider.of<ProfileProvider>(
                                                            context,
                                                            listen: false)
                                                        .addressList[
                                                            Provider.of<OrderProvider>(
                                                                    context,
                                                                    listen: false)
                                                                .addressIndex]
                                                        .address,
                                                    orderNote),
                                                _cartList,
                                                order.paymentMethodList[order.paymentMethodIndex - 1].name,
                                                couponDiscount,
                                                image,
                                                order.paymentMethodList[order.paymentMethodIndex - 1].id),
                                            _callback,
                                            _cartList,
                                            Provider.of<ProfileProvider>(context, listen: false).addressList[Provider.of<OrderProvider>(context, listen: false).addressIndex].id.toString(),
                                            couponCode,
                                            orderNote);
                                      } else {
                                        showCustomSnackBar(
                                            getTranslated(
                                                'please_upload_payment_image',
                                                context),
                                            context);
                                      }
                                    } else {
                                      String userID =
                                          await Provider.of<ProfileProvider>(
                                                  context,
                                                  listen: false)
                                              .getUserInfo(context);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => PaymentScreen(
                                            customerID: userID,
                                            addressID: Provider.of<
                                                        ProfileProvider>(
                                                    context,
                                                    listen: false)
                                                .addressList[
                                                    Provider.of<OrderProvider>(
                                                            context,
                                                            listen: false)
                                                        .addressIndex]
                                                .id
                                                .toString(),
                                            couponCode: Provider.of<
                                                                CouponProvider>(
                                                            context,
                                                            listen: false)
                                                        .discount !=
                                                    null
                                                ? Provider.of<CouponProvider>(
                                                        context,
                                                        listen: false)
                                                    .coupon
                                                    .code
                                                : '',
                                            // billingId: _billingAddress
                                            //     ? Provider.of<ProfileProvider>(
                                            //             context,
                                            //             listen: false)
                                            //         .billingAddressList[
                                            //             Provider.of<OrderProvider>(
                                            //                     context,
                                            //                     listen:
                                            //                         false)
                                            //                 .billingAddressIndex]
                                            //         .id
                                            //         .toString()
                                            //     : Provider.of<ProfileProvider>(
                                            //             context,
                                            //             listen: false)
                                            //         .addressList[Provider.of<
                                            //                     OrderProvider>(
                                            //                 context,
                                            //                 listen: false)
                                            //             .addressIndex]
                                            //         .id
                                            //         .toString(),
                                            orderNote: orderNote,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.PADDING_SIZE_SMALL,
                                      horizontal:
                                          Dimensions.PADDING_SIZE_SMALL),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.PADDING_SIZE_SMALL),
                                      color: Theme.of(context).highlightColor),
                                  child: Center(
                                    child: Text(
                                        getTranslated('proceed', context),
                                        style: mulishBold.copyWith(
                                          fontSize: Dimensions.fontSizeLarge,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.centerRight,
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).highlightColor)),
                  );
          },
        ),
      ),
    );
  }

  void _callback(bool isSuccess, String message, String orderID,
      List<CartModel> carts) async {
    if (isSuccess) {
      Provider.of<ProductProvider>(context, listen: false).getLatestProductList(
        1,
        context,
        reload: true,
      );
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => DashBoardScreen()),
          (route) => false);
      showAnimatedDialog(
          context,
          MyDialog(
            icon: Icons.check,
            title: getTranslated('order_placed', context),
            description: getTranslated('your_order_placed', context),
            isFailed: false,
          ),
          dismissible: false,
          isFlip: true);
      Provider.of<OrderProvider>(context, listen: false).stopLoader();
    } else {
      showCustomSnackBar(message, context);
    }
  }
}

class PaymentButton extends StatelessWidget {
  final String image;
  final Function onTap;
  PaymentButton({@required this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        margin: EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: ColorResources.getGrey(context)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(image),
      ),
    );
  }
}
