import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/search_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class SearchWidget2 extends StatelessWidget {
  final String hintText;
  final Function onTextChanged;
  final Function onClearPressed;
  final Function onSubmit;
  SearchWidget2(
      {@required this.hintText,
      this.onTextChanged,
      @required this.onClearPressed,
      this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController(
        text: Provider.of<SearchProvider>(context).searchText);
    return Stack(children: [
      ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
        child: Image.asset(
          Images.toolbar_background,
          fit: BoxFit.fill,
          height: 50 + MediaQuery.of(context).padding.top,
          width: MediaQuery.of(context).size.width,
          color: Provider.of<ThemeProvider>(context).darkTheme
              ? Colors.black
              : ColorResources.getPrimary(context),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        padding: EdgeInsets.only(
          bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL,
          top: Dimensions.PADDING_SIZE_EXTRA_SMALL,
        ),
        height: 50,
        alignment: Alignment.center,
        child: Row(children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),

          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                  color: ColorResources.getTextBg(context),
                  borderRadius: BorderRadius.circular(8.0)),
              child: TextFormField(
                controller: _controller,
                onFieldSubmitted: (query) {
                  if (onSubmit != null) {
                    onSubmit(query);
                  }
                },
                onChanged: (query) {
                  if (onTextChanged != null) {
                    onTextChanged(query);
                  }
                },
                textInputAction: TextInputAction.search,
                maxLines: 1,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: hintText,
                  isDense: true,
                  hintStyle: mulishRegular.copyWith(
                      color: Theme.of(context).hintColor),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search,
                      color: Provider.of<ThemeProvider>(context).darkTheme
                          ? Colors.black
                          : ColorResources.getPrimary(context),
                      size: Dimensions.iconSizeDefault),
                  suffixIcon:
                      Provider.of<SearchProvider>(context).searchText.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear,
                                  color: ColorResources.getChatIcon(context)),
                              onPressed: () {
                                onClearPressed();
                                _controller.clear();
                              },
                            )
                          : _controller.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Provider.of<ThemeProvider>(context)
                                            .darkTheme
                                        ? Colors.black
                                        : ColorResources.getPrimary(context),
                                  ),
                                  onPressed: () {
                                    onClearPressed();
                                    _controller.clear();
                                  },
                                )
                              : null,
                ),
              ),
            ),
          ),

          // IconButton(
          //   color: ColorResources.RED,
          //   icon: Icon(Icons.search, size: 20, color: Colors.white),
          //   onPressed: () => Navigator.of(context).pop(),
          // ),
        ]),
      ),
    ]);
  }
}
