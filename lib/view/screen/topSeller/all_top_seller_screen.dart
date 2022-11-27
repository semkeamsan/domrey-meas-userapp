import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/top_seller_model.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/widget/top_seller_view.dart';
import 'package:provider/provider.dart';

class AllTopSellerScreen extends StatelessWidget {
  final TopSellerModel topSeller;
  AllTopSellerScreen({@required this.topSeller});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      appBar: AppBar(
        backgroundColor: Theme.of(context).highlightColor,
        elevation: 0,
        toolbarHeight: 5,
      ),
      body: Column(
        children: [
          CustomAppBar(title: getTranslated('top_seller', context)),
          Container(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: TopSellerView(isHomePage: false),
          ),
        ],
      ),
    );
  }
}
