import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class CustomButtonOutline extends StatelessWidget {
  final Function onTap;
  final String buttonText;
  final bool isBorder;
  CustomButtonOutline(
      {this.onTap, @required this.buttonText, this.isBorder = false});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
      child: Container(
        height: 55,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: ColorResources.getPrimary(context)),
            borderRadius: BorderRadius.circular(isBorder
                ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                : Dimensions.PADDING_SIZE_SMALL)),
        child: Text(buttonText,
            style: mulishRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraLarge,
              color: ColorResources.getPrimary(context),
            )),
      ),
    );
  }
}
