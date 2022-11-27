import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:provider/provider.dart';

class ScoreListScreen extends StatefulWidget {
  const ScoreListScreen({Key key}) : super(key: key);

  @override
  State<ScoreListScreen> createState() => _ScoreListScreenState();
}

class _ScoreListScreenState extends State<ScoreListScreen> {
  ScrollController _scrollController = ScrollController();
  int offset = 1;
  @override
  void initState() {
    super.initState();

    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    // Setup the listener.
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        if (isTop) {
          print('At the top');
        } else {
          // Get.find<UserController>().getUserPoints(offset, false).then((value) {
          //   offset++;
          // });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
