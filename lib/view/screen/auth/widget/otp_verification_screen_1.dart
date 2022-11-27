// // import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_sixvalley_ecommerce/data/helper/responsive.dart';
// import 'package:flutter_sixvalley_ecommerce/data/model/body/login_model.dart';
// import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
// import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
// import 'package:flutter_sixvalley_ecommerce/provider/sms_provider.dart';
// import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
// import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
// import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
// import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
// import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
// import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
// import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
// import 'package:flutter_sixvalley_ecommerce/view/screen/auth/widget/reset_password_widget.dart';
// import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:provider/provider.dart';

// class VerificationScreen extends StatelessWidget {
//   final String tempToken;
//   final String mobileNumber;
//   final String email;
//   final String verificationId;
//   final String checkP;
//   final String password;
//   final LoginModel loginBody = LoginModel();

//   VerificationScreen(this.tempToken, this.mobileNumber, this.email,
//       this.verificationId, this.checkP, this.password);

//   @override
//   Widget build(BuildContext context) {
//     print('=======Mobile Number=====>$mobileNumber');
//     void alertMessage(title) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text(title),
//         duration: const Duration(seconds: 3),
//       ));
//     }

//     loginBody.email = mobileNumber;
//     loginBody.password = password;

//     route(bool isRoute, String token, String temporaryToken,
//         String errorMessage) async {
//       print('Route ${isRoute.toString()}');
//       print('token ${token.toString()}');
//       print('tempToken ${temporaryToken.toString()}');
//       print('error ${errorMessage.toString()}');
//       print('loginBody ${loginBody.toJson()}');
//       if (isRoute) {
//         if (token != null) {
//           print('Edit ${token}');
//           Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (_) => DashBoardScreen()),
//               (route) => false);
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
//       }
//     }

//     return Scaffold(
//       body: SafeArea(
//         child: Scrollbar(
//           child: SingleChildScrollView(
//             physics: BouncingScrollPhysics(),
//             child: Center(
//               child: SizedBox(
//                 width: 1170,
//                 child: Consumer<AuthProvider>(
//                   builder: (context, authProvider, child) => Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SizedBox(height: 55),
//                       Image.asset(
//                         Images.login,
//                         width: 100,
//                         height: 100,
//                       ),
//                       SizedBox(height: 40),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 50),
//                         child: Center(
//                             child: Text(
//                           email == null
//                               ? '${getTranslated('please_enter_6_digit_code', context)}\n$mobileNumber'
//                               : '${getTranslated('please_enter_6_digit_code', context)}\n$email',
//                           textAlign: TextAlign.center,
//                           style: mulishRegular.copyWith(
//                             fontSize: Responsive.isMobile(context)
//                                 ? Dimensions.fontSizeDefault
//                                 : Dimensions.fontSizeLarge,
//                           ),
//                         )),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: Responsive.isMobile(context) ? 40 : 100,
//                           vertical: Dimensions.PADDING_SIZE_DEFAULT,
//                         ),
//                         child: PinCodeTextField(
//                           textStyle: mulishRegular.copyWith(
//                             fontSize: Responsive.isMobile(context)
//                                 ? Dimensions.fontSizeLarge
//                                 : Dimensions.fontSizeLarge,
//                           ),
//                           length: 6,
//                           appContext: context,
//                           obscureText: false,
//                           showCursor: true,
//                           keyboardType: TextInputType.number,
//                           animationType: AnimationType.fade,
//                           pinTheme: PinTheme(
//                             shape: PinCodeFieldShape.box,
//                             fieldHeight: Responsive.isTab() ? 120 : 63,
//                             fieldWidth: Responsive.isTab() ? 100 : 45,
//                             borderWidth: 1,
//                             borderRadius: BorderRadius.circular(10),
//                             selectedColor: ColorResources.colorMap[200],
//                             selectedFillColor: Colors.white,
//                             inactiveFillColor:
//                                 ColorResources.getSearchBg(context),
//                             inactiveColor: ColorResources.colorMap[200],
//                             activeColor: ColorResources.colorMap[400],
//                             activeFillColor:
//                                 ColorResources.getSearchBg(context),
//                           ),
//                           animationDuration: Duration(milliseconds: 300),
//                           backgroundColor: Colors.transparent,
//                           enableActiveFill: true,
//                           onChanged: authProvider.updateVerificationCode,
//                           beforeTextPaste: (text) {
//                             return true;
//                           },
//                         ),
//                       ),
//                       Center(
//                         child: Text(
//                           getTranslated('i_didnt_receive_the_code', context),
//                           style: mulishRegular.copyWith(
//                             fontSize: Responsive.isMobile(context)
//                                 ? Dimensions.fontSizeDefault
//                                 : Dimensions.fontSizeLarge,
//                           ),
//                         ),
//                       ),
//                       Center(
//                         child: InkWell(
//                           onTap: () {
//                             // Provider.of<AuthProvider>(context, listen: false)
//                             //     .checkPhone(mobileNumber, tempToken)
//                             //     .then((value) {
//                             //   if (value.isSuccess) {
//                             //     showCustomSnackBar(
//                             //         'Resent code successful', context,
//                             //         isError: false);
//                             //   } else {
//                             //     showCustomSnackBar(value.message, context,
//                             //         isError: false);
//                             //   }
//                             // });
//                             SMSModel().sendOTP(context: context, onMessage: alertMessage, checkP: checkP,
//                                 tempToken: tempToken, phoneNumber: mobileNumber, password: password);
//                           },
//                           child: Padding(
//                             padding: EdgeInsets.all(
//                                 Dimensions.PADDING_SIZE_EXTRA_SMALL),
//                             child: Text(
//                               getTranslated('resend_code', context),
//                               style: mulishRegular.copyWith(
//                                 fontSize: Responsive.isMobile(context)
//                                     ? Dimensions.fontSizeDefault
//                                     : Dimensions.fontSizeLarge,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 48),
//                       authProvider.isEnableVerificationCode
//                           ? !authProvider.isPhoneNumberVerificationButtonLoading
//                               ? Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal:
//                                           Dimensions.PADDING_SIZE_LARGE),
//                                   child: CustomButton(
//                                     buttonText:
//                                         getTranslated('verify', context),
//                                     onTap: () {
//                                       String forgetPasswordVerification =
//                                           Provider.of<SplashProvider>(context,
//                                                   listen: false)
//                                               .configModel
//                                               .forgetPasswordVerification;

