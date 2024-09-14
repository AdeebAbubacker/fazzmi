
import 'package:fazzmi/presentaion/featuredProductScreen/featuredProductScreen.dart';
import 'package:fazzmi/provider/cartInStore.dart';
import 'package:fazzmi/widgets/app_bar_widget.dart';
import 'package:fazzmi/widgets/customButton2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/constants.dart';
import '../../../widgets/textInput.dart';
import '../../productDetailPage/screenProductDetailPage.dart';
import '../../mainPage/screen_main_page.dart';
import '../../mainPage/widgets/bottam_nav.dart';

class ScreenFavorite extends StatefulWidget {
  const ScreenFavorite({Key? key}) : super(key: key);

  @override
  State<ScreenFavorite> createState() => _ScreenFavoriteState();
}

class _ScreenFavoriteState extends State<ScreenFavorite> {
  dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadData(loadVar: '_isLoading');
  }

  loadData({loadVar}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<CartCounterStore>(context, listen: false).initialState();

      Provider.of<CartCounterStore>(context, listen: false)
          .fetchFavourite(loadVar: loadVar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: "Favourites",
          icon: Icons.arrow_back_ios,
        ),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        body: Column(
          children: [
            Expanded(
              child:
                  Consumer<CartCounterStore>(builder: (context, value, child) {
                if (!value.isLoad &&
                    value.wishlist != null &&
                    value.wishlist!.data!.isNotEmpty) {
                  var data = value.wishlist!.data;
                  data = data!.reversed.toList();
                  return GridView.builder(
                      shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 3 / 5,
                              crossAxisCount: 2,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 10),
                      itemCount: data.length,
                      itemBuilder: (BuildContext ctx, index) {
                        /* checking */
                        int productid =
                            int.tryParse('${data![index].productId}')!;
                        var isFavourite =
                            value.checkIsFavourite(sku: data[index].sku);

                        return FavoriteProductItemWidget(
                          storeId: int.parse(data[index].storeId),
                          parentCategoryId: data[index].parent_category_id!,
                          specialPrice: data[index].specialPrice ?? "0",
                          storeName: data[index].store_name!,
                          shopType: data[index].shop_type!,
                          sku: data[index].sku!,
                          key: ValueKey(index),
                          productid: int.parse(data[index].productId!),
                          image: data[index].image!,
                          name: data[index].sku!,
                          price: data[index].price.toString(),
                          qty: data[index].qty!,
                          value: value,
                          btnCart: false,
                          isFavourite:
                              (isFavourite != null && isFavourite.isNotEmpty)
                                  ? true
                                  : false,
                          onFavourite: () {
                            value.changeFavourite(
                                isAddFav: false, productid: productid);
                            loadData(loadVar: '_isLoading');
                          },
                        );
                      });
                } else if (value.isLoad) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Color.fromARGB(255, 203, 200, 200),
                          size: 100,
                        ),
                        const TextInput(
                          text1: "No Favourites Products",
                          colorOfText: Colors.black,
                          size: 20,
                        ),
                        height10,
                        const TextInput(
                          text1: "You haven't added any products yet",
                          colorOfText: Colors.grey,
                          size: 13,
                        ),
                        height20,
                        height10,
                        CustomButton2(
                          buttonAction: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => ScreenMainPage()),
                                (Route<dynamic> route) => false);
                            indexChangeNotifier.value = 0;
                            ChangeNotifier();
                          },
                          buttonName: "Browse Stores",
                          height: 60,
                          width: MediaQuery.of(context).size.width - 20,
                          color: primaryColor,
                          textColor: Colors.white,
                          textSize: 20,
                        ),
                        height40,
                        height40
                      ],
                    ),
                  );
                }
              }),
            ),
          ],
        ));
  }

  Widget _buildIcon(
      {required double size,
      color,
      required double top,
      required double right,
      void Function()? function}) {
    return Positioned(
      top: top,
      right: right,
      child: Container(
        height: 48,
        width: 48,
        alignment: Alignment.center,
        child: IconButton(
          onPressed: function,
          icon: Icon(
            Icons.favorite,
            color: color,
            size: size,
          ),
        ),
      ),
    );
  }
}

class FavoriteProductItemWidget extends StatelessWidget {
  const FavoriteProductItemWidget(
      {Key? key,
      required this.name,
      required this.price,
      required this.image,
      required this.qty,
      required this.productid,
      required this.value,
      this.addCart,
      this.removeCart,
      this.isAddCart = false,
      this.isFavourite = false,
      this.onFavourite,
      this.btnCart = true,
      required this.sku,
      required this.shopType,
      this.loadCart = false,
      required this.storeName,
      required this.specialPrice,
      required this.parentCategoryId,
      required this.storeId})
      : super(key: key);

