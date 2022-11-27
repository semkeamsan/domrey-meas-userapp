import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final int maxLine;
  final FocusNode focusNode;
  final FocusNode nextNode;
  final TextInputAction textInputAction;
  final bool isPhoneNumber;
  final bool isValidator;
  final String validatorMessage;
  final TextCapitalization capitalization;
  final bool isBorder;

  CustomTextField({
    this.controller,
    this.hintText,
    this.textInputType,
    this.maxLine,
    this.focusNode,
    this.nextNode,
    this.textInputAction,
    this.isPhoneNumber = false,
    this.isValidator = false,
    this.validatorMessage,
    this.capitalization = TextCapitalization.none,
    this.isBorder = false,
  });

  @override
  Widget build(context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: isBorder
            ? Border.all(width: .8, color: Theme.of(context).hintColor)
            : null,
        color: Theme.of(context).highlightColor,
        borderRadius: isPhoneNumber
            ? BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)
            : BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1)) // changes position of shadow
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
        child: TextFormField(
          textAlign: isBorder ? TextAlign.center : TextAlign.start,
          controller: controller,
          maxLines: maxLine ?? 1,
          textCapitalization: capitalization,
          maxLength: isPhoneNumber ? 15 : null,
          focusNode: focusNode,
          keyboardType: textInputType ?? TextInputType.text,
          //keyboardType: TextInputType.number,
          initialValue: null,
          textInputAction: textInputAction ?? TextInputAction.next,
          onFieldSubmitted: (v) {
            FocusScope.of(context).requestFocus(nextNode);
          },
          //autovalidate: true,
          inputFormatters: [
            isPhoneNumber
                ? FilteringTextInputFormatter.digitsOnly
                : FilteringTextInputFormatter.singleLineFormatter
          ],
          validator: (input) {
            if (input.isEmpty) {
              if (isValidator) {
                return validatorMessage ?? "";
              }
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hintText ?? '',
            filled: true,
            fillColor: ColorResources.hintTextBoxColor(context),
            contentPadding:
                EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
            isDense: true,
            counterText: '',
            focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                borderSide: BorderSide(color: Theme.of(context).primaryColor)),
            hintStyle: mulishRegular.copyWith(
                color: Theme.of(context).hintColor,
                fontSize: Dimensions.fontSizeDefault),
            errorStyle: TextStyle(height: 1.5),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
