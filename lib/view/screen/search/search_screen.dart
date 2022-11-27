import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/helper/responsive.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/search_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/search_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/search/widget/search_product_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<SearchProvider>(context, listen: false).cleanSearchProduct();
    Provider.of<SearchProvider>(context, listen: false).initHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).highlightColor,
        elevation: 0,
        toolbarHeight: 5,
      ),
      body: Column(
        children: [
          // for tool bar
          Container(
            child: SearchWidget(
              hintText: getTranslated('SEARCH_HINT', context),
              onSubmit: (String text) {
                if (text.trim().isEmpty) {
                  Fluttertoast.showToast(
                      msg: getTranslated('enter_somethings', context),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('enter_somethings'), backgroundColor: ColorResources.getRed(context)));

                } else {
                  Provider.of<SearchProvider>(context, listen: false)
                      .searchProduct(text, context);
                  Provider.of<SearchProvider>(context, listen: false)
                      .saveSearchAddress(text);
                }
              },
              onClearPressed: () =>
                  Provider.of<SearchProvider>(context, listen: false)
                      .cleanSearchProduct(),
            ),
          ),

          Consumer<SearchProvider>(
            builder: (context, searchProvider, child) {
              return !searchProvider.isClear
                  ? searchProvider.searchProductList != null
                      ? searchProvider.searchProductList.length > 0
                          ? Expanded(
                              child: SearchProductWidget(
                                  products: searchProvider.searchProductList,
                                  isViewScrollable: true),
                            )
                          : Expanded(
                              child:
                                  NoInternetOrDataScreen(isNoInternet: false),
                            )
                      : Expanded(
                          child: ProductShimmer(
                              isHomePage: false,
                              isEnabled: Provider.of<SearchProvider>(context)
                                      .searchProductList ==
                                  null),
                        )
                  : searchProvider.historyList.length > 0
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(getTranslated('SEARCH_HISTORY', context),
                                      style: mulishRegular),
                                  InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {
                                        Provider.of<SearchProvider>(context,
                                                listen: false)
                                            .clearSearchAddress();
                                      },
                                      child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            getTranslated('REMOVE', context),
                                            style: mulishRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          )))
                                ],
                              ),
                              Consumer<SearchProvider>(
                                builder: (context, searchProvider, child) =>
                                    Wrap(
                                  children: List.generate(
                                    searchProvider.historyList.length,
                                    ((index) {
                                      return InkWell(
                                        onTap: () {
                                          Provider.of<SearchProvider>(context,
                                                  listen: false)
                                              .searchProduct(
                                                  searchProvider
                                                      .historyList[index],
                                                  context);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 3.0, horizontal: 3.0),
                                          padding: EdgeInsets.symmetric(
                                              vertical: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL,
                                              horizontal: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: ColorResources.getGrey(
                                                  context)),
                                          child: Text(
                                            Provider.of<SearchProvider>(context,
                                                        listen: false)
                                                    .historyList[index] ??
                                                "",
                                            style: mulishRegular.copyWith(
                                                fontSize: Responsive.isMobile(
                                                        context)
                                                    ? Dimensions.fontSizeDefault
                                                    : Dimensions.fontSizeLarge),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 0,
                        );
            },
          ),
        ],
      ),
    );
  }
}
