import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/seller_model.dart';

import 'package:flutter_sixvalley_ecommerce/helper/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/seller_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/guest_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/chat_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/widget/products_view.dart';
import 'package:provider/provider.dart';

class SellerScreen extends StatefulWidget {
  final SellerModel seller;
  SellerScreen({@required this.seller});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  ScrollController _scrollController = ScrollController();

  void _load() {
    Provider.of<ProductProvider>(context, listen: false).removeFirstLoading();
    Provider.of<ProductProvider>(context, listen: false).clearSellerData();
    Provider.of<ProductProvider>(context, listen: false)
        .initSellerProductList(widget.seller.seller.id.toString(), 1, context);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    String ratting = widget.seller != null && widget.seller.avgRating != null
        ? widget.seller.avgRating.toString()
        : "0";

    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Column(
        children: [
          CustomAppBar(
              title: '${widget.seller.seller.fName}' +
                  ' ' '${widget.seller.seller.lName}'),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_SMALL),
              child: ListView(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(0),
                children: [
                  // Banner
                  Padding(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage.assetNetwork(
                        placeholder: Images.placeholder,
                        height: 200,
                        fit: BoxFit.cover,
                        image:
                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.shopImageUrl}/banner/${widget.seller.seller.shop != null ? widget.seller.seller.shop.banner : ''}',
                        imageErrorBuilder: (c, o, s) => Image.asset(
                            Images.placeholder,
                            height: 200,
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: Column(children: [
                      // Seller Info
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(10),
                            //       color: Theme.of(context).highlightColor,
                            //       boxShadow: [
                            //         BoxShadow(
                            //             color: Colors.grey.withOpacity(0.3),
                            //             spreadRadius: 1,
                            //             blurRadius: 5)
                            //       ]),
                            //   child: ClipRRect(
                            //     borderRadius: BorderRadius.circular(
                            //         Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            //     child: FadeInImage.assetNetwork(
                            //       placeholder: Images.placeholder,
                            //       height: 80,
                            //       width: 80,
                            //       fit: BoxFit.cover,
                            //       image:
                            //           '${Provider.of<SplashProvider>(context, listen: false).baseUrls.shopImageUrl}/${widget.topSeller.image}',
                            //       imageErrorBuilder: (c, o, s) => Image.asset(
                            //           Images.placeholder,
                            //           height: 80,
                            //           width: 80,
                            //           fit: BoxFit.cover),
                            //     ),
                            //   ),
                            // ),
                            Container(
                              width: (MediaQuery.of(context).size.width / 4.9),
                              height: (MediaQuery.of(context).size.width / 4.9),
                              child: Container(
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_EXTRA_EXTRA_SMALL),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).highlightColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.15),
                                          blurRadius: 5,
                                          spreadRadius: 1)
                                    ]),
                                child: ClipOval(
                                    child: Container(
                                  width: 100,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff7c94b6),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                           '${Provider.of<SplashProvider>(context, listen: false).baseUrls.shopImageUrl}/${widget.seller.seller.shop.image}'),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    border: Border.all(
                                      color: ColorResources.getPrimary(context),
                                      width: 8,
                                    ),
                                  ),
                                )),
                              ),
                            ),
                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                            Expanded(
                              child: Consumer<SellerProvider>(
                                  builder: (context, sellerProvider, _) {
                                String ratting = sellerProvider.sellerModel !=
                                            null &&
                                        sellerProvider.sellerModel.avgRating !=
                                            null
                                    ? sellerProvider.sellerModel.avgRating
                                        .toString()
                                    : "0";

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                       widget.seller.seller.shop.name,
                                        style: mulishBold.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeLarge),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (!Provider.of<AuthProvider>(context, listen: false)
                              .isLoggedIn()) {
                            showAnimatedDialog(context, GuestDialog(),
                                isFlip: true);
                          } else if (widget.seller != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ChatScreen(seller: widget.seller)));
                          }
                        },
                        child: Image.asset(Images.chat_vector,
                            color: ColorResources.getPrimary(context),
                            height: Dimensions.iconSizeDefault),
                      ),
                                  ],
                                );
                                // sellerProvider.sellerModel != null
                                //     ? Column(
                                //         crossAxisAlignment:
                                //             CrossAxisAlignment.start,
                                //         children: [
                                //           Row(
                                //             children: [
                                //               RatingBar(
                                //                   rating:
                                //                       double.parse(ratting)),
                                //               Text(
                                //                 '(${sellerProvider.sellerModel.totalReview.toString()})',
                                //                 style: mulishRegular
                                //                     .copyWith(),
                                //                 maxLines: 1,
                                //                 overflow:
                                //                     TextOverflow.ellipsis,
                                //               ),
                                //             ],
                                //           ),
                                //           SizedBox(
                                //               height: Dimensions
                                //                   .PADDING_SIZE_SMALL),
                                //           Row(
                                //             children: [
                                //               Text(
                                //                 sellerProvider.sellerModel
                                //                         .totalReview
                                //                         .toString() +
                                //                     ' ' +
                                //                     '${getTranslated('reviews', context)}',
                                //                 style: mulishTitleRegular.copyWith(
                                //                     fontSize: Dimensions
                                //                         .FONT_SIZE_LARGE,
                                //                     color: ColorResources
                                //                         .getReviewRattingColor(
                                //                             context)),
                                //                 maxLines: 1,
                                //                 overflow:
                                //                     TextOverflow.ellipsis,
                                //               ),
                                //               SizedBox(
                                //                   width: Dimensions
                                //                       .PADDING_SIZE_DEFAULT),
                                //               Text('|'),
                                //               SizedBox(
                                //                   width: Dimensions
                                //                       .PADDING_SIZE_DEFAULT),
                                //               Text(
                                //                 sellerProvider.sellerModel
                                //                         .totalProduct
                                //                         .toString() +
                                //                     ' ' +
                                //                     '${getTranslated('products', context)}',
                                //                 style: mulishTitleRegular.copyWith(
                                //                     fontSize: Dimensions
                                //                         .FONT_SIZE_LARGE,
                                //                     color: ColorResources
                                //                         .getReviewRattingColor(
                                //                             context)),
                                //                 maxLines: 1,
                                //                 overflow:
                                //                     TextOverflow.ellipsis,
                                //               ),
                                //             ],
                                //           ),
                                //         ],
                                //       )
                                //     : SizedBox(),
                              }),
                            ),
                          ]),
                    ]),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  // Center(
                  //   child: Padding(
                  //     padding: EdgeInsets.only(
                  //         left: Dimensions.PADDING_SIZE_SMALL,
                  //         right: Dimensions.PADDING_SIZE_EXTRA_EXTRA_SMALL),
                  //     child: SearchWidget(
                  //       hintText: 'Search product...',
                  //       onTextChanged: (String newText) =>
                  //           Provider.of<ProductProvider>(context, listen: false)
                  //               .filterData(newText),
                  //       onClearPressed: () {},
                  //       isSeller: true,
                  //     ),
                  //   ),
                  // ),

                  Padding(
                    padding:
                        EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: ProductView(
                        isHomePage: false,
                        productType: ProductType.SELLER_PRODUCT,
                        scrollController: _scrollController,
                        sellerId: widget.seller.seller.id.toString()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
