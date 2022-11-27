import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';

class NetworkInfo {
  final Connectivity connectivity;
  NetworkInfo(this.connectivity);

   Future<bool> get isConnected async {
    ConnectivityResult _result = await connectivity.checkConnectivity();
    return _result != ConnectivityResult.none;
  }

  static void checkConnectivity(BuildContext context) {
    bool _firstTime = true;
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if(!_firstTime) {
        //bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        bool isNotConnected;
        if(result == ConnectivityResult.none) {
          isNotConnected = true;
        }else {
          isNotConnected = !await _updateConnectivityStatus();
        }
        isNotConnected ? SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        showCustomSnackBar(isNotConnected ? getTranslated('no_connection', context) : getTranslated('connected', context),context);
      
      }
      _firstTime = false;
    });
  }

  static Future<bool> _updateConnectivityStatus() async {
     bool _isConnected;
     try {
       final List<InternetAddress> _result = await InternetAddress.lookup('google.com');
       if(_result.isNotEmpty && _result[0].rawAddress.isNotEmpty) {
         _isConnected = true;
       }
     }catch(e) {
       _isConnected = false;
     }
     return _isConnected;
  }
}
