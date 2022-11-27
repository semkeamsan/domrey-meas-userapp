import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/brand_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/top_seller_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/brand_and_category_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/topSeller/top_seller_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TopSellerView extends StatelessWidget {
  final bool isHomePage;
  TopSellerView({@required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Consumer<TopSellerProvider>(
      builder: (context, topSellerProvider, child) {
        return topSellerProvider.topSellerList.length != 0
            ? isHomePage
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: (1 / 1.3),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 5,
                    ),
                    itemCount: topSellerProvider.topSellerList.length != 0
                        ? isHomePage
                            ? topSellerProvider.topSellerList.length > 8
                                ? 8
                                : topSellerProvider.topSellerList.length
                            : topSellerProvider.topSellerList.length
                        : 8,
                    shrinkWrap: true,
                    physics: isHomePage
                        ? NeverScrollableScrollPhysics()
                        : BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => TopSellerProductScreen(
                                      topSeller: topSellerProvider
                                          .topSellerList[index])));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width:
                                      (MediaQuery.of(context).size.width / 4.9),
                                  height:
                                      (MediaQuery.of(context).size.width / 4.9),
                                  padding: EdgeInsets.all(Dimensions
                                      .PADDING_SIZE_EXTRA_EXTRA_SMALL),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).highlightColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.grey.withOpacity(0.15),
                                            blurRadius: 5,
                                            spreadRadius: 1)
                                      ]),
                                  child: ClipOval(
                                      child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xff7c94b6),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.shopImageUrl + '/' + topSellerProvider.topSellerList[index].image}'),
                                        fit: BoxFit.cover,
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            ColorResources.getPrimary(context),
                                        width: 7,
                                      ),
                                    ),
                                  )),
                                ),
                                SizedBox(
                                  height:
                                      (MediaQuery.of(context).size.width / 4) *
                                          0.3,
                                  child: Center(
                                      child: Text(
                                    topSellerProvider.topSellerList[index].name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: mulishRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: (1 / 1.3),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 5,
                    ),
                    itemCount: topSellerProvider.topSellerList.length != 0
                        ? isHomePage
                            ? topSellerProvider.topSellerList.length > 8
                                ? 8
                                : topSellerProvider.topSellerList.length
                            : topSellerProvider.topSellerList.length
                        : 8,
                    shrinkWrap: true,
                    physics: isHomePage
                        ? NeverScrollableScrollPhysics()
                        : BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BrandAndCategoryProductScreen(
                                        isBrand: true,
                                        id: topSellerProvider
                                            .topSellerList[index].id
                                            .toString(),
                                        name: topSellerProvider
                                            .topSellerList[index].name,
                                        image: topSellerProvider
                                            .topSellerList[index].image,
                                      )));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
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
                                          '${Provider.of<SplashProvider>(context, listen: false).baseUrls.shopImageUrl + '/' + topSellerProvider.topSellerList[index].image}'),
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
                            SizedBox(
                              height:
                                  (MediaQuery.of(context).size.width / 4) * 0.3,
                              child: Center(
                                  child: Text(
                                topSellerProvider.topSellerList[index].name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: mulishRegular.copyWith(
                                    fontSize: Dimensions.fontSizeDefault),
                              )),
                            ),
                          ],
                        ),
                      );
                    },
                  )
            : BrandShimmer(isHomePage: isHomePage);
      },
    );
  }
}

class BrandShimmer extends StatelessWidget {
  final bool isHomePage;
  BrandShimmer({@required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: (1 / 1.3),
        mainAxisSpacing: 10,
        crossAxisSpacing: 5,
      ),
      itemCount: isHomePage ? 8 : 30,
      shrinkWrap: true,
      physics: isHomePage ? NeverScrollableScrollPhysics() : null,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          enabled:
              Provider.of<TopSellerProvider>(context).topSellerList.length == 0,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        color: ColorResources.WHITE, shape: BoxShape.circle))),
            Container(
                height: 10,
                color: ColorResources.WHITE,
                margin: EdgeInsets.only(left: 25, right: 25)),
          ]),
        );
      },
    );
  }
}
