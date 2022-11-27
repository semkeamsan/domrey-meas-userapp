import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/category_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/top_seller_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/topSeller/top_seller_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TopSellerView2 extends StatelessWidget {
  final bool isHomePage;
  TopSellerView2({@required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Consumer<TopSellerProvider>(
      builder: (context, topSellerProvider, child) {
        return topSellerProvider.topSellerList != null
            ? topSellerProvider.topSellerList.length != 0
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    itemCount:
                        isHomePage && topSellerProvider.topSellerList.length > 4
                            ? 4
                            : topSellerProvider.topSellerList.length,
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
                          padding: EdgeInsets.only(right: 10),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      (MediaQuery.of(context).size.width / 5.9),
                                  height:
                                      (MediaQuery.of(context).size.width / 5.9),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            (MediaQuery.of(context).size.width /
                                                5))),
                                    color: Theme.of(context).highlightColor,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            (MediaQuery.of(context).size.width /
                                                5))),
                                    // child: FadeInImage.assetNetwork(
                                    //   fit: BoxFit.cover,
                                    //   placeholder: Images.placeholder,
                                    //   image: Provider.of<SplashProvider>(context,listen: false).baseUrls.brandImageUrl+'/'+brandProvider.brandList[index].image,
                                    //   imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,  fit: BoxFit.cover,),
                                    // ),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        border: Border.all(
                                          color: ColorResources.getPrimary(
                                              context),
                                          width: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: Center(
                                      child: Text(
                                    topSellerProvider.topSellerList[index].name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: mulishRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // child: Column(
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     Expanded(
                        //       child: Container(
                        //         width:
                        //             (MediaQuery.of(context).size.width / 5.9),
                        //         height:
                        //             (MediaQuery.of(context).size.width / 8.9),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.all(
                        //               Radius.circular(
                        //                   (MediaQuery.of(context).size.width /
                        //                       5))),
                        //           color: Theme.of(context).highlightColor,

                        //           // boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 5, spreadRadius: 1)]
                        //         ),
                        //         child: ClipRRect(
                        //             borderRadius: BorderRadius.all(
                        //                 Radius.circular(
                        //                     (MediaQuery.of(context).size.width /
                        //                         5))),
                        //             // child: FadeInImage.assetNetwork(
                        //             //   fit: BoxFit.cover,
                        //             //   placeholder: Images.placeholder,
                        //             //   image: Provider.of<SplashProvider>(context,listen: false).baseUrls.shopImageUrl+'/'+topSellerProvider.topSellerList[index].image,
                        //             //   imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_1x1, fit: BoxFit.cover,),
                        //             // ),
                        //             child: Container(
                        //               width: 100,
                        //               height: 50,
                        //               decoration: BoxDecoration(
                        //                 color: const Color(0xff7c94b6),
                        //                 image: DecorationImage(
                        //                   image: NetworkImage(
                        //                       '${Provider.of<SplashProvider>(context, listen: false).baseUrls.shopImageUrl + '/' + topSellerProvider.topSellerList[index].image}'),
                        //                   fit: BoxFit.cover,
                        //                 ),
                        //                 borderRadius: BorderRadius.all(
                        //                     Radius.circular(50.0)),
                        //                 border: Border.all(
                        //                   color: ColorResources.getPrimary(
                        //                       context),
                        //                   width: 8,
                        //                 ),
                        //               ),
                        //             )),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      );
                    },
                  )
                : SizedBox()
            : TopSellerShimmer();
      },
    );
  }
}

class TopSellerShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: (1 / 1),
      ),
      itemCount: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.grey[
                    Provider.of<ThemeProvider>(context, listen: false).darkTheme
                        ? 700
                        : 200],
                spreadRadius: 2,
                blurRadius: 5)
          ]),
          margin: EdgeInsets.all(3),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
              flex: 7,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                enabled: Provider.of<TopSellerProvider>(context)
                        .topSellerList
                        .length ==
                    0,
                child: Container(
                    decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                )),
              ),
            ),
            Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorResources.getTextBg(context),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100],
                    enabled: Provider.of<CategoryProvider>(context)
                            .categoryList
                            .length ==
                        0,
                    child: Container(
                        height: 10,
                        color: Colors.white,
                        margin: EdgeInsets.only(left: 15, right: 15)),
                  ),
                )),
          ]),
        );
      },
    );
  }
}