  final String name, storeName;

  final String price, specialPrice, parentCategoryId;
  final String image;
  final String shopType;
  final int qty, storeId;
  final String sku;
  final dynamic productid;
  final CartCounterStore value;
  final void Function()? addCart;
  final void Function()? removeCart;
  final bool isAddCart, isFavourite, btnCart, loadCart;
  final void Function()? onFavourite;

  @override
  Widget build(BuildContext context) {
    Color myColor = Color(int.parse('F7F7F7', radix: 16)).withOpacity(1.0);
    double acctualPrice = double.parse(price.replaceAll('+', ''));
    double offerPrice = double.parse(specialPrice.replaceAll('+', ''));
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScreenProductDetail(
                storeId: storeId,
                parentCategoryId: parentCategoryId,
                productId: productid,
                wishList: isFavourite,
                storeName: storeName,
                sku: sku,
                qty: qty,
                productName: name,
                shopType: shopType),
          ),
        );
      },
      child: SizedBox(
        // height: MediaQuery.of(context).size.height / 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              fit: StackFit.passthrough,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: myColor),
                    ),
                    child: Image.network(
                      image,
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 2.3,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width / 2.3,
                          'images/22_LOGIN PAGE-4.png',
                          color: Colors.black.withOpacity(0.4),
                        );
                      },
                    ),
                  ),
                ),
                //favourite button
                if (value.quoteId != null)
                  IconFavourite(
                      index: 0,
                      right: 7,
                      top: 7,
                      isSelected: isFavourite,
                      onFavourite: onFavourite),
              ],
            ),
            height5,
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: TextInput(maxLines: 2, size: 13, text1: " $name")),
                  TextInput(
                    text1: "₹ ${offerPrice == 0 ? acctualPrice : offerPrice}",
                    size: 15,
                    weight: FontWeight.w300,
                  ),
                  (offerPrice != 0 && (acctualPrice != offerPrice))
                      ? Row(
                          children: [
                            Text(
                              "₹ $acctualPrice",
                              style: const TextStyle(
                                  decoration: TextDecoration.lineThrough),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: TextInput(
                                text1: calcPercentage(acctualPrice, offerPrice),
                                colorOfText: Colors.green,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 15, right: 15),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       Align(
            //           alignment: Alignment.topLeft,
            //           child: TextInput(
            //             maxLines: 2,
            //             size: 13,
            //             text1: name,
            //           )),
            //       if (price != '0' && offerPrice != 0.0)
            //         Align(
            //           alignment: Alignment.topLeft,
            //           child: Padding(
            //             padding: const EdgeInsets.only(top: 5),
            //             child: TextInput(
            //               text1: "₹ $offerPrice",
            //               size: 18,
            //               weight: FontWeight.w100,
            //             ),
            //           ),
            //         ),
            //       Padding(
            //         padding: EdgeInsets.only(
            //             top: (price != '0' && offerPrice != 0.0) ? 0 : 5),
            //         child: Row(
            //           children: [
            //             TextInput(
            //               text1: "₹ $acctualPrice\t\t\t",
            //               size: price != '0' && offerPrice != 0.0 ? 12 : 18,
            //               weight: offerPrice == 0.0 ? FontWeight.w100 : null,
            //               decoration: offerPrice != 0.0
            //                   ? price != '0'
            //                       ? TextDecoration.lineThrough
            //                       : TextDecoration.none
            //                   : null,
            //             ),
            //             if (acctualPrice != 0.0 && offerPrice != 0.0)
            //               TextInput(
            //                 text1: calcPercentage(acctualPrice, offerPrice),
            //                 size: 12,
            //                 weight: FontWeight.w600,
            //                 colorOfText: Colors.green,
            //               ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(
      {required double size,
      color,
      required double top,
      required double right,
      void Function()? function}) {
    return Positioned(
      top: top,
      right: right,
      child: Container(
        height: 48,
        width: 48,
        alignment: Alignment.center,
        child: IconButton(
          onPressed: function,
          icon: Icon(
            Icons.favorite,
            color: color,
            size: size,
          ),
        ),
      ),
    );
  }

  calcPercentage(double acctualPrice, double offerPrice) {
    var percentage = ((acctualPrice - offerPrice) / acctualPrice) * 100;
    if (percentage.isNaN) {
      return '';
    } else {
      return '${percentage.toInt()}% OFF';
    }
  }
}
