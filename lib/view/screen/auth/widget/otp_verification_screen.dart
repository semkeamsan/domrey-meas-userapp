import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/login_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/sms_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/auth_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/widget/reset_password_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatelessWidget {
  final String tempToken;
  final String mobileNumber;
  final String email;
  final String password;
  final String verificationId;
  VerificationScreen(
      {@required this.tempToken,
      @required this.mobileNumber,
      @required this.email,
      @required this.password,
      @required this.verificationId});

  @override
  Widget build(BuildContext context) {
    void alertMessage(message) {
      showCustomSnackBar(message, context);
    }

    route(bool isRoute, String token, String temporaryToken,
        String errorMessage) async {
      if (isRoute) {
        if (token == null || token.isEmpty) {
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

    LoginModel loginBody = LoginModel();
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: 1170,
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 55),
                      Image.asset(
                        Images.otp_image,
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Center(
                            child: Text(
                          email == null
                              ? '${getTranslated('please_enter_6_digit_code', context)}\n$mobileNumber'
                              : '${getTranslated('please_enter_6_digit_code', context)}\n$email',
                          style: mulishRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                          ),
                          textAlign: TextAlign.center,
                        )),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 39,
                          vertical: Dimensions.PADDING_SIZE_SMALL,
                        ),
                        child: PinCodeTextField(
                          textStyle: mulishRegular.copyWith(
                            color: ColorResources.getSecondaryText(context),
                            fontSize: Dimensions.fontSizeExtraLarge,
                          ),
                          length: 6,
                          appContext: context,
                          obscureText: false,
                          showCursor: true,
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            fieldHeight: 63,
                            fieldWidth: 55,
                            borderWidth: 1,
                            borderRadius: BorderRadius.circular(10),
                            selectedColor: ColorResources.colorMap[200],
                            selectedFillColor:
                                ColorResources.hintTextBoxColor(context),
                            inactiveFillColor:
                                ColorResources.hintTextBoxColor(context),
                            inactiveColor: ColorResources.colorMap[200],
                            activeColor: ColorResources.colorMap[400],
                            activeFillColor:
                                ColorResources.hintTextBoxColor(context),
                          ),
                          animationDuration: Duration(milliseconds: 300),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          onChanged: authProvider.updateVerificationCode,
                          beforeTextPaste: (text) {
                            return true;
                          },
                        ),
                      ),
                      Center(
                          child: Text(
                        getTranslated('i_didnt_receive_the_code', context),
                      )),
                      Center(
                        child: InkWell(
                          onTap: () {
                            SMSModel().sendOTP(
                              context: context,
                              onMessage: alertMessage,
                              tempToken: tempToken,
                              phoneNumber: mobileNumber,
                              password: password,
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(
                                Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Text(
                              getTranslated('resend_code', context),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 48),
                      authProvider.isEnableVerificationCode
                          ? !authProvider.isPhoneNumberVerificationButtonLoading
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          Dimensions.PADDING_SIZE_LARGE),
                                  child: CustomButton(
                                    buttonText:
                                        getTranslated('verify', context),
                                    onTap: () {
                                      bool phoneVerification =
                                          Provider.of<SplashProvider>(context,
                                                      listen: false)
                                                  .configModel
                                                  .forgetPasswordVerification ==
                                              'phone';

                                      if (phoneVerification &&
                                              password == null ||
                                          password.isEmpty) {
                                        Provider.of<AuthProvider>(context,
                                                listen: false)
                                            .verifyOtp(
                                                mobileNumber, verificationId)
                                            .then((value) {
                                          if (value.isSuccess) {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      ResetPasswordWidget(
                                                    mobileNumber: mobileNumber,
                                                    tempToken: tempToken,
                                                  ),
                                                ),
                                                (route) => false);
                                          } else {
                                            showCustomSnackBar(
                                                getTranslated(
                                                    'input_valid_otp', context),
                                                context);
                                          }
                                        });
                                      } else {
                                        if (Provider.of<SplashProvider>(context,
                                                listen: false)
                                            .configModel
                                            .phoneVerification) {
                                          authProvider
                                              .verifyPhone(
                                            mobileNumber,
                                            tempToken,
                                            verificationId,
                                          )
                                              .then((value) {
                                            if (value.isSuccess) {
                                              loginBody.email = mobileNumber;
                                              loginBody.password = password;
                                              Provider.of<AuthProvider>(context,
                                                      listen: false)
                                                  .login(loginBody, route);

                                              // ScaffoldMessenger.of(context)
                                              //     .showSnackBar(SnackBar(
                                              //   content: Text(getTranslated(
                                              //       'sign_up_successfully_now_login',
                                              //       context)),
                                              //   backgroundColor: Colors.green,
                                              // ));
                                              // Navigator.pushAndRemoveUntil(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (_) =>
                                              //             AuthScreen(
                                              //                 initialPage: 0)),
                                              //     (route) => false);
                                            } else {
                                              showCustomSnackBar(
                                                  value.message, context);
                                            }
                                          });
                                        } else {
                                          Provider.of<AuthProvider>(context,
                                                  listen: false)
                                              .verifyEmail(email, tempToken)
                                              .then((value) {
                                            if (value.isSuccess) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(getTranslated(
                                                    'sign_up_successfully_now_login',
                                                    context)),
                                                backgroundColor: Colors.green,
                                              ));
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          AuthScreen(
                                                              initialPage: 0)),
                                                  (route) => false);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content:
                                                          Text(value.message),
                                                      backgroundColor:
                                                          Colors.red));
                                            }
                                          });
                                        }
                                      }
                                    },
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor)))
                          : SizedBox.shrink()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
