import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/helper/responsive.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/search/widget/search_filter_bottom_sheet.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchProductWidget extends StatelessWidget {
  final bool isViewScrollable;
  final List<Product> products;
  SearchProductWidget({this.isViewScrollable, this.products});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      child: Column(
        children: [
          // Text.rich(
          //   TextSpan(
          //     children: [
          //       TextSpan(
          //           text: '${getTranslated('searched_item', context)}',
          //           style: mulishRegular.copyWith(
          //               fontSize: Dimensions.fontSizeDefault,
          //               color: ColorResources.getReviewRattingColor(context))),
          //       TextSpan(
          //           text: '(${products.length} ' +
          //               '${getTranslated('item_found', context)})'),
          //     ],
          //   ),
          // ),
          Row(
            children: [
              Expanded(
                  child: Text(
                '${getTranslated('searched_item', context)}',
                style: mulishRegular,
              )),
              InkWell(
                onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (c) => SearchFilterBottomSheet()),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                      horizontal: Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    color: ColorResources.getPrimary(context),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(children: [
                    Image.asset(Images.dropdown,
                        width: Responsive.isMobile(context)
                            ? Dimensions.iconSizeSmall
                            : Dimensions.fontSizeLarge,
                        height: Responsive.isMobile(context)
                            ? Dimensions.iconSizeDefault
                            : Dimensions.fontSizeLarge,
                        color: ColorResources.WHITE),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Text(
                      getTranslated('filter', context),
                      style: mulishRegular.copyWith(
                          fontSize: Responsive.isMobile(context)
                              ? Dimensions.fontSizeSmall
                              : Dimensions.fontSizeDefault,
                          color: ColorResources.WHITE),
                    ),
                  ]),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          Expanded(
            child: StaggeredGridView.countBuilder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(0),
              crossAxisCount: 2,
              itemCount: products.length,
              staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
              itemBuilder: (BuildContext context, int index) {
                return ProductWidget(productModel: products[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
