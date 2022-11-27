import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/helper/responsive.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class CustomCheckBox extends StatelessWidget {
  final String title;
  final String desc;
  final String image;
  final String imageUrl;
  final int index;
  CustomCheckBox(
      {@required this.title,
      this.image,
      this.imageUrl,
      this.desc,
      @required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        return InkWell(
          onTap: () => order.setPaymentMethod(index),
          child: Row(children: [
            Expanded(
              child: Row(
                children: [
                  Visibility(
                    visible: image != null || imageUrl != null ? true : false,
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          Dimensions.PADDING_SIZE_SMALL,
                        ),
                        child: imageUrl != null && imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                height: Responsive.isMobile(context) ? 60 : 120,
                                width: Responsive.isMobile(context) ? 60 : 120,
                                fit: BoxFit.cover,
                                placeholder: (c, o) => Image.asset(
                                  Images.placeholder,
                                  fit: BoxFit.cover,
                                  height:
                                      Responsive.isMobile(context) ? 60 : 120,
                                  width:
                                      Responsive.isMobile(context) ? 60 : 120,
                                ),
                              )
                            : Image.asset(image,
                                height: Responsive.isMobile(context) ? 60 : 120,
                                width: Responsive.isMobile(context) ? 60 : 120),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: mulishBold.copyWith(
                              fontSize: Dimensions.fontSizeLarge,
                              color: order.paymentMethodIndex == index
                                  ? ColorResources.getSecondaryText(context)
                                  : ColorResources.getSecondaryText(context)
                                      .withOpacity(.6),
                            )),
                        SizedBox(
                          height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                        ),
                        Text(desc,
                            style: mulishRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: order.paymentMethodIndex == index
                                  ? ColorResources.getSecondaryText(context)
                                  : ColorResources.getSecondaryText(context)
                                      .withOpacity(.6),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                shape: CircleBorder(),
                value: order.paymentMethodIndex == index,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (bool isChecked) => order.setPaymentMethod(index),
              ),
            )
          ]),
        );
      },
    );
  }
}
