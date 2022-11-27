import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/order_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/order_details_screen.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel orderModel;
  OrderWidget({this.orderModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(
                orderModel: orderModel,
                orderId: orderModel.id,
                orderType: orderModel.orderType,
                extraDiscount: orderModel.extraDiscount,
                extraDiscountType: orderModel.extraDiscountType)));
      },
      child: Container(
        margin: EdgeInsets.only(
            bottom: Dimensions.PADDING_SIZE_SMALL,
            left: Dimensions.PADDING_SIZE_SMALL,
            right: Dimensions.PADDING_SIZE_SMALL),
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: BorderRadius.circular(5)),
        child: Row(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(getTranslated('ORDER_ID', context),
                  style: mulishRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall)),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Text(orderModel.id.toString(), style: mulishBold),
            ]),
            Row(children: [
              Text(
                  DateConverter.localDateToIsoStringAMPM(
                      DateTime.parse(orderModel.createdAt)),
                  style: mulishRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).hintColor,
                  )),
            ]),
          ]),
          SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(getTranslated('total_price', context),
                  style: mulishRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall)),
              Text(PriceConverter.convertPrice(context, orderModel.orderAmount),
                  style: mulishBold),
            ]),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_SMALL,
                vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            decoration: BoxDecoration(
              color: ColorResources.getPrimary(context),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(getTranslated('${orderModel.orderStatus}', context),
                style: mulishRegular.copyWith(
                    color: Theme.of(context).highlightColor,
                    fontSize: Dimensions.fontSizeExtraSmall)),
          ),
        ]),
      ),
    );
  }
}
