import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/widget/otp_verification_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/widget/reset_password_widget.dart';

enum SMSModelState { loading, loaded }

class SMSModel extends ChangeNotifier {
  var _state = SMSModelState.loaded;
  SMSModelState get state => _state;
  String _verificationId = '';
  String _smsCode = '';
  String get smsCode => _smsCode;
  FirebaseAuth _auth = FirebaseAuth.instance;
  // String _phoneNumber = '';
  // String get phoneNumber => _phoneNumber;

  /// Update state
  void _updateState(state) {
    _state = state;
    notifyListeners();
  }

  Future<void> sendOTP({
    BuildContext context,
    Function onMessage,
    String tempToken,
    String phoneNumber,
    String password,
  }) async {
    print("CheckUserPhoneNumber1 $phoneNumber");
    _updateState(SMSModelState.loading);
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (auth.PhoneAuthCredential credential) async {
          _smsCode = credential.smsCode;
          _updateState(SMSModelState.loaded);
          // onVerify();
          // await smsVerify(_phoneNumber);
        },
        verificationFailed: (auth.FirebaseAuthException e) {
          print("CheckUserPhoneNumber2 ${e.phoneNumber} ${e.message}");
          onMessage(e.message);
        },
        codeSent: (String verificationId, int resendToken) {
          print("CheckUserPhoneNumber3 $verificationId");
          _verificationId = verificationId;
          print('tempTokentempToken $tempToken');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => VerificationScreen(
                  tempToken: tempToken,
                  mobileNumber: phoneNumber,
                  email: null,
                  password: password,
                  verificationId: _verificationId,
                ),
              ),
              (route) => false);

          _updateState(SMSModelState.loaded);
        },
        // timeout: Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (error) {
      _updateState(SMSModelState.loaded);
      print("CHeckPhoneVerify3");

      print(errorMessage(error));
      onMessage(error.message);
      if (errorMessage(error) != null) {
        return Future.error(errorMessage(error));
      }
    }
  }

  String errorMessage(FirebaseAuthException error) {
    String errorMessage;
    switch (error.code) {
      case "ERROR_INVALID_EMAIL":
        errorMessage = "Your email address appears to be malformed.";
        break;
      case "ERROR_WRONG_PASSWORD":
        errorMessage = "Your password is wrong.";
        break;
      case "ERROR_USER_NOT_FOUND":
        errorMessage = "User with this email doesn't exist.";
        break;
      case "ERROR_USER_DISABLED":
        errorMessage = "User with this email has been disabled.";
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        errorMessage = "Too many requests. Try again later.";
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }

    return errorMessage;
  }

  Future<bool> smsVerify(String _phoneNumber, String _smsCode,
      String verificationId, Function callback) async {
    _updateState(SMSModelState.loading);
    try {
      print("CheckUserPhoneNumber $verificationId");
      final credential = auth.PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: _smsCode);
      final user = await loginFirebaseCredential(credential: credential);
      if (user != null) {
        _phoneNumber = _phoneNumber.replaceAll('+', '').replaceAll(' ', '');
        callback(null);
        return true;
      }
    } on auth.FirebaseAuthException catch (err) {
      callback(err.message);
      print("Error Firebase ${err.message}");
      // showMessage(err.code);
    }
    _updateState(SMSModelState.loaded);
    return false;
  }

  Future<User> loginFirebaseCredential({credential}) async {
    return (await _auth.signInWithCredential(credential)).user;
  }

  // void updatePhoneNumber(val) {
  //   _phoneNumber = val;
  //   notifyListeners();
  // }

  void updateSMSCode(val) {
    _smsCode = val;
    notifyListeners();
  }
}
