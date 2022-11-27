import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/helper/responsive.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wishlist_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/product_image_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/favourite_button.dart';
import 'package:provider/provider.dart';

class ProductImageView extends StatelessWidget {
  final Product productModel;
  ProductImageView({@required this.productModel});

  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ProductImageScreen(
                  imageList: productModel.images, title: productModel.name))),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              gradient: Provider.of<ThemeProvider>(context, listen: false)
                      .darkTheme
                  ? null
                  : LinearGradient(
                      colors: [ColorResources.WHITE, ColorResources.IMAGE_BG],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            ),
            child: Stack(children: [
              SizedBox(
                height: MediaQuery.of(context).size.width - 100,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: productModel.images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      // padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
                      child: CachedNetworkImage(
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.contain,
                        imageUrl:
                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${productModel.images[index]}',
                        placeholder: (c, o) => Image.asset(
                          Images.placeholder,
                          height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  onPageChanged: (index) {
                    Provider.of<ProductDetailsProvider>(context, listen: false)
                        .setImageSliderSelectedIndex(index);
                  },
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _indicators(context),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: FavouriteButton(
                  backgroundColor: ColorResources.WHITE,
                  favColor: ColorResources.getPrimary(context),
                  isSelected:
                      Provider.of<WishListProvider>(context, listen: false)
                          .isWish,
                  productId: productModel.id,
                ),
              ),
            ]),
          ),
        ),

        // Image List
        Container(
          height: Responsive.isMobile(context) ? 60 : 120,
          margin: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          alignment: Alignment.center,
          child: ListView.builder(
            itemCount: productModel.images.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _controller.animateToPage(index,
                      duration: Duration(microseconds: 300),
                      curve: Curves.easeInOut);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).highlightColor,
                    border: Provider.of<ProductDetailsProvider>(context)
                                .imageSliderIndex ==
                            index
                        ? Border.all(
                            color: ColorResources.getPrimary(context), width: 2)
                        : null,
                  ),
                  //  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: CachedNetworkImage(
                    height: Responsive.isMobile(context) ? 50 : 100,
                    width: Responsive.isMobile(context) ? 50 : 100,
                    fit: BoxFit.cover,
                    imageUrl:
                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${productModel.images[index]}',
                    placeholder: (c, o) => Image.asset(
                      Images.placeholder,
                      fit: BoxFit.cover,
                      height: Responsive.isMobile(context) ? 50 : 100,
                      width: Responsive.isMobile(context) ? 50 : 100,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _indicators(BuildContext context) {
    List<Widget> indicators = [];
    for (int index = 0; index < productModel.images.length; index++) {
      indicators.add(TabPageSelectorIndicator(
        backgroundColor: index ==
                Provider.of<ProductDetailsProvider>(context).imageSliderIndex
            ? Theme.of(context).primaryColor
            : ColorResources.WHITE,
        borderColor: ColorResources.WHITE,
        size: Responsive.isMobile(context)
            ? Dimensions.iconSizeSmall
            : Dimensions.iconSizeSmall,
      ));
    }
    return indicators;
  }
}
