import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/login_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/textfield/custom_password_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/textfield/custom_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/forget_password_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/widget/code_picker_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/widget/mobile_verify_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/widget/social_login_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

import 'otp_verification_screen.dart';

class SignInWidget extends StatefulWidget {
  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  TextEditingController _emailController;
  TextEditingController _phoneController;
  TextEditingController _passwordController;
  GlobalKey<FormState> _formKeyLogin;
  String _countryDialCode = "+855";

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController.text =
        Provider.of<AuthProvider>(context, listen: false).getUserEmail() ??
            null;
    _passwordController.text =
        Provider.of<AuthProvider>(context, listen: false).getUserPassword() ??
            null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  FocusNode _emailNode = FocusNode();
  FocusNode _passNode = FocusNode();
  LoginModel loginBody = LoginModel();

  void loginUser() async {
    if (_formKeyLogin.currentState.validate()) {
      _formKeyLogin.currentState.save();

      String _email = _countryDialCode + _phoneController.text;
      String _password = _passwordController.text.trim();

      if (_phoneController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('PHONE_MUST_BE_REQUIRED', context)),
          backgroundColor: Colors.red,
        ));
      } else if (_password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('PASSWORD_MUST_BE_REQUIRED', context)),
          backgroundColor: Colors.red,
        ));
      } else {
        if (Provider.of<AuthProvider>(context, listen: false).isRemember) {
          Provider.of<AuthProvider>(context, listen: false)
              .saveUserEmail(_email, _password);
        } else {
          Provider.of<AuthProvider>(context, listen: false)
              .clearUserEmailAndPassword();
        }

        loginBody.email = _email;
        loginBody.password = _password;
        await Provider.of<AuthProvider>(context, listen: false)
            .login(loginBody, route);
      }
    }
  }

  route(bool isRoute, String token, String temporaryToken,
      String errorMessage) async {
    if (isRoute) {
      if (token == null || token.isEmpty) {
        if (Provider.of<SplashProvider>(context, listen: false)
            .configModel
            .emailVerification) {
          Provider.of<AuthProvider>(context, listen: false)
              .checkEmail(_emailController.text.toString(), temporaryToken)
              .then((value) async {
            if (value.isSuccess) {
              Provider.of<AuthProvider>(context, listen: false)
                  .updateEmail(_emailController.text.toString());
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => VerificationScreen(
                            tempToken: temporaryToken,
                            mobileNumber: _phoneController.text.toString(),
                            email: _emailController.text.toString(),
                            password: _passwordController.text.toString(),
                            verificationId: null,
                          )),
                  (route) => false);
            }
          });
        } else if (Provider.of<SplashProvider>(context, listen: false)
            .configModel
            .phoneVerification) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (_) => MobileVerificationScreen(temporaryToken,
                      "signIn", _passwordController.text.toString())),
              (route) => false);
        }
      } else {
        await Provider.of<ProfileProvider>(context, listen: false)
            .getUserInfo(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => DashBoardScreen()),
            (route) => false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).isRemember;
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimensions.MARGIN_SIZE_LARGE),
      child: Form(
        key: _formKeyLogin,
        child: ListView(
          padding:
              EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
          children: [
            // Container(
            //     margin: EdgeInsets.only(bottom: Dimensions.MARGIN_SIZE_SMALL),
            //     child: CustomTextField(
            //       hintText: getTranslated('EMAIL', context),
            //       focusNode: _emailNode,
            //       nextNode: _passNode,
            //       textInputType: TextInputType.emailAddress,
            //       controller: _emailController,
            //     )),
            Container(
              margin: EdgeInsets.only(bottom: Dimensions.MARGIN_SIZE_DEFAULT),
              child: Row(children: [
                CodePickerWidget(
                  onChanged: (CountryCode countryCode) {
                    _countryDialCode = countryCode.dialCode;
                  },
                  initialSelection: _countryDialCode,
                  favorite: [_countryDialCode],
                  showDropDownButton: true,
                  padding: EdgeInsets.zero,
                  showFlagMain: true,
                  textStyle: TextStyle(
                    color: Theme.of(context).textTheme.headline1.color,
                  ),
                ),
                Expanded(
                    child: CustomTextField(
                  hintText: getTranslated('ENTER_MOBILE_NUMBER', context),
                  controller: _phoneController,
                  isPhoneNumber: true,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.phone,
                )),
              ]),
            ),
            Container(
                margin: EdgeInsets.only(bottom: Dimensions.MARGIN_SIZE_DEFAULT),
                child: CustomPasswordTextField(
                  hintTxt: getTranslated('PASSWORD', context),
                  textInputAction: TextInputAction.done,
                  focusNode: _passNode,
                  controller: _passwordController,
                )),
            Container(
              margin: EdgeInsets.only(right: Dimensions.MARGIN_SIZE_SMALL),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, child) => Checkbox(
                          checkColor: ColorResources.WHITE,
                          activeColor: Theme.of(context).primaryColor,
                          value: authProvider.isRemember,
                          onChanged: authProvider.updateRemember,
                        ),
                      ),
                      Text(getTranslated('REMEMBER', context),
                          style: mulishRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: ColorResources.getPrimary(context))),
                    ],
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ForgetPasswordScreen())),
                    child: Text(getTranslated('FORGET_PASSWORD', context),
                        style: mulishRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: ColorResources.BLACK)),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  bottom: Dimensions.MARGIN_SIZE_DEFAULT,
                  top: Dimensions.MARGIN_SIZE_DEFAULT),
              child: Provider.of<AuthProvider>(context).isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  : CustomButton(
                      onTap: loginUser,
                      buttonText: getTranslated('SIGN_IN', context)),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
            SocialLoginWidget(),
            SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
            Provider.of<SplashProvider>(context, listen: false)
                        .configModel
                        .guestMode ==
                    true
                ? Center(
                    child: Text(getTranslated('OR', context),
                        style: mulishRegular.copyWith(
                            fontSize: Dimensions.fontSizeDefault)))
                : SizedBox(),
            Provider.of<SplashProvider>(context, listen: false)
                        .configModel
                        .guestMode ==
                    true
                ? GestureDetector(
                    onTap: () {
                      if (!Provider.of<AuthProvider>(context, listen: false)
                          .isLoading) {
                        Provider.of<CartProvider>(context, listen: false)
                            .getCartData();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DashBoardScreen()),
                            (route) => false);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: Dimensions.MARGIN_SIZE_AUTH,
                          right: Dimensions.MARGIN_SIZE_AUTH,
                          top: Dimensions.MARGIN_SIZE_AUTH_SMALL),
                      width: double.infinity,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(getTranslated('CONTINUE_AS_GUEST', context),
                          style: mulishHeader.copyWith(
                              color: ColorResources.getPrimary(context))),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