//                                       if (forgetPasswordVerification
//                                               .contains('phone') &&
//                                           checkP.contains("forget")) {
//                                         Provider.of<AuthProvider>(context,
//                                                 listen: false)
//                                             .verifyOtp(
//                                                 mobileNumber,
//                                                 tempToken,
//                                                 authProvider.verificationCode,
//                                                 verificationId,
//                                                 checkP)
//                                             .then((value) {
//                                           if (value.isSuccess) {
//                                             Navigator.pushAndRemoveUntil(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (_) =>
//                                                         ResetPasswordWidget(
//                                                             mobileNumber:
//                                                                 mobileNumber,
//                                                             tmpToken:
//                                                                 tempToken)),
//                                                 (route) => false);
//                                           } else {
//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(
//                                               SnackBar(
//                                                 content: Text(
//                                                   getTranslated(
//                                                       'input_invalid_otp',
//                                                       context),
//                                                   style:
//                                                       mulishRegular.copyWith(
//                                                     fontSize: Responsive
//                                                             .isMobile(context)
//                                                         ? Dimensions
//                                                             .fontSizeDefault
//                                                         : Dimensions
//                                                             .fontSizeLarge,
//                                                   ),
//                                                 ),
//                                                 backgroundColor: Colors.red,
//                                               ),
//                                             );
//                                           }
//                                         });
//                                       } else if (checkP
//                                           .contains("sellerSignUp")) {
//                                         Provider.of<AuthProvider>(context,
//                                                 listen: false)
//                                             .verifySellerOtp(
//                                                 mobileNumber,
//                                                 tempToken,
//                                                 authProvider.verificationCode,
//                                                 verificationId,
//                                                 checkP)
//                                             .then((value) {
//                                           if (value.isSuccess) {
//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(SnackBar(
//                                               content: Text(
//                                                 getTranslated(
//                                                     'sign_up_successfully',
//                                                     context),
//                                                 style:
//                                                     mulishRegular.copyWith(
//                                                   fontSize: Responsive.isMobile(
//                                                           context)
//                                                       ? Dimensions
//                                                           .fontSizeDefault
//                                                       : Dimensions
//                                                           .fontSizeLarge,
//                                                 ),
//                                               ),
//                                               backgroundColor: Colors.green,
//                                             ));
//                                             Navigator.pushAndRemoveUntil(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (_) =>
//                                                       SellerSignUpSuccessScreen(),
//                                                 ),
//                                                 (route) => false);
//                                           } else {
//                                             showCustomSnackBar(
//                                                 getTranslated(
//                                                     'input_invalid_otp',
//                                                     context),
//                                                 context);
//                                           }
//                                         });
//                                       } else {
//                                         if (Provider.of<SplashProvider>(context,
//                                                 listen: false)
//                                             .configModel
//                                             .phoneVerification) {
//                                           Provider.of<AuthProvider>(context,
//                                                   listen: false)
//                                               .verifyOtp(
//                                                   mobileNumber,
//                                                   tempToken,
//                                                   authProvider.verificationCode,
//                                                   verificationId,
//                                                   checkP)
//                                               .then((value) {
//                                             if (value.isSuccess) {
//                                               ScaffoldMessenger.of(context)
//                                                   .showSnackBar(SnackBar(
//                                                 content: Text(
//                                                   getTranslated(
//                                                       'sign_up_successfully_now_login',
//                                                       context),
//                                                   style:
//                                                       mulishRegular.copyWith(
//                                                     fontSize: Responsive
//                                                             .isMobile(context)
//                                                         ? Dimensions
//                                                             .fontSizeDefault
//                                                         : Dimensions
//                                                             .fontSizeLarge,
//                                                   ),
//                                                 ),
//                                                 backgroundColor: Colors.green,
//                                               ));
//                                               loginBody.email = mobileNumber;
//                                               loginBody.password = password;
//                                               // Navigator.pushAndRemoveUntil(
//                                               //     context,
//                                               //     MaterialPageRoute(
//                                               //       builder: (_) =>
//                                               //           DashBoardScreen(),
//                                               //     ),
//                                               //     (route) => false);
//                                               Provider.of<AuthProvider>(context,
//                                                       listen: false)
//                                                   .login(loginBody, (bool
//                                                           isRoute,
//                                                       String token,
//                                                       String temporaryToken,
//                                                       String
//                                                           errorMessage) async {
//                                                 print(
//                                                     'Route ${isRoute.toString()}');
//                                                 print(
//                                                     'token ${token.toString()}');
//                                                 print(
//                                                     'tempToken ${temporaryToken.toString()}');
//                                                 print(
//                                                     'error ${errorMessage.toString()}');
//                                                 print(
//                                                     'loginBody ${loginBody.toJson()}');
//                                                 if (isRoute) {
//                                                   if (token != null) {
//                                                     print('Edit ${token}');
//                                                     Navigator.pushAndRemoveUntil(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                             builder: (_) =>
//                                                                 DashBoardScreen()),
//                                                         (route) => false);
//                                                   }
//                                                 } else {
//                                                   ScaffoldMessenger.of(context)
//                                                       .showSnackBar(SnackBar(
//                                                           content: Text(
//                                                               errorMessage),
//                                                           backgroundColor:
//                                                               Colors.red));
//                                                 }
//                                               });
//                                             } else {
//                                               showCustomSnackBar(
//                                                   getTranslated(
//                                                       'input_invalid_otp',
//                                                       context),
//                                                   context);
//                                             }
//                                           });
//                                         }
//                                         // else {
//                                         //   Provider.of<AuthProvider>(context,
//                                         //           listen: false)
//                                         //       .verifyEmail(email, tempToken)
//                                         //       .then((value) {
//                                         //     if (value.isSuccess) {
//                                         //       ScaffoldMessenger.of(context)
//                                         //           .showSnackBar(
//                                         //         SnackBar(
//                                         //           content: Text(
//                                         //             getTranslated(
//                                         //                 'sign_up_successfully_now_login',
//                                         //                 context),
//                                         //           ),
//                                         //           backgroundColor: Colors.green,
//                                         //         ),
//                                         //       );
//                                         //       Navigator.pushAndRemoveUntil(
//                                         //           context,
//                                         //           MaterialPageRoute(
//                                         //             builder: (_) => AuthScreen(
//                                         //                 initialPage: 0),
//                                         //           ),
//                                         //           (route) => false);
//                                         //     } else {
//                                         //       ScaffoldMessenger.of(context)
//                                         //           .showSnackBar(SnackBar(
//                                         //               content:
//                                         //                   Text(value.message),
//                                         //               backgroundColor:
//                                         //                   Colors.red));
//                                         //     }
//                                         //   });
//                                         // }
//                                       }
//                                     },
//                                   ),
//                                 )
//                               : Center(
//                                   child: CircularProgressIndicator(
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                         Theme.of(context).primaryColor),
//                                   ),
//                                 )
//                           : SizedBox.shrink()
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
