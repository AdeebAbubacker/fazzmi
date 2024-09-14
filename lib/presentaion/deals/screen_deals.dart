import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/presentaion/productDetailPage/screenProductDetailPage.dart';
import 'package:fazzmi/presentaion/store/screen_stores.dart';
import 'package:fazzmi/provider/addBannerProvider.dart';
import 'package:fazzmi/provider/deals_provider.dart';
import 'package:fazzmi/widgets/helper.dart';
import 'package:fazzmi/widgets/serach_bar.dart';
import 'package:fazzmi/widgets/text_1_.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/commonMethods.dart';
import '../../widgets/textInput.dart';
import '../../widgets/tittle_app_bar.dart';

class ScreenDeals extends StatefulWidget {
  const ScreenDeals({Key? key}) : super(key: key);

  @override
  State<ScreenDeals> createState() => _ScreenDealsState();
}

class _ScreenDealsState extends State<ScreenDeals> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  getStorefunction({subCategoryId}) {
    return Provider.of<DealsProvider>(context, listen: false)
        .getDealsStore(id: subCategoryId);
  }

  loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AddBannerProvider>(context, listen: false)
          .getAddBannerDetails(2);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<DealsProvider>(context, listen: false)
          .getDealsShopCategorySection();
    });
  }
//-------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    DateTime pre_backpress = DateTime.now();
    return WillPopScope(
        onWillPop: () async {
          final timegap = DateTime.now().difference(pre_backpress);

          final cantExit = timegap >= Duration(seconds: 2);

          pre_backpress = DateTime.now();

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
            title: "Deals",
          ),
          body: Consumer<DealsProvider>(builder: (context, dealsvalue, child) {
            if (!dealsvalue.dealsCategoryLoader) {
              if (dealsvalue
                  .dealsCategory!.data!.mainCategoryList!.isNotEmpty) {
                var dealsCategoryList = dealsvalue.dealsCategory?.data;
                return Column(
                  children: [
                    const CustomSearchBar(text: "What are you looking for"),
                    Expanded(
                      child: ListView(
                        children: [
                          height10,
                          Consumer<AddBannerProvider>(
                              builder: (context, valuee, child) {
                            if (!valuee.addBanerloader &&
                                valuee.addBannerList!.data != null) {
                              var dataa = valuee.addBannerList!.data;
                              return Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          onError: (exception, stackTrace) {
                                            const AssetImage(
                                                "images/Fazzmi_logo.png");
                                          },
                                          image: NetworkImage(dataa![0].image!),
                                          fit: BoxFit.fill)),
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, bottom: 20),
                                    child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: SizedBox(
                                          width: 120,
                                          height: 37,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              side: const BorderSide(
                                                color: primaryColor,
                                              ),
                                              primary: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            onPressed: () {
                                              valuee.addBannerList!.data![0]
                                                          .parentCategoryId ==
                                                      null
                                                  ? HelperDialogue().dialugue(
                                                      title: "Oops!!!",
                                                      content: "No Store Found",
                                                      context: context,
                                                    )
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ScreenStores(
                                                                parentCategoryId: valuee
                                                                    .addBannerList!
                                                                    .data![0]
                                                                    .parentCategoryId,
                                                                storeId: int
                                                                    .parse(valuee
                                                                        .addBannerList!
                                                                        .data![
                                                                            0]
                                                                        .store!),
                                                                shoptype: 2,
                                                                storename: valuee
                                                                    .addBannerList!
                                                                    .data![0]
                                                                    .storeName!,
                                                              )));
                                            },
                                            child: const TextInput(
                                              text1: "Order Now",
                                              size: 12,
                                              colorOfText: primaryColor,
                                            ),
                                          ),
                                        )),
                                  ));
                            } else {
                              return const SizedBox();
                            }
                          }),
                          height10,
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                /// SHOP BY CATEGORY
                                const Text1(textname: "Shop By Categories"),
                                height10,

                                Column(
                                  children: [
                                    SizedBox(
                                      height: 190,
                                      width: double.infinity,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: dealsCategoryList!
                                              .mainCategoryList!.length,
                                          itemBuilder: (BuildContext, index) {
                                            return InkWell(
                                              onTap: () {
                                                dealsvalue.setindex(index);

                                                getStorefunction(
                                                  subCategoryId: int.parse(
                                                      dealsCategoryList
                                                          .mainCategoryList![
                                                              index]
                                                          .categoryId!),
                                                );
                                                // print(MainCategoryList()
                                                //     .categoryId);
                                              },
                                              child: Center(
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5),
                                                          width: 135,
                                                          height: 120,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: dealsvalue
                                                                            .index ==
                                                                        index
                                                                    ? primaryColor
                                                                    : const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        227,
                                                                        225,
                                                                        225),
                                                                width: 3),
                                                            color: Colors.white,
                                                          ),
                                                          child: Image.network(
                                                              fit: BoxFit.fill,
                                                              dealsCategoryList
                                                                  .mainCategoryList![
                                                                      index]
                                                                  .categoryImage!),
                                                        ),
                                                        Container(
                                                          height: 45,
                                                          width: 135,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: dealsvalue
                                                                        .index ==
                                                                    index
                                                                ? primaryColor
                                                                : const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    227,
                                                                    225,
                                                                    225),
                                                          ),
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                TextInput(
                                                                  colorOfText: dealsvalue
                                                                              .index ==
                                                                          index
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                  weight:
                                                                      FontWeight
                                                                          .bold,
                                                                  text1: capitalizeAllWord(dealsCategoryList
                                                                      .mainCategoryList![
                                                                          index]
                                                                      .categoryTitle!),
                                                                  size: 12,
                                                                ),
                                                              ]),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                    Consumer<DealsProvider>(builder:
                                        (context, dealsStoreValue, child) {
                                      if (!dealsStoreValue.dealsStoreLoader &&
                                          dealsStoreValue.dealsStore!.data !=
                                              null) {
                                        if (dealsStoreValue
                                            .dealsStore!.data!.isNotEmpty) {
                                        } else {
                                          return const Center(
                                              child:
                                                  TextInput(text1: "No Data"));
                                        }
                                        var data =
                                            dealsStoreValue.dealsStore!.data!;

                                        return SingleChildScrollView(
                                          child: ListView(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            physics:
                                                const ClampingScrollPhysics(),
                                            children: List.generate(
                                                data.length,
                                                (index) => Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                const TextInput(
                                                                  text1: "Order",
                                                                  weight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                                width5,
                                                                TextInput(
                                                                  text1:
                                                                      data[index]
                                                                          .name!,
                                                                  size: 15,
                                                                  colorOfText:
                                                                      primaryColor,
                                                                )
                                                              ],
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => ScreenStores(
                                                                            parentCategoryId: data[index]
                                                                                .parentCategoryId!,
                                                                            storeId: int.parse(data[index]
                                                                                .storeId!),
                                                                            shoptype: int.parse(data[index]
                                                                                .shopType!),
                                                                            storename:
                                                                                data[index].name!)));
                                                              },
                                                              child: Row(
                                                                children: const [
                                                                  TextInput(
                                                                    text1:
                                                                        'View Details',
                                                                    size: 15,
                                                                    colorOfText:
                                                                        primaryColor,
                                                                  ),
                                                                  width5,
                                                                  Icon(
                                                                    Icons
                                                                        .arrow_forward_ios,
                                                                    color:
                                                                        primaryColor,
                                                                    size: 15,
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount: data[index]
                                                              .dealsProducts!
                                                              .length,
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          itemBuilder:
                                                              (context, indexx) {
                                                            if (data[index]
                                                                    .dealsProducts !=
                                                                null) {
                                                              var storeproductsData =
                                                                  data[index]
                                                                          .dealsProducts![
                                                                      indexx];
                                                              return InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => ScreenProductDetail(
                                                                              productId:
                                                                                  int.parse(data[index].dealsProducts![indexx].productId!),
                                                                              storeId: int.parse(data[index].storeId!),
                                                                              wishList: true,
                                                                              parentCategoryId: data[index].parentCategoryId!,
                                                                              storeName: data[index].name!,
                                                                              shopType: data[index].shopType!,
                                                                              productName: data[index].dealsProducts![indexx].name!,
                                                                              sku: data[index].dealsProducts![indexx].sku!,
                                                                              qty: 1)));
                                                                },
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            100,
                                                                        width:
                                                                            100,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(
                                                                                10),
                                                                            image: DecorationImage(
                                                                                fit: BoxFit.fill,
                                                                                image: NetworkImage(storeproductsData.image!))),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(
                                                                                8.0),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(
                                                                              width:
                                                                                  MediaQuery.of(context).size.width - 180,
                                                                              child:
                                                                                  TextInput(
                                                                                text1: storeproductsData.name!,
                                                                                size: 15,
                                                                                maxLines: 2,
                                                                              ),
                                                                            ),
                                                                            // SizedBox(
                                                                            //   width: 230,
                                                                            //   child:
                                                                            //       TextInput(
                                                                            //     text1: storeproductsData
                                                                            //         .shortDescription!,
                                                                            //     size: 15,
                                                                            //   ),
                                                                            // ),
                                                                            Row(
                                                                              children: [
                                                                                TextInput(
                                                                                  text1: "Model: ${storeproductsData.sku!} ",
                                                                                  size: 11,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            // Row(
                                                                            //   children: [
                                                                            //     Icon(
                                                                            //       Icons
                                                                            //           .star,
                                                                            //       size: 13,
                                                                            //       color: Colors
                                                                            //               .yellow[
                                                                            //           700],
                                                                            //     ),
                                                                            //     Icon(
                                                                            //       Icons
                                                                            //           .star,
                                                                            //       size: 13,
                                                                            //       color: Colors
                                                                            //               .yellow[
                                                                            //           700],
                                                                            //     ),
                                                                            //     Icon(
                                                                            //       Icons
                                                                            //           .star,
                                                                            //       size: 13,
                                                                            //       color: Colors
                                                                            //               .yellow[
                                                                            //           700],
                                                                            //     ),
                                                                            //     Icon(
                                                                            //       Icons
                                                                            //           .star,
                                                                            //       size: 13,
                                                                            //       color: Colors
                                                                            //               .yellow[
                                                                            //           700],
                                                                            //     ),
                                                                            //     const Icon(
                                                                            //       Icons
                                                                            //           .star_border,
                                                                            //       size: 13,
                                                                            //       color: Colors
                                                                            //           .grey,
                                                                            //     ),
                                                                            //   ],
                                                                            // ),
                                                                            TextInput(
                                                                              text1:
                                                                                  "₹ ${storeproductsData.price!}",
                                                                              size:
                                                                                  13,
                                                                            ),
                                                                            // TextInput(
                                                                            //   text1: storeproductsData
                                                                            //       .specialPrice!,
                                                                            //   colorOfText:
                                                                            //       Colors
                                                                            //           .green,
                                                                            //   size: 12,
                                                                            // ),
                                                                            TextInput(
                                                                              text1:
                                                                                  storeproductsData.deliveryDate!,
                                                                              size:
                                                                                  9,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            } else {
                                                              return const SizedBox();
                                                            }
                                                          },
                                                        )
                                                      ],
                                                    )),
                                          ),
                                        );
                                      } else {
                                        return const CircularProgressIndicator();
                                      }
                                    }),
                                  ],
                                )

                                // FutureBuilder<DealsShopBycategoryModel>(
                                //     future: ApiServices().getDealsShopByCategory(),
                                //     builder: (context, snapshot) {
                                //       if (snapshot.hasData &&
                                //           snapshot.data!.data!.mainCategoryList != null) {
                                //         var dealsCategoryList = snapshot.data!.data;
                                //         return SizedBox(
                                //           height: 190,
                                //           width: double.infinity,
                                //           child: ListView.builder(
                                //               scrollDirection: Axis.horizontal,
                                //               itemCount: dealsCategoryList!
                                //                   .mainCategoryList!.length,
                                //               itemBuilder: (BuildContext, index) {
                                //                 return InkWell(
                                //                   onTap: () {
                                //                     Navigator.push(
                                //                         context,
                                //                         MaterialPageRoute(
                                //                             builder: (context) => ScreenStores(
                                //                                 parentCategoryId:
                                //                                     dealsCategoryList
                                //                                         .mainCategoryList![
                                //                                             index]
                                //                                         .parent_category_id!,
                                //                                 storename: "store1",
                                //                                 shoptype: 1,
                                //                                 storeId: 1)));
                                //                   },
                                //                   child: Center(
                                //                     child: Row(
                                //                       children: [
                                //                         Column(
                                //                           mainAxisAlignment:
                                //                               MainAxisAlignment.start,
                                //                           children: [
                                //                             Container(
                                //                               margin: const EdgeInsets
                                //                                       .symmetric(
                                //                                   horizontal: 2),
                                //                               width: 135,
                                //                               height: 120,
                                //                               decoration: BoxDecoration(
                                //                                 border: Border.all(
                                //                                     color: const Color
                                //                                             .fromARGB(255,
                                //                                         227, 225, 225),
                                //                                     width: 3),
                                //                                 color: Colors.white,
                                //                               ),
                                //                               child: Image.network(
                                //                                   fit: BoxFit.fill,
                                //                                   dealsCategoryList
                                //                                       .mainCategoryList![
                                //                                           index]
                                //                                       .categoryImage!),
                                //                             ),
                                //                             Container(
                                //                               height: 45,
                                //                               width: 135,
                                //                               decoration:
                                //                                   const BoxDecoration(
                                //                                 color: Color.fromARGB(
                                //                                     255, 227, 225, 225),
                                //                               ),
                                //                               child: Column(
                                //                                   mainAxisAlignment:
                                //                                       MainAxisAlignment
                                //                                           .center,
                                //                                   crossAxisAlignment:
                                //                                       CrossAxisAlignment
                                //                                           .center,
                                //                                   children: [
                                //                                     TextInput(
                                //                                       weight:
                                //                                           FontWeight.bold,
                                //                                       text1: dealsCategoryList
                                //                                           .mainCategoryList![
                                //                                               index]
                                //                                           .categoryTitle!,
                                //                                       size: 10,
                                //                                     ),
                                //                                   ]),
                                //                             ),
                                //                           ],
                                //                         ),
                                //                       ],
                                //                     ),
                                //                   ),
                                //                 );
                                //               }),
                                //         );
                                //       } else {
                                //         return const SizedBox();
                                //       }
                                //     }),

                                /// DEALS CATEGORY

                                // FutureBuilder<DealsStoreCategoryModel>(
                                //     future: ApiServices().getDealsStoreProducts(),
                                //     builder: (context, snapshot) {
                                //       if (snapshot.hasData &&
                                //           snapshot.data!.data != null) {
                                //         var data = snapshot.data!.data;

                                //         return ListView(
                                //           shrinkWrap: true,
                                //           scrollDirection: Axis.vertical,
                                //           physics: const ClampingScrollPhysics(),
                                //           children: List.generate(
                                //               data!.length,
                                //               (index) => Column(
                                //                     children: [
                                //                       Row(
                                //                         mainAxisAlignment:
                                //                             MainAxisAlignment
                                //                                 .spaceBetween,
                                //                         children: [
                                //                           Row(
                                //                             children: [
                                //                               const TextInput(
                                //                                 text1: "Order",
                                //                                 weight: FontWeight.bold,
                                //                               ),
                                //                               width5,
                                //                               TextInput(
                                //                                 text1: data[index].name!,
                                //                                 size: 15,
                                //                                 colorOfText: primaryColor,
                                //                               )
                                //                             ],
                                //                           ),
                                //                           InkWell(
                                //                             onTap: () {
                                //                               Navigator.push(
                                //                                   context,
                                //                                   MaterialPageRoute(
                                //                                       builder: (context) => ScreenStores(
                                //                                           parentCategoryId:
                                //                                               data[index]
                                //                                                   .parentCategoryId!,
                                //                                           storeId: int.parse(
                                //                                               data[index]
                                //                                                   .storeId!),
                                //                                           shoptype: int
                                //                                               .parse(data[
                                //                                                       index]
                                //                                                   .shopType!),
                                //                                           storename: data[
                                //                                                   index]
                                //                                               .name!)));
                                //                             },
                                //                             child: Row(
                                //                               children: const [
                                //                                 TextInput(
                                //                                   text1: 'View Details',
                                //                                   size: 15,
                                //                                   colorOfText:
                                //                                       primaryColor,
                                //                                 ),
                                //                                 width5,
                                //                                 Icon(
                                //                                   Icons.arrow_forward_ios,
                                //                                   color: primaryColor,
                                //                                   size: 15,
                                //                                 )
                                //                               ],
                                //                             ),
                                //                           )
                                //                         ],
                                //                       ),
                                //                       ListView.builder(
                                //                         shrinkWrap: true,
                                //                         itemCount: data[index]
                                //                             .dealsProducts!
                                //                             .length,
                                //                         physics:
                                //                             const NeverScrollableScrollPhysics(),
                                //                         itemBuilder: (context, indexx) {
                                //                           if (data[index].dealsProducts !=
                                //                               null) {
                                //                             var storeproductsData = data[
                                //                                     index]
                                //                                 .dealsProducts![indexx];
                                //                             return InkWell(
                                //                               onTap: () {
                                //                                 Navigator.push(
                                //                                     context,
                                //                                     MaterialPageRoute(
                                //                                         builder: (context) => ScreenProductDetail(
                                //                                             productId: int.parse(data[index]
                                //                                                 .dealsProducts![
                                //                                                     indexx]
                                //                                                 .productId!),
                                //                                             storeId: int.parse(
                                //                                                 data[index]
                                //                                                     .storeId!),
                                //                                             wishList:
                                //                                                 true,
                                //                                             parentCategoryId:
                                //                                                 data[index]
                                //                                                     .parentCategoryId!,
                                //                                             storeName:
                                //                                                 data[index]
                                //                                                     .name!,
                                //                                             shopType:
                                //                                                 data[index]
                                //                                                     .shopType!,
                                //                                             productName:
                                //                                                 data[index]
                                //                                                     .dealsProducts![indexx]
                                //                                                     .name!,
                                //                                             sku: data[index].dealsProducts![indexx].sku!,
                                //                                             qty: 1)));
                                //                               },
                                //                               child: Padding(
                                //                                 padding:
                                //                                     const EdgeInsets.all(
                                //                                         8.0),
                                //                                 child: Row(
                                //                                   children: [
                                //                                     Container(
                                //                                       height: 100,
                                //                                       width: 100,
                                //                                       decoration: BoxDecoration(
                                //                                           borderRadius:
                                //                                               BorderRadius
                                //                                                   .circular(
                                //                                                       10),
                                //                                           image: DecorationImage(
                                //                                               fit: BoxFit
                                //                                                   .cover,
                                //                                               image: NetworkImage(
                                //                                                   storeproductsData
                                //                                                       .image!))),
                                //                                     ),
                                //                                     Padding(
                                //                                       padding:
                                //                                           const EdgeInsets
                                //                                               .all(8.0),
                                //                                       child: Column(
                                //                                         crossAxisAlignment:
                                //                                             CrossAxisAlignment
                                //                                                 .start,
                                //                                         mainAxisAlignment:
                                //                                             MainAxisAlignment
                                //                                                 .start,
                                //                                         children: [
                                //                                           SizedBox(
                                //                                             width: MediaQuery.of(
                                //                                                         context)
                                //                                                     .size
                                //                                                     .width -
                                //                                                 150,
                                //                                             child:
                                //                                                 TextInput(
                                //                                               text1: storeproductsData
                                //                                                   .name!,
                                //                                               size: 15,
                                //                                               maxLines: 2,
                                //                                             ),
                                //                                           ),
                                //                                           // SizedBox(
                                //                                           //   width: 230,
                                //                                           //   child:
                                //                                           //       TextInput(
                                //                                           //     text1: storeproductsData
                                //                                           //         .shortDescription!,
                                //                                           //     size: 15,
                                //                                           //   ),
                                //                                           // ),
                                //                                           Row(
                                //                                             children: const [
                                //                                               TextInput(
                                //                                                 text1:
                                //                                                     "Model Number",
                                //                                                 size: 11,
                                //                                               ),
                                //                                               // TextInput(
                                //                                               //   text1: storeproductsData
                                //                                               //       .name!,
                                //                                               //   size: 10,
                                //                                               // ),
                                //                                             ],
                                //                                           ),
                                //                                           // Row(
                                //                                           //   children: [
                                //                                           //     Icon(
                                //                                           //       Icons
                                //                                           //           .star,
                                //                                           //       size: 13,
                                //                                           //       color: Colors
                                //                                           //               .yellow[
                                //                                           //           700],
                                //                                           //     ),
                                //                                           //     Icon(
                                //                                           //       Icons
                                //                                           //           .star,
                                //                                           //       size: 13,
                                //                                           //       color: Colors
                                //                                           //               .yellow[
                                //                                           //           700],
                                //                                           //     ),
                                //                                           //     Icon(
                                //                                           //       Icons
                                //                                           //           .star,
                                //                                           //       size: 13,
                                //                                           //       color: Colors
                                //                                           //               .yellow[
                                //                                           //           700],
                                //                                           //     ),
                                //                                           //     Icon(
                                //                                           //       Icons
                                //                                           //           .star,
                                //                                           //       size: 13,
                                //                                           //       color: Colors
                                //                                           //               .yellow[
                                //                                           //           700],
                                //                                           //     ),
                                //                                           //     const Icon(
                                //                                           //       Icons
                                //                                           //           .star_border,
                                //                                           //       size: 13,
                                //                                           //       color: Colors
                                //                                           //           .grey,
                                //                                           //     ),
                                //                                           //   ],
                                //                                           // ),
                                //                                           TextInput(
                                //                                             text1:
                                //                                                 "₹ ${storeproductsData.price!}",
                                //                                             size: 13,
                                //                                           ),
                                //                                           // TextInput(
                                //                                           //   text1: storeproductsData
                                //                                           //       .specialPrice!,
                                //                                           //   colorOfText:
                                //                                           //       Colors
                                //                                           //           .green,
                                //                                           //   size: 12,
                                //                                           // ),
                                //                                           TextInput(
                                //                                             text1: storeproductsData
                                //                                                 .deliveryDate!,
                                //                                             size: 9,
                                //                                           ),
                                //                                         ],
                                //                                       ),
                                //                                     )
                                //                                   ],
                                //                                 ),
                                //                               ),
                                //                             );
                                //                           } else {
                                //                             return const SizedBox();
                                //                           }
                                //                         },
                                //                       )
                                //                     ],
                                //                   )),
                                //         );
                                //       } else {
                                //         return const SizedBox();
                                //       }
                                //     }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: TextInput(text1: "No Data"));
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
        ));
  }
}

