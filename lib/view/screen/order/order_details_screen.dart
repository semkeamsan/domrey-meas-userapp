import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/provider/localization_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button_outline.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/shimmer_loading.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/chat_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/payment_image_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/seller/seller_screen.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/order_details.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/order_model.dart';

import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/seller_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/amount_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/widget/order_details_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/payment/payment_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/support/support_ticket_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/tracking/tracking_screen.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatelessWidget {
  final bool isNotification;
  final OrderModel orderModel;
  final int orderId;
  final String orderType;
  final double extraDiscount;
  final String extraDiscountType;
  OrderDetailsScreen(
      {@required this.orderModel,
      @required this.orderId,
      @required this.orderType,
      this.extraDiscount,
      this.extraDiscountType,
      this.isNotification = false});

  void _loadData(BuildContext context) async {
    await Provider.of<OrderProvider>(context, listen: false)
        .initTrackingInfo(orderId.toString(), orderModel, true, context);
    if (orderModel == null) {
      await Provider.of<SplashProvider>(context, listen: false)
          .initConfig(context);
    }
    Provider.of<SellerProvider>(context, listen: false).removePrevOrderSeller();
    await Provider.of<ProfileProvider>(context, listen: false)
        .initAddressList(context);
    if (Provider.of<SplashProvider>(context, listen: false)
            .configModel
            .shippingMethod ==
        'sellerwise_shipping') {
      await Provider.of<OrderProvider>(context, listen: false).initShippingList(
          context,
          Provider.of<OrderProvider>(context, listen: false)
              .trackingModel
              .sellerId);
    } else {
      await Provider.of<OrderProvider>(context, listen: false)
          .initShippingList(context, 1);
    }
    Provider.of<OrderProvider>(context, listen: false).getOrderDetails(
      orderId.toString(),
      context,
      Provider.of<LocalizationProvider>(context, listen: false)
          .locale
          .countryCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    _loadData(context);
    return WillPopScope(
      onWillPop: () async {
        isNotification
            ? Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => DashBoardScreen()))
            : Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorResources.getIconBg(context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(title: getTranslated('ORDER_DETAILS', context)),
            Expanded(
              child: Consumer<OrderProvider>(
                builder: (context, order, child) {
                  List<int> sellerList = [];
                  List<List<OrderDetailsModel>> sellerProductList = [];
                  double _order = 0;
                  double _discount = 0;
                  double eeDiscount = 0;
                  double _tax = 0;
                  // ignore: unused_local_variable
                  String shippingPartner = '';
                  // ignore: unused_local_variable
                  double _shippingFee = 0;

                  if (order.orderDetails != null) {
                    order.orderDetails.forEach((orderDetails) {
                      if (!sellerList
                          .contains(orderDetails.productDetails.userId)) {
                        sellerList.add(orderDetails.productDetails.userId);
                      }
                    });
                    sellerList.forEach((seller) {
                      Provider.of<SellerProvider>(context, listen: false)
                          .initSeller(seller.toString(), context);
                      List<OrderDetailsModel> orderList = [];
                      order.orderDetails.forEach((orderDetails) {
                        if (seller == orderDetails.productDetails.userId) {
                          orderList.add(orderDetails);
                        }
                      });
                      sellerProductList.add(orderList);
                    });

                    order.orderDetails.forEach((orderDetails) {
                      _order = _order + (orderDetails.price * orderDetails.qty);
                      _discount = _discount + orderDetails.discount;
                      _tax = _tax + orderDetails.tax;
                    });

                    if (orderType == 'POS') {
                      if (extraDiscountType == 'percent') {
                        eeDiscount = _order * (extraDiscount / 100);
                      } else {
                        eeDiscount = extraDiscount;
                      }
                    }

                    if (order.shippingList != null) {
                      order.shippingList.forEach((shipping) {
                        if (shipping.id ==
                            order.trackingModel.shippingMethodId) {
                          shippingPartner = shipping.title;
                          _shippingFee = shipping.cost;
                        }
                      });
                    }
                  }

                  return order.orderDetails != null
                      ? ListView(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.all(0),
                          children: [
                            SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: Dimensions.PADDING_SIZE_DEFAULT,
                                  horizontal: Dimensions.PADDING_SIZE_SMALL),
                              child: Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: getTranslated(
                                                    'ORDER_ID', context) +
                                                ' ',
                                            style: mulishRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeDefault,
                                                color: ColorResources
                                                    .getSecondaryText(
                                                        context))),
                                        TextSpan(
                                            text: order.trackingModel.id
                                                .toString(),
                                            style: mulishRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeDefault,
                                                color:
                                                    ColorResources.getPrimary(
                                                        context))),
                                      ],
                                    ),
                                  ),
                                  Expanded(child: SizedBox()),
                                  Text(
                                      DateConverter.localDateToIsoStringAMPM(
                                          DateTime.parse(
                                              order.trackingModel.createdAt)),
                                      style: mulishRegular.copyWith(
                                          color:
                                              ColorResources.getHint(context),
                                          fontSize: Dimensions.fontSizeSmall)),
                                ],
                              ),
                            ),

                            Container(
                              padding:
                                  EdgeInsets.all(Dimensions.MARGIN_SIZE_SMALL),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).highlightColor),
                              child: Column(
                                children: [
                                  orderType == 'POS'
                                      ? Text(
                                          getTranslated('pos_order', context))
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                              Expanded(
                                                child: Text(
                                                    '${getTranslated('SHIPPING_TO', context)} : ',
                                                    style: mulishRegular.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeDefault)),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 1),
                                                child: Text(
                                                    ' ${orderModel != null && orderModel.shippingAddressData != null ? orderModel.shippingAddressData.address : ''}',
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        mulishRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall)),
                                              ),
                                              Image.asset(
                                                Images.address,
                                                width: 25,
                                                height: 25,
                                              )
                                            ]),
                                  // SizedBox(
                                  //     height: Dimensions.PADDING_SIZE_LARGE),
                                  // orderModel != null &&
                                  //         orderModel.billingAddressData != null
                                  //     ? Row(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.start,
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //         children: [
                                  //           Text(
                                  //               '${getTranslated('billing_address', context)} :',
                                  //               style: mulishRegular.copyWith(
                                  //                   fontSize: Dimensions
                                  //                       .fontSizeDefault)),
                                  //           Expanded(
                                  //               child: Padding(
                                  //             padding:
                                  //                 const EdgeInsets.symmetric(
                                  //                     vertical: 1),
                                  //             child: Text(
                                  //                 ' ${orderModel.billingAddressData != null ? orderModel.billingAddressData.address : ''}',
                                  //                 maxLines: 3,
                                  //                 overflow:
                                  //                     TextOverflow.ellipsis,
                                  //                 style:
                                  //                     mulishRegular.copyWith(
                                  //                         fontSize: Dimensions
                                  //                             .fontSizeSmall)),
                                  //           )),
                                  //         ],
                                  //       )
                                  //     : SizedBox(),
                                  Divider(),
                                  orderModel != null &&
                                          orderModel.shippingAddressData != null
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  '${getTranslated('SHIPPING_PARTNER', context)} :',
                                                  style: mulishRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeDefault)),
                                            ),
                                            Text(' ${shippingPartner}',
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: mulishRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeDefault,
                                                    color: ColorResources
                                                        .getPrimary(context))),
                                          ],
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),

                            orderModel != null && orderModel.orderNote != null
                                ? Padding(
                                    padding: EdgeInsets.all(
                                        Dimensions.MARGIN_SIZE_SMALL),
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                              text:
                                                  '${getTranslated('order_note', context)} : ',
                                              style: mulishBold.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeLarge,
                                                  color: ColorResources
                                                      .getReviewRattingColor(
                                                          context))),
                                          TextSpan(
                                              text:
                                                  '${orderModel.orderNote != null ? orderModel.orderNote ?? '' : ""}',
                                              style: mulishRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeSmall)),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                                  vertical: Dimensions.PADDING_SIZE_DEFAULT),
                              child: Text(
                                  getTranslated('ORDERED_PRODUCT', context),
                                  style: mulishRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault)),
                            ),

                            ListView.builder(
                              itemCount: sellerList.length,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                                  color: Theme.of(context).highlightColor,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (Provider.of<SellerProvider>(
                                                            context,
                                                            listen: false)
                                                        .orderSellerList
                                                        .length !=
                                                    0 &&
                                                sellerList[index] != 1) {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (_) {
                                                return SellerScreen(
                                                    seller: Provider.of<
                                                                SellerProvider>(
                                                            context,
                                                            listen: false)
                                                        .orderSellerList[index]);
                                              }));
                                            }
                                          },
                                          child: sellerList[index] == 1
                                              ? SizedBox()
                                              : InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) => ChatScreen(
                                                                seller:
                                                                    Provider.of<SellerProvider>(context).orderSellerList[
                                                                        index],
                                                                shopId: Provider.of<SellerProvider>(
                                                                        context)
                                                                    .orderSellerList[
                                                                        index]
                                                                    .seller
                                                                    .shop
                                                                    .id,
                                                                shopName: Provider.of<SellerProvider>(
                                                                        context)
                                                                    .orderSellerList[
                                                                        index]
                                                                    .seller
                                                                    .shop
                                                                    .name,
                                                                image: Provider.of<SellerProvider>(
                                                                        context)
                                                                    .orderSellerList[index]
                                                                    .seller
                                                                    .image)));
                                                  },
                                                  child: Row(children: [
                                                    Expanded(
                                                        child: Text(
                                                            getTranslated(
                                                                'seller',
                                                                context),
                                                            style: mulishBold)),
                                                    Text(
                                                      sellerList[index] == 1
                                                          ? 'Admin'
                                                          : Provider.of<SellerProvider>(
                                                                          context)
                                                                      .orderSellerList
                                                                      .length <
                                                                  index + 1
                                                              ? sellerList[
                                                                      index]
                                                                  .toString()
                                                              : '${Provider.of<SellerProvider>(context).orderSellerList[index].seller.fName} '
                                                                  '${Provider.of<SellerProvider>(context).orderSellerList[index].seller.lName}',
                                                      style: mulishRegular.copyWith(
                                                          color: ColorResources
                                                              .getSecondaryText(
                                                                  context)),
                                                    ),
                                                    SizedBox(
                                                        width: Dimensions
                                                            .PADDING_SIZE_EXTRA_SMALL),
                                                    Icon(Icons.chat,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        size: 20),
                                                  ]),
                                                ),
                                        ),
                                        Divider(),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.all(0),
                                          itemCount:
                                              sellerProductList[index].length,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, i) =>
                                              OrderDetailsWidget(
                                            orderDetailsModel:
                                                sellerProductList[index][i],
                                            callback: () {
                                              showCustomSnackBar(
                                                  'Review submitted successfully',
                                                  context,
                                                  isError: false);
                                            },
                                            orderType: orderType,
                                          ),
                                        ),
                                      ]),
                                );
                              },
                            ),
                            SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),

                            // Amounts
                            Container(
                              padding:
                                  EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              color: Theme.of(context).highlightColor,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TitleRow(
                                        title: getTranslated('TOTAL', context)),
                                    AmountWidget(
                                        title: getTranslated('ORDER', context),
                                        amount: PriceConverter.convertPrice(
                                            context, _order)),
                                    orderType == "POS"
                                        ? SizedBox()
                                        : AmountWidget(
                                            title: getTranslated(
                                                'SHIPPING_FEE', context),
                                            amount: PriceConverter.convertPrice(
                                                context,
                                                order.trackingModel
                                                    .shippingCost)),
                                    AmountWidget(
                                        title:
                                            getTranslated('DISCOUNT', context),
                                        amount: PriceConverter.convertPrice(
                                            context, _discount)),
                                    orderType == "POS"
                                        ? AmountWidget(
                                            title: getTranslated(
                                                'EXTRA_DISCOUNT', context),
                                            amount: PriceConverter.convertPrice(
                                                context, eeDiscount))
                                        : SizedBox(),
                                    AmountWidget(
                                      title: getTranslated(
                                          'coupon_voucher', context),
                                      amount: PriceConverter.convertPrice(
                                          context,
                                          order.trackingModel.discountAmount),
                                    ),
                                    AmountWidget(
                                        title: getTranslated('TAX', context),
                                        amount: PriceConverter.convertPrice(
                                            context, _tax)),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      child: Divider(
                                          height: 2,
                                          color:
                                              ColorResources.HINT_TEXT_COLOR),
                                    ),
                                    AmountWidget(
                                      title: getTranslated(
                                          'TOTAL_PAYABLE', context),
                                      amount: PriceConverter.convertPrice(
                                          context,
                                          (_order +
                                              order.trackingModel.shippingCost -
                                              eeDiscount -
                                              order.trackingModel
                                                  .discountAmount -
                                              _discount +
                                              _tax)),
                                    ),
                                  ]),
                            ),
                            SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),

                            order.trackingModel.deliveryMan != null
                                ? Container(
                                    padding: EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_SMALL),
                                    decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).highlightColor),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${getTranslated('shipping_info', context)}',
                                              style: mulishBold),
                                          SizedBox(
                                              height: Dimensions
                                                  .MARGIN_SIZE_EXTRA_SMALL),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    '${getTranslated('delivery_man', context)} : ',
                                                    style:
                                                        mulishRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall)),
                                                Text(
                                                  (order.trackingModel
                                                              .deliveryMan !=
                                                          null)
                                                      ? '${order.trackingModel.deliveryMan.fName} ${order.trackingModel.deliveryMan.lName}'
                                                      : '',
                                                  style: mulishRegular.copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeSmall),
                                                ),
                                              ]),
                                        ]),
                                  )
                                :
                                //third party
                                order.trackingModel.thirdPartyServiceName !=
                                        null
                                    ? Container(
                                        padding: EdgeInsets.all(
                                            Dimensions.PADDING_SIZE_SMALL),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .highlightColor),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${getTranslated('shipping_info', context)}',
                                                  style: mulishBold),
                                              SizedBox(
                                                  height: Dimensions
                                                      .MARGIN_SIZE_EXTRA_SMALL),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        '${getTranslated('delivery_service_name', context)} : ',
                                                        style: mulishRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall)),
                                                    Text(
                                                      (order.trackingModel
                                                                      .thirdPartyServiceName !=
                                                                  null &&
                                                              order
                                                                  .trackingModel
                                                                  .thirdPartyServiceName
                                                                  .isNotEmpty)
                                                          ? order.trackingModel
                                                              .thirdPartyServiceName
                                                          : '',
                                                      style: mulishRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall),
                                                    ),
                                                  ]),
                                              SizedBox(
                                                  height: Dimensions
                                                      .MARGIN_SIZE_EXTRA_SMALL),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        '${getTranslated('tracking_id', context)} : ',
                                                        style: mulishRegular.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall)),
                                                    Text(
                                                        order.trackingModel
                                                                    .thirdPartyTrackingId !=
                                                                null
                                                            ? order
                                                                .trackingModel
                                                                .thirdPartyTrackingId
                                                            : '',
                                                        style: mulishRegular
                                                            .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                        )),
                                                  ]),
                                            ]),
                                      )
                                    : SizedBox(),

                            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                            // Payment
                            Container(
                              padding:
                                  EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).highlightColor),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(getTranslated('PAYMENT', context),
                                        style: mulishBold),
                                    SizedBox(
                                        height:
                                            Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              getTranslated(
                                                  'PAYMENT_STATUS', context),
                                              style: mulishRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeDefault)),
                                          Text(
                                            (order.trackingModel
                                                            .paymentStatus !=
                                                        null &&
                                                    order
                                                        .trackingModel
                                                        .paymentStatus
                                                        .isNotEmpty)
                                                ? getTranslated(
                                                    order.trackingModel
                                                        .paymentStatus,
                                                    context)
                                                : '',
                                            style: mulishRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeDefault),
                                          ),
                                        ]),
                                    SizedBox(
                                        height:
                                            Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              getTranslated(
                                                  'PAYMENT_PLATFORM', context),
                                              style: mulishRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeDefault)),
                                          (order.trackingModel.paymentMethod !=
                                                      'cash_on_delivery' &&
                                                  order.trackingModel
                                                          .paymentStatus ==
                                                      'unpaid')
                                              ? InkWell(
                                                  onTap: () async {
                                                    String userID = await Provider
                                                            .of<ProfileProvider>(
                                                                context,
                                                                listen: false)
                                                        .getUserInfo(context);
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                PaymentScreen(
                                                                  customerID:
                                                                      userID,
                                                                  couponCode:
                                                                      '',
                                                                  addressID: order
                                                                      .trackingModel
                                                                      .shippingAddress
                                                                      .toString(),
                                                                  // billingId: orderModel.billingAddress.toString(),
                                                                )));
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: Dimensions
                                                            .PADDING_SIZE_EXTRA_SMALL),
                                                    decoration: BoxDecoration(
                                                      color: ColorResources
                                                          .getPrimary(context),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Text(
                                                        getTranslated(
                                                            'pay_now', context),
                                                        style:
                                                            mulishBold.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeExtraSmall,
                                                          color: Theme.of(
                                                                  context)
                                                              .highlightColor,
                                                        )),
                                                  ),
                                                )
                                              : Text(
                                                  order.trackingModel.paymentMethod !=
                                                              null &&
                                                          <String>[
                                                            'cash_on_delivery',
                                                            'pay_by_wallet'
                                                          ].contains(order
                                                              .trackingModel
                                                              .paymentMethod)
                                                      ? getTranslated(
                                                          order.trackingModel
                                                              .paymentMethod,
                                                          context)
                                                      : order.trackingModel
                                                          .paymentMethod
                                                          .replaceAll('_', ' '),
                                                  style: mulishBold.copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  )),
                                        ]),
                                  ]),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            order.trackingModel.paymentMethod != null &&
                                    <String>[
                                      'cash_on_delivery',
                                      'pay_by_wallet'
                                    ].contains(
                                        order.trackingModel.paymentMethod)
                                ? SizedBox()
                                : Container(
                                    padding: EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_DEFAULT),
                                    width: MediaQuery.of(context).size.width,
                                    child: order.trackingModel.paymentImages !=
                                                null &&
                                            order.trackingModel.paymentImages
                                                    .length >
                                                0
                                        ? InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      PaymentImageScreen(
                                                    title: getTranslated(
                                                        'digital_payment',
                                                        context),
                                                    imageList: order
                                                        .trackingModel
                                                        .paymentImages
                                                        .map((v) => v.image)
                                                        .toList(),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                Dimensions.PADDING_SIZE_SMALL,
                                              ),
                                              child: CachedNetworkImage(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                fit: BoxFit.cover,
                                                imageUrl: order.trackingModel
                                                    .paymentImages.last.image,
                                                placeholder: (c, o) =>
                                                    Image.asset(
                                                  Images.placeholder,
                                                  fit: BoxFit.cover,
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                ),
                                              ),
                                            ),
                                          )
                                        : SizedBox()),

                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_SMALL,
                                  vertical: Dimensions.PADDING_SIZE_SMALL),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: orderModel != null &&
                                            orderModel.orderStatus ==
                                                'pending' &&
                                            orderType != "POS"
                                        ? CustomButton(
                                            buttonText: getTranslated(
                                                'cancel_order', context),
                                            onTap: () =>
                                                Provider.of<OrderProvider>(
                                                        context,
                                                        listen: false)
                                                    .cancelOrder(
                                                        context, orderId)
                                                    .then((value) {
                                                  if (value.response
                                                          .statusCode ==
                                                      200) {
                                                    Provider.of<OrderProvider>(
                                                            context,
                                                            listen: false)
                                                        .initOrderList(context);
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(getTranslated(
                                                          'order_cancelled_successfully',
                                                          context)),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ));
                                                  }
                                                }))
                                        : CustomButton(
                                            buttonText: getTranslated(
                                                'TRACK_ORDER', context),
                                            onTap: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        TrackingScreen(
                                                            orderID: orderId
                                                                .toString()))),
                                          ),
                                  ),
                                  SizedBox(
                                      width: Dimensions.PADDING_SIZE_SMALL),
                                  Expanded(
                                    child: CustomButtonOutline(
                                      buttonText: getTranslated(
                                          'SUPPORT_CENTER', context),
                                      onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SupportTicketScreen())),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : LoadingPage();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
