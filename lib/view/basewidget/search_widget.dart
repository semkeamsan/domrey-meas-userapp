import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/search_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatelessWidget {
  final String hintText;
  final Function onTextChanged;
  final Function onClearPressed;
  final Function onSubmit;
  SearchWidget(
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
              decoration: BoxDecoration(
                  color: ColorResources.getTextBg(context),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      topLeft: Radius.circular(5))),
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
          InkWell(
            child: Container(
                width: 70,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    color: ColorResources.getPrimary(context),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5),
                        topRight: Radius.circular(5))),
                child: Center(
                  child: Text('Search',
                      style: mulishRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Colors.white)),
                )),
            onTap: () {
              if (_controller.text.trim().isNotEmpty) {
                Provider.of<SearchProvider>(context, listen: false)
                    .saveSearchAddress(_controller.text.toString());
                Provider.of<SearchProvider>(context, listen: false)
                    .searchProduct(_controller.text.toString(), context);
              } else {
                Fluttertoast.showToast(
                    msg: getTranslated('enter_somethings', context),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('enter_somethings'), backgroundColor: ColorResources.getRed(context)));
              }
            },
          ),
          SizedBox(
            width: Dimensions.PADDING_SIZE_LARGE,
          )

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
