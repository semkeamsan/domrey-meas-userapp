import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/data/helper/responsive.dart';

class SellerRegisterSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Column(children: [
        CustomAppBar(
            isBackButtonExist: false,
            title: (getTranslated('seller_register_success', context))),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
              height: 170,
              padding: EdgeInsets.all(20),
              child: Image.asset(
                Images.success,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Container(
              child: Text(
                getTranslated('seller_register_success', context),
                style: mulishBold.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge),
              ),
            ),
            Text(
              getTranslated('seller_register_success_msg', context),
              style: TextStyle(
                color: ColorResources.getSecondaryText(context),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DashBoardScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                  child: Container(
                    height: Responsive.isMobile(context) ? 45 : 55,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: ColorResources.getChatIcon(context),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 1)), // changes position of shadow
                        ],
                        gradient:
                            (Provider.of<ThemeProvider>(context).darkTheme)
                                ? null
                                : LinearGradient(colors: [
                                    Theme.of(context).primaryColor,
                                    Theme.of(context).primaryColor,
                                    Theme.of(context).primaryColor,
                                  ]),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(getTranslated('back_to_home', context),
                        style: mulishBold.copyWith(
                          fontSize: Responsive.isMobile(context)
                              ? Dimensions.fontSizeDefault
                              : Dimensions.fontSizeDefault,
                          color: Theme.of(context).highlightColor,
                          // color: ColorResources.BLACK,
                        )),
                  ),
                ))
            // Flexible(
            //   child: HomeButton(
            //     title: 'Home',
            //     onTap: () {},
            //   ),
            // ),
          ],
        ),
      ]),
    );
  }
}
