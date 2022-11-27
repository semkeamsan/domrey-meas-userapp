import 'package:flutter/material.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/widget/brand_view.dart';

class AllBrandScreen extends StatelessWidget {
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
          CustomAppBar(title: getTranslated('all_brand', context)),
          Container(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: BrandView(isHomePage: false),
          ),
        ],
      ),
    );
  }
}