// class ListOfItemsDeals {
//   String images;
//   String text1;
//   String text2;
//   String text3;

//   ListOfItemsDeals(
//       {required this.images,
//       required this.text1,
//       required this.text2,
//       required this.text3});
// }

// class VerticalListView extends StatelessWidget {
//   final ListOfItemsDealsVertical obj;
//   const VerticalListView({Key? key, required this.obj}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           height: 100,
//           width: 100,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               image: DecorationImage(
//                   fit: BoxFit.fill, image: AssetImage(obj.images))),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextInput(
//                 text1: obj.text1,
//                 size: 11,
//               ),
//               TextInput(
//                 text1: obj.text2,
//                 size: 11,
//               ),
//               Row(
//                 children: [
//                   const TextInput(
//                     text1: "Model Number",
//                     size: 8,
//                   ),
//                   TextInput(
//                     text1: obj.text3,
//                     size: 8,
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.star,
//                     size: 12,
//                     color: Colors.yellow[700],
//                   ),
//                   Icon(
//                     Icons.star,
//                     size: 12,
//                     color: Colors.yellow[700],
//                   ),
//                   Icon(
//                     Icons.star,
//                     size: 12,
//                     color: Colors.yellow[700],
//                   ),
//                   Icon(
//                     Icons.star,
//                     size: 12,
//                     color: Colors.yellow[700],
//                   ),
//                   const Icon(
//                     Icons.star_border,
//                     size: 12,
//                     color: Colors.grey,
//                   ),
//                 ],
//               ),
//               TextInput(
//                 text1: obj.text4,
//                 size: 12,
//               ),
//               TextInput(
//                 text1: obj.text5,
//                 colorOfText: Colors.green,
//                 size: 12,
//               ),
//               TextInput(
//                 text1: obj.text6,
//                 size: 8,
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }

// class ListOfItemsDealsVertical {
//   String images;
//   String text1;
//   String text2;
//   String text3;
//   String text4;
//   String text5;
//   String text6;
//   ListOfItemsDealsVertical(
//       {required this.images,
//       required this.text6,
//       required this.text1,
//       required this.text2,
//       required this.text3,
//       required this.text4,
//       required this.text5});
// }
