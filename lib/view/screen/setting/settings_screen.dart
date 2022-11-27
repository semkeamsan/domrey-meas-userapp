import 'package:flutter/material.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/setting/widget/currency_dialog.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<SplashProvider>(context, listen: false).setFromSetting(true);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomAppBar(title: getTranslated('settings', context)),
          Padding(
            padding: EdgeInsets.only(
                top: Dimensions.PADDING_SIZE_LARGE,
                left: Dimensions.PADDING_SIZE_LARGE),
            child: Text(getTranslated('settings', context),
                style: mulishBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
          ),
          Expanded(
              child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            children: [
              // SwitchListTile(
              //   value: Provider.of<ThemeProvider>(context,listen:false)(context).darkTheme,
              //   onChanged: (bool isActive) =>
              //       Provider.of<ThemeProvider>(context,listen:false)(context, listen: false)
              //           .toggleTheme(),
              //   title: Text(getTranslated('dark_theme', context),
              //       style: mulishRegular.copyWith(
              //           fontSize: Dimensions.fontSizeLarge)),
              // ),
              TitleButton(
                image: Images.language,
                title: getTranslated('choose_language', context),
                onTap: () => showAnimatedDialog(
                    context, CurrencyDialog(isCurrency: false)),
              ),
              TitleButton(
                image: Images.currency,
                title:
                    '${getTranslated('currency', context)} (${Provider.of<SplashProvider>(context).myCurrency.name})',
                onTap: () => showAnimatedDialog(context, CurrencyDialog()),
              ),
            ],
          )),
        ]),
      ),
    );
  }
}

class TitleButton extends StatelessWidget {
  final String image;
  final String title;
  final Function onTap;
  TitleButton(
      {@required this.image, @required this.title, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(image,
          width: 25,
          height: 25,
          fit: BoxFit.fill,
          color: ColorResources.getPrimary(context)),
      title: Text(title,
          style: mulishRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
      onTap: onTap,
    );
  }
}
