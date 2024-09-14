import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/model/categorymodel/category_model.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:flutter/material.dart';

import '../../core/constants/commonMethods.dart';
import '../../widgets/Custom_inkWell.dart';
import '../../widgets/custom_rounded_container.dart';
import '../../widgets/textInput.dart';
import '../../widgets/tittle_app_bar.dart';
import '../productDetailPage/screenProductDetailPage.dart';
import 'category_view_all/category_view_all.dart';

class ScreenCategories extends StatefulWidget {
  const ScreenCategories({super.key});
  @override
  State<ScreenCategories> createState() => _ScreenCategoriesState();
}

class _ScreenCategoriesState extends State<ScreenCategories> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    //var screenHeigth = MediaQuery.of(context).size.height;
    DateTime preBackpress = DateTime.now();
    // ignore: deprecated_member_use
    return WillPopScope(
        onWillPop: () async {
          final timegap = DateTime.now().difference(preBackpress);
          final cantExit = timegap >= const Duration(seconds: 2);
          preBackpress = DateTime.now();

          if (cantExit) {
            //show snackbar
            final snack = SnackBar(
              content: Text('Press Back button again to Exit'),
              duration: Duration(seconds: 2),
            );

            ScaffoldMessenger.of(context).showSnackBar(snack);

            return false; // false will do nothing when back press
          } else {
            return true; // true will exit the app
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const TittleAppBar(
            title: "Category",
          ),
          body: Column(
            children: [
              // const SearchBar(
              //   text: "Search Products",
              // ),
              Expanded(
                child: FutureBuilder<CategoryModel>(
                    future: ApiServices().getMainCategory(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.data!.isNotEmpty) {
                        var _categoryList = snapshot.data!.data!;
                        print(_categoryList);

                        return ListView(
                            children: List.generate(
                                _categoryList.length,
                                (indexx) => Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextInput(
                                                  text1: capitalizeAllWord(
                                                      _categoryList[indexx]
                                                          .title
                                                          .toString()),
                                                  size: 20,
                                                ),

                                                CustomInkWell(
                                                  onTap: () {
                                                    if (_categoryList[indexx]
                                                        .featuredProducts!
                                                        .isEmpty) {
                                                      // Show error message
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'No items available in this place'),
                                                          duration: Duration(
                                                              seconds: 2),
                                                        ),
                                                      );
                                                    } else {
                                                      // Navigate to the "view all" screen
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ScreenCategoryViewAll(
                                                            title: capitalizeAllWord(
                                                                _categoryList[
                                                                        indexx]
                                                                    .title
                                                                    .toString()),
                                                            indexgiven: indexx,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    width: 70,
                                                    child: const Center(
                                                      child: TextInput(
                                                        text1: "VIEW ALL",
                                                        colorOfText:
                                                            primaryColor,
                                                        size: 12,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                          color: primaryColor),
                                                    ),
                                                  ),
                                                )

                                                // CustomInkWell(
                                                //   onTap: () {
                                                //     Navigator.push(
                                                //         context,
                                                //         MaterialPageRoute(
                                                //             builder: (context) =>
                                                //                 ScreenCategoryViewAll(
                                                //                   title: capitalizeAllWord(
                                                //                       _categoryList[
                                                //                               indexx]
                                                //                           .title
                                                //                           .toString()),
                                                //                   indexgiven:
                                                //                       indexx,
                                                //                 )));
                                                //   },
                                                //   child: Container(
                                                //     height: 30,
                                                //     width: 70,
                                                //     child: const Center(
                                                //         child: TextInput(
                                                //       text1: "VIEW ALL",
                                                //       colorOfText: primaryColor,
                                                //       size: 12,
                                                //     )),
                                                //     decoration: BoxDecoration(
                                                //         borderRadius:
                                                //             BorderRadius.circular(
                                                //                 8),
                                                //         border: Border.all(
                                                //             color: primaryColor)
                                                //             ),
                                                //   ),
                                                // )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: screenWidth / 2.5,
                                          width: double.infinity,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: _categoryList[indexx]
                                                          .featuredProducts!
                                                          .length >=
                                                      4
                                                  ? 4
                                                  : _categoryList[indexx]
                                                      .featuredProducts!
                                                      .length,
                                              itemBuilder:
                                                  (BuildContext, index) {
                                                return RoundedContainer(
                                                  roundedContainerFunction: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => ScreenProductDetail(
                                                                sku: _categoryList[indexx]
                                                                    .featuredProducts![
                                                                        index]
                                                                    .sku!,
                                                                qty: 1,
                                                                productName:
                                                                    _categoryList[indexx]
                                                                        .featuredProducts![
                                                                            index]
                                                                        .name!,
                                                                shopType: _categoryList[indexx]
                                                                    .featuredProducts![
                                                                        index]
                                                                    .shopType!,
                                                                storeName: _categoryList[
                                                                        indexx]
                                                                    .featuredProducts![
                                                                        index]
                                                                    .store_name!,
                                                                wishList: true,
                                                                productId: int.parse(
                                                                    _categoryList[indexx]
                                                                        .featuredProducts![
                                                                            index]
                                                                        .productId!),
                                                                parentCategoryId:
                                                                    _categoryList[indexx]
                                                                        .featuredProducts![index]
                                                                        .parent_category_id!,
                                                                storeId: int.parse(_categoryList[indexx].featuredProducts![index].store!))));
                                                  },
                                                  containerTitle: _categoryList[
                                                          indexx]
                                                      .featuredProducts![index]
                                                      .name!,
                                                  containerImage: _categoryList[
                                                          indexx]
                                                      .featuredProducts![index]
                                                      .image,
                                                );
                                              }),
                                        ),
                                      ],
                                    )));
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
            ],
          ),
        ));
  }
}
