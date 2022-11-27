import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/localization_provider.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DateConverter {
  static String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(dateTime);
  }

  static String estimatedDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static DateTime convertStringToDatetime(String dateTime) {
    return DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateTime);
  }

  static DateTime isoStringToLocalDate(String dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime).toLocal();
  }

  static String localDateToIsoStringAMPM(DateTime dateTime) {
    return DateFormat(
            'h:mm a | dd-MMM-yyyy ',
            Provider.of<LocalizationProvider>(Get.context, listen: false)
                .locale
                .languageCode)
        .format(dateTime.toLocal());
  }

  static String isoStringToLocalTimeOnly(String dateTime) {
    return DateFormat('HH:mm').format(isoStringToLocalDate(dateTime));
  }

  static String isoStringToLocalDateOnly(String dateTime) {
    return DateFormat('dd:MM:yy').format(isoStringToLocalDate(dateTime));
  }

  static String localDateToIsoString(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime.toLocal());
  }

  static String isoStringToLocalDateAndTime(String dateTime) {
    return DateFormat('dd-MMM-yyyy hh:mm a')
        .format(isoStringToLocalDate(dateTime));
  }
}
