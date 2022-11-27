import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/helper/responsive.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/seller_register_model.dart';
// ignore: unused_import
import 'package:flutter_sixvalley_ecommerce/data/model/response/user_info_model.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/textfield/custom_password_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/textfield/custom_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/widget/code_picker_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/seller/widget/seller_register_success.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class BecomeSellerScreen extends StatefulWidget {
  @override
  _BecomeSellerScreenState createState() => _BecomeSellerScreenState();
}

class _BecomeSellerScreenState extends State<BecomeSellerScreen> {
  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _shopNameFocus = FocusNode();
  final FocusNode _shopAddressFocus = FocusNode();
  final FocusNode _bankNameFocus = FocusNode();
  final FocusNode _accountNameFocus = FocusNode();
  final FocusNode _accountNumberFocus = FocusNode();
  SellerRegisterModel sellerRegisterModel = SellerRegisterModel();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _shopAddressController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();

  File fileProfile;
  File fileIDCard;
  File fileLogo;
  File fileBanner;

  bool enabledButtonUpdate = true;
  String _countryDialCode = "+855";
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  void _chooseProfile() async {
    final pickedFileProfile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    if (pickedFileProfile != null) {
      await Provider.of<SplashProvider>(context, listen: false).uploadTempImage(
        File(pickedFileProfile.path),
        (String url) {
          if (url != null && url.isNotEmpty) {
            sellerRegisterModel.profileImage = url;
            print('URL ${sellerRegisterModel.profileImage}');
            print('URL ${url}');
            Provider.of<SplashProvider>(context, listen: false).update();
          }
        },
      );
    }
    setState(() {
      if (pickedFileProfile != null) {
        fileProfile = File(pickedFileProfile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _chooseIDCard() async {
    final pickedFileIDCard = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    if (pickedFileIDCard != null) {
      await Provider.of<SplashProvider>(context, listen: false).uploadTempImage(
        File(pickedFileIDCard.path),
        (String url) {
          if (url != null && url.isNotEmpty) {
            sellerRegisterModel.idCard = '${url}';
            Provider.of<SplashProvider>(context, listen: false).update();
          }
        },
      );
    }
    setState(() {
      if (pickedFileIDCard != null) {
        fileIDCard = File(pickedFileIDCard.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _chooseLogo() async {
    final pickedFileLogo = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    if (pickedFileLogo != null) {
      await Provider.of<SplashProvider>(context, listen: false).uploadTempImage(
        File(pickedFileLogo.path),
        (String url) {
          if (url != null && url.isNotEmpty) {
            sellerRegisterModel.logo = '${url}';
            Provider.of<SplashProvider>(context, listen: false).update();
          }
        },
      );
    }
    setState(() {
      if (pickedFileLogo != null) {
        fileLogo = File(pickedFileLogo.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void alertMessage(String title) {
    showCustomSnackBar(title, context);
  }

  void _chooseBanner() async {
    final pickedFileBanner = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    if (pickedFileBanner != null) {
      await Provider.of<SplashProvider>(context, listen: false).uploadTempImage(
        File(pickedFileBanner.path),
        (String url) {
          if (url != null && url.isNotEmpty) {
            sellerRegisterModel.banner = '${url}';
            Provider.of<SplashProvider>(context, listen: false).update();
          }
        },
      );
    }
    setState(() {
      if (pickedFileBanner != null) {
        fileBanner = File(pickedFileBanner.path);
      } else {
        print('No image selected.');
      }
    });
  }

  _submitSeller() async {
    String _firstName = _firstNameController.text.trim();
    String _lastName = _lastNameController.text.trim();
    String _email = _emailController.text.trim();
    String _phoneNumber = _countryDialCode + _phoneController.text.trim();
    String _password = _passwordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();
    String _shopName = _shopNameController.text.trim();
    String _shopAddress = _shopNameController.text.trim();
    String _bankName = _bankNameController.text.trim();
    String _accountName = _accountNameController.text.trim();
    String _accountNumber = _accountNumberController.text.trim();
    print('First Name ${_firstName}');
    print('Last Name ${_lastName}');
    print('Email ${_email}');
    print('Phone ${_phoneNumber}');
    print('Shop Name ${_shopName}');
    print('Shop Address ${_shopAddress}');
    print('Bank Name ${_bankName}');
    print('Account Name ${_accountName}');
    print('Account Number ${_accountNumber}');
    for (int i = 0;
        i <
            Provider.of<OrderProvider>(context, listen: false)
                .paymentMethodList
                .length;
        i++) {
      if (Provider.of<OrderProvider>(context, listen: false)
              .paymentMethodIndex ==
          i) {
        print(
            'Payment ID ${Provider.of<OrderProvider>(context, listen: false).paymentMethodList[i].id}');
      }
    }

    if (_firstName.isEmpty || _lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            getTranslated('NAME_FIELD_MUST_BE_REQUIRED', context),
            style: mulishRegular.copyWith(
              fontSize: Responsive.isMobile(context)
                  ? Dimensions.fontSizeDefault
                  : Dimensions.fontSizeLarge,
            ),
          ),
          backgroundColor: ColorResources.RED));
    } else if (_email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            getTranslated('EMAIL_MUST_BE_REQUIRED', context),
            style: mulishRegular.copyWith(
              fontSize: Responsive.isMobile(context)
                  ? Dimensions.fontSizeDefault
                  : Dimensions.fontSizeDefault,
            ),
          ),
          backgroundColor: ColorResources.RED));
    } else if (_phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            getTranslated('PHONE_MUST_BE_REQUIRED', context),
            style: mulishRegular.copyWith(
              fontSize: Responsive.isMobile(context)
                  ? Dimensions.fontSizeDefault
                  : Dimensions.fontSizeDefault,
            ),
          ),
          backgroundColor: ColorResources.RED));
    } else if ((_password.isNotEmpty && _password.length < 6) ||
        (_confirmPassword.isNotEmpty && _confirmPassword.length < 6)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            getTranslated('Password should be at least 6 character', context),
            style: mulishRegular.copyWith(
              fontSize: Responsive.isMobile(context)
                  ? Dimensions.fontSizeDefault
                  : Dimensions.fontSizeDefault,
            ),
          ),
          backgroundColor: ColorResources.RED));
    } else if (_password != _confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            getTranslated('PASSWORD_DID_NOT_MATCH', context),
            style: mulishRegular.copyWith(
              fontSize: Responsive.isMobile(context)
                  ? Dimensions.fontSizeDefault
                  : Dimensions.fontSizeDefault,
            ),
          ),
          backgroundColor: ColorResources.RED));
    } else if (_shopName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            getTranslated('shop_name_required', context),
            style: mulishRegular.copyWith(
              fontSize: Responsive.isMobile(context)
                  ? Dimensions.fontSizeDefault
                  : Dimensions.fontSizeDefault,
            ),
          ),
          backgroundColor: ColorResources.RED));
    } else if (_shopAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            getTranslated('shop_address_required', context),
            style: mulishRegular.copyWith(
              fontSize: Responsive.isMobile(context)
                  ? Dimensions.fontSizeDefault
                  : Dimensions.fontSizeDefault,
            ),
          ),
          backgroundColor: ColorResources.RED));
    } else if (_accountName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            getTranslated('please_select_bank', context),
            style: mulishRegular.copyWith(
              fontSize: Responsive.isMobile(context)
                  ? Dimensions.fontSizeDefault
                  : Dimensions.fontSizeDefault,
            ),
          ),
          backgroundColor: ColorResources.RED));
    } else if (_accountName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            getTranslated('please_enter_account_name', context),
            style: mulishRegular.copyWith(
              fontSize: Responsive.isMobile(context)
                  ? Dimensions.fontSizeDefault
                  : Dimensions.fontSizeDefault,
            ),
          ),
          backgroundColor: ColorResources.RED));
    } else if (_accountNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            getTranslated('please_enter_account_number', context),
            style: mulishRegular.copyWith(
              fontSize: Responsive.isMobile(context)
                  ? Dimensions.fontSizeDefault
                  : Dimensions.fontSizeDefault,
            ),
          ),
          backgroundColor: ColorResources.RED));
    } else {
      sellerRegisterModel.fName = _firstNameController.text ?? '';
      sellerRegisterModel.lName = _lastNameController.text ?? '';
      sellerRegisterModel.shopName = _shopNameController.text ?? '';
      sellerRegisterModel.shopAddress = _shopAddressController.text ?? '';
      sellerRegisterModel.password = _passwordController.text ?? '';
      sellerRegisterModel.holderName = _accountNameController.text ?? '';
      sellerRegisterModel.bankName = _bankNameController.text ?? '';
      sellerRegisterModel.accountNo = _accountNumberController.text ?? '';
      sellerRegisterModel.phone = _phoneNumber ?? '';
      sellerRegisterModel.email = _emailController.text ?? '';
      print('REGGGG ${sellerRegisterModel.toJson()}');
      for (int i = 0;
          i <
              Provider.of<OrderProvider>(context, listen: false)
                  .paymentMethodList
                  .length;
          i++) {
        if (Provider.of<OrderProvider>(context, listen: false)
                .paymentMethodIndex ==
            i) {
          // print(
          //     'Payment ID ${Provider.of<orderProvider>(context, listen: false).paymentMethodList[i].id}');
          sellerRegisterModel.paymentMethodId =
              '${Provider.of<OrderProvider>(context, listen: false).paymentMethodList[i].id}';
        }
      }

      Provider.of<AuthProvider>(context, listen: false)
          .sellerRegistration(sellerRegisterModel, route);
    }
  }

  route(
      bool isRoute, String token, String tempToken, String errorMessage) async {
    String _phoneNumber = _countryDialCode + _phoneController.text.trim();
    String _password = _passwordController.text.trim();
    if (isRoute) {
      // if (Provider.of<SplashProvider>(context, listen: false)
      //     .configModel
      //     .emailVerification) {
      //   SMSModel().sendOTP(
      //       context: context,
      //       onMessage: alertMessage,
      //       tempToken: tempToken,
      //       phoneNumber: _phoneNumber,
      //       password: _password);
      // } else if (Provider.of<SplashProvider>(context, listen: false)
      //     .configModel
      //     .phoneVerification) {
      //   SMSModel().sendOTP(
      //       context: context,
      //       onMessage: alertMessage,
      //       tempToken: tempToken,
      //       phoneNumber: _phoneNumber,
      //       password: _password);
      // } else {
      await Provider.of<ProfileProvider>(context, listen: false)
          .getUserInfo(context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => SellerRegisterSuccess()),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            errorMessage,
            style: mulishRegular.copyWith(
              fontSize: Responsive.isMobile(context)
                  ? Dimensions.fontSizeDefault
                  : Dimensions.fontSizeDefault,
            ),
          ),
          backgroundColor: Colors.red));
    }
  }
  // route(bool isRoute, String message) {
  //   if (isRoute) {
  //     _firstNameController.clear();
  //     _lastNameController.clear();
  //     Provider.of<ProfileProvider>(context, listen: false)
  //         .initAddressList(context);
  //     Navigator.pop(context);
  //   }
  // }

  @override
  void initState() {
    Provider.of<OrderProvider>(context, listen: false)
        .initPaymethMethodList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).highlightColor,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: ColorResources.getPrimary(context),
        title: Text(getTranslated('become_seller', context),
            style: mulishRegular.copyWith(
                fontSize: 20, color: Theme.of(context).highlightColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<ProfileProvider>(
              builder: (context, profile, child) {
                return Column(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(
                              Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                            ),
                            child: Text(
                                getTranslated('seller_register', context),
                                style: mulishBold.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,
                                    color: ColorResources.getPrimary(context))),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  children: [
                                    CustomTextField(
                                      textInputType: TextInputType.name,
                                      focusNode: _fNameFocus,
                                      nextNode: _lNameFocus,
                                      hintText:
                                          getTranslated('FIRST_NAME', context),
                                      controller: _firstNameController,
                                    ),
                                  ],
                                )),
                                SizedBox(width: 15),
                                Expanded(
                                    child: Column(
                                  children: [
                                    CustomTextField(
                                      textInputType: TextInputType.name,
                                      focusNode: _lNameFocus,
                                      nextNode: _emailFocus,
                                      hintText:
                                          getTranslated('LAST_NAME', context),
                                      controller: _lastNameController,
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ),
                          // for Email
                          Container(
                            margin: EdgeInsets.only(
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              children: [
                                SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                CustomTextField(
                                  textInputType: TextInputType.emailAddress,
                                  focusNode: _emailFocus,
                                  nextNode: _phoneFocus,
                                  hintText: getTranslated('EMAIL', context),
                                  controller: _emailController,
                                ),
                              ],
                            ),
                          ),

                          // for Phone No
                          Container(
                            margin: EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_SMALL,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Row(children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: CodePickerWidget(
                                  onChanged: (CountryCode countryCode) {
                                    _countryDialCode = countryCode.dialCode;
                                  },
                                  //countryFilter: ['kh', 'th', 'vn', 'us'],
                                  initialSelection: _countryDialCode,
                                  favorite: [_countryDialCode],
                                  showDropDownButton: true,
                                  padding: EdgeInsets.zero,
                                  showFlagMain: true,
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: Responsive.isMobile(context)
                                        ? Dimensions.fontSizeDefault
                                        : Dimensions.fontSizeDefault,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Expanded(
                                  child: CustomTextField(
                                hintText: getTranslated(
                                    'ENTER_MOBILE_NUMBER', context),
                                controller: _phoneController,
                                focusNode: _phoneFocus,
                                nextNode: _passwordFocus,
                                isPhoneNumber: true,
                                textInputType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                              )),
                            ]),
                          ),
                          // for Password
                          Container(
                            margin: EdgeInsets.only(
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              children: [
                                SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                CustomPasswordTextField(
                                  hintTxt: getTranslated('PASSWORD', context),
                                  controller: _passwordController,
                                  focusNode: _passwordFocus,
                                  nextNode: _confirmPasswordFocus,
                                  textInputAction: TextInputAction.next,
                                ),
                              ],
                            ),
                          ),

                          // for  re-enter Password
                          Container(
                            margin: EdgeInsets.only(
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              children: [
                                SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                CustomPasswordTextField(
                                  hintTxt: getTranslated(
                                      'RE_ENTER_PASSWORD', context),
                                  controller: _confirmPasswordController,
                                  focusNode: _confirmPasswordFocus,
                                  nextNode: _shopNameFocus,
                                  textInputAction: TextInputAction.next,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(
                              Dimensions.MARGIN_SIZE_DEFAULT,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getTranslated('shop_info', context),
                                    style: mulishBold.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: ColorResources.getPrimary(
                                            context))),
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  CustomTextField(
                                    hintText:
                                        getTranslated('shop_name', context),
                                    controller: _shopNameController,
                                    focusNode: _shopNameFocus,
                                    nextNode: _shopAddressFocus,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  SizedBox(
                                    height: Dimensions.PADDING_SIZE_SMALL,
                                  ),
                                  CustomTextField(
                                    hintText:
                                        getTranslated('shop_address', context),
                                    controller: _shopAddressController,
                                    focusNode: _shopAddressFocus,
                                    nextNode: _accountNameFocus,
                                    textInputAction: TextInputAction.next,
                                  )
                                ],
                              )),
                          Container(
                            margin: EdgeInsets.all(
                              Dimensions.MARGIN_SIZE_DEFAULT,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getTranslated('bank_info', context),
                                    style: mulishBold.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: ColorResources.getPrimary(
                                            context))),
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  // Consumer<OrderProvider>(
                                  //     builder: (context, orderProvider, child) {
                                  //   return orderProvider.paymentMethodList !=
                                  //           null
                                  //       ? Container(
                                  //           child: Column(
                                  //             children: [
                                  //               Container(
                                  //                 child: CustomDropdown(
                                  //                   maxListHeight: 350,
                                  //                   items: List.generate(
                                  //                       orderProvider
                                  //                           .paymentMethodList
                                  //                           .length,
                                  //                       (index) =>
                                  //                           CustomDropdownMenuItem(
                                  //                             value: index,
                                  //                             child: Row(
                                  //                               children: [
                                  //                                 CachedNetworkImage(
                                  //                                   imageUrl: orderProvider
                                  //                                       .paymentMethodList[
                                  //                                           index]
                                  //                                       .image,
                                  //                                   width: 40,
                                  //                                   height: 40,
                                  //                                 ),
                                  //                                 SizedBox(
                                  //                                   width: Dimensions
                                  //                                       .PADDING_SIZE_SMALL,
                                  //                                 ),
                                  //                                 Text(
                                  //                                   orderProvider
                                  //                                       .paymentMethodList[
                                  //                                           index]
                                  //                                       .name,
                                  //                                   style: mulishRegular
                                  //                                       .copyWith(
                                  //                                     fontSize:
                                  //                                         Dimensions
                                  //                                             .fontSizeDefault,
                                  //                                   ),
                                  //                                 ),
                                  //                               ],
                                  //                             ),
                                  //                           )),
                                  //                   hintText: getTranslated(
                                  //                       'select_bank', context),
                                  //                   borderRadius: Dimensions
                                  //                       .PADDING_SIZE_SMALL,
                                  //                   defaultSelectedIndex:
                                  //                       orderProvider
                                  //                           .paymentMethodIndex,
                                  //                   onChanged: (val) {
                                  //                     orderProvider
                                  //                         .setPaymentMethod(
                                  //                             val);
                                  //                   },
                                  //                 ),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         )
                                  //       : SizedBox();
                                  // }),
                                  CustomTextField(
                                    hintText:
                                        getTranslated('bank_name', context),
                                    controller: _bankNameController,
                                    focusNode: _bankNameFocus,
                                    nextNode: _accountNameFocus,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  SizedBox(
                                    height: Dimensions.PADDING_SIZE_SMALL,
                                  ),
                                  CustomTextField(
                                    hintText:
                                        getTranslated('account_name', context),
                                    controller: _accountNameController,
                                    focusNode: _accountNameFocus,
                                    nextNode: _accountNumberFocus,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  SizedBox(
                                    height: Dimensions.PADDING_SIZE_SMALL,
                                  ),
                                  CustomTextField(
                                    hintText: getTranslated(
                                        'account_number', context),
                                    controller: _accountNumberController,
                                    focusNode: _accountNumberFocus,
                                    textInputAction: TextInputAction.done,
                                  )
                                ],
                              )),
                          Container(
                            margin: EdgeInsets.all(
                              Dimensions.MARGIN_SIZE_DEFAULT,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getTranslated('image', context),
                                    style: mulishBold.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: ColorResources.getPrimary(
                                            context))),
                              ],
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.only(
                                left: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                                right: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(getTranslated(
                                          'upload_profile_image', context)),
                                      SizedBox(
                                        height: Dimensions.PADDING_SIZE_SMALL,
                                      ),
                                      InkWell(
                                        onTap: _chooseProfile,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: fileProfile == null
                                              ? Image.asset(Images.placeholder,
                                                  width: Responsive.isTab()
                                                      ? 300
                                                      : 150,
                                                  height: Responsive.isTab()
                                                      ? 300
                                                      : 150,
                                                  fit: BoxFit.cover)
                                              : Image.file(fileProfile,
                                                  width: Responsive.isTab()
                                                      ? 300
                                                      : 150,
                                                  height: Responsive.isTab()
                                                      ? 300
                                                      : 150,
                                                  fit: BoxFit.fill),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: Dimensions.PADDING_SIZE_DEFAULT,
                                  ),
                                  Column(
                                    children: [
                                      Text(getTranslated(
                                          'upload_id_card_image', context)),
                                      SizedBox(
                                        height: Dimensions.PADDING_SIZE_SMALL,
                                      ),
                                      InkWell(
                                        onTap: _chooseIDCard,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: fileIDCard == null
                                              ? Image.asset(Images.placeholder,
                                                  width: Responsive.isTab()
                                                      ? 300
                                                      : 150,
                                                  height: Responsive.isTab()
                                                      ? 300
                                                      : 150,
                                                  fit: BoxFit.cover)
                                              : Image.file(fileIDCard,
                                                  width: Responsive.isTab()
                                                      ? 300
                                                      : 150,
                                                  height: Responsive.isTab()
                                                      ? 300
                                                      : 150,
                                                  fit: BoxFit.fill),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: Dimensions.PADDING_SIZE_LARGE,
                                left: Dimensions.PADDING_SIZE_EXTRA_LARGE,
                                right: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text(getTranslated(
                                              'upload_logo_image', context)),
                                          SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL,
                                          ),
                                          InkWell(
                                            onTap: _chooseLogo,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: fileLogo == null
                                                  ? Image.asset(
                                                      Images.placeholder,
                                                      width: Responsive.isTab()
                                                          ? 300
                                                          : 150,
                                                      height: Responsive.isTab()
                                                          ? 300
                                                          : 150,
                                                      fit: BoxFit.cover)
                                                  : Image.file(fileLogo,
                                                      width: Responsive.isTab()
                                                          ? 300
                                                          : 150,
                                                      height: Responsive.isTab()
                                                          ? 300
                                                          : 150,
                                                      fit: BoxFit.fill),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: Dimensions.PADDING_SIZE_DEFAULT,
                                      ),
                                      Column(
                                        children: [
                                          Text(getTranslated(
                                              'upload_banner_image', context)),
                                          SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_SMALL,
                                          ),
                                          InkWell(
                                            onTap: _chooseBanner,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: fileBanner == null
                                                  ? Image.asset(
                                                      Images.placeholder,
                                                      width: Responsive.isTab()
                                                          ? 300
                                                          : 150,
                                                      height: Responsive.isTab()
                                                          ? 300
                                                          : 150,
                                                      fit: BoxFit.cover)
                                                  : Image.file(fileBanner,
                                                      width: Responsive.isTab()
                                                          ? 300
                                                          : 150,
                                                      height: Responsive.isTab()
                                                          ? 300
                                                          : 150,
                                                      fit: BoxFit.fill),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          Visibility(
                            visible: true,
                            child: Container(
                                padding: EdgeInsets.only(
                                    top:
                                        Responsive.isMobile(context) ? 10 : 10),
                                margin: EdgeInsets.symmetric(
                                    horizontal: Dimensions.MARGIN_SIZE_DEFAULT,
                                    vertical: Dimensions.MARGIN_SIZE_SMALL),
                                child: !Provider.of<AuthProvider>(context)
                                        .isLoading
                                    ? CustomButton(
                                        onTap: _submitSeller,
                                        buttonText:
                                            getTranslated('SUBMIT', context))
                                    : Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Theme.of(context).primaryColor),
                                        ),
                                      )),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
