import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';

void showCustomSnackBar(String message, BuildContext context,
    {bool isError = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: mulishRegular,
      ),
      backgroundColor: isError ? ColorResources.getRed(context) : Colors.green,
    ),
  );
}
