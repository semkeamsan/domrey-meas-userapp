import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';

class Responsive {
  static bool isMobilePhone() {
    if (!kIsWeb) {
      return true;
    } else {
      return false;
    }
  }

  static bool isWeb() {
    return kIsWeb;
  }

  static bool isMobile(context) {
    final size = MediaQuery.of(context).size.width;
    if (size < 650 || !kIsWeb) {
      return true;
    } else {
      return false;
    }
  }

  static bool isTab() {
    final size = MediaQuery.of(Get.context).size.width;
    if (size < 1300 && size >= 650) {
      return true;
    } else {
      return false;
    }
  }

  static bool isDesktop() {
    final size = MediaQuery.of(Get.context).size.width;
    if (size >= 1300) {
      return true;
    } else {
      return false;
    }
  }
}
