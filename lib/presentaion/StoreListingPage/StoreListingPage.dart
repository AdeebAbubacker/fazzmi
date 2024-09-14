import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/model/store_category_model/store_category_model.dart';
import 'package:fazzmi/model/subcategorymodel/sub_category_model.dart';
import 'package:fazzmi/presentaion/store/widgets/cartBagWidget.dart';
import 'package:fazzmi/provider/cartInStore.dart';
import 'package:fazzmi/provider/subCategoryProvider.dart';
import 'package:fazzmi/widgets/serach_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../../widgets/textInput.dart';
import '../store/screen_stores.dart';

class StoreListingPage extends StatefulWidget {
  final int categoryId;

  const StoreListingPage({super.key, required this.categoryId});
  @override
  State<StoreListingPage> createState() => _StoreListingPageState();
}

class _StoreListingPageState extends State<StoreListingPage> {
  int position = 1;
  var currentIndex = 0;
  int? subCategoryId;
  var box = GetStorage();
  Future<SubCategoryModel?>? subcategoryData;
  @override
  void initState() {
    super.initState();
    loadData();

    cartTotalCount();
  }

  loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<SubCategoryProvider>(context, listen: false)
          .getSubCategoryList(id: widget.categoryId);
      // ignore: use_build_context_synchronously
      subcategoryData = Provider.of<SubCategoryProvider>(context, listen: false)
          .getSubCategoryList(id: widget.categoryId);
    });
  }

  cartTotalCount() async {
    if (box.read("quoteIdGuest") != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Provider.of<CartCounterStore>(context, listen: false)
            .getGuestTotalGstList();
      });
    } else if (box.read("quoteIdLogin") != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Provider.of<CartCounterStore>(context, listen: false)
            .getCartTotalGstList();
      });
    }
  }

  getStorefunction({subCategoryId}) {
    return Provider.of<SubCategoryProvider>(context, listen: false)
        .getStoreList(id: subCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBarSection(context),
          _buildSearchBarSection(),
          Expanded(
            child: SingleChildScrollView(
              child: Consumer<SubCategoryProvider>(
                  builder: (context, value, child) {
                if (!value.subcategoryloader &&
                    value.subCategoryList!.data != null) {
                  var data = value.subCategoryList!.data;

                  // var categoryid = data!.mainCategoryList![0].categoryId;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3, bottom: 3),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ScreenStores(
                                          parentCategoryId:
                                              data!.parentCategoryId.toString(),
                                          storeId: int.parse(data.storeId!),
                                          shoptype: 2,
                                          storename: data.storeName ?? '',
                                        )));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image:
                                        NetworkImage(data!.storeBanner ?? ''),
                                    fit: BoxFit.fill)),
                            height: 170,
                            width: width - 16,
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8, top: 15, bottom: 5),
                          child: TextInput(
                            text1: "Shop By Store Type",
                            weight: FontWeight.bold,
                            size: 20,
                          ),
                        ),
                      ),
                      _buildCategoryList(width),
                    ],
                  );
                } else {
                  return SizedBox(
                      height: height - height / 6,
                      child: const Center(child: CircularProgressIndicator()));
                }
              }),
            ),
          ),
        ],
      ),
    );
  }

  Consumer<SubCategoryProvider> _buildCategoryList(double width) {
    return Consumer<SubCategoryProvider>(builder: (context, valuee, child) {
      if (!valuee.subcategoryloader) {
        if (valuee.subCategoryList!.data!.mainCategoryList!.isNotEmpty) {
          var data = valuee.subCategoryList!.data;

          subCategoryId = int.parse(data!.mainCategoryList![0].categoryId!);

          return Column(
            children: [
              _buildSubCategoryList(data, valuee, width),
              _buildStoreList(width: width),
            ],
          );
        } else {
          return const SizedBox(
            height: 300,
            child: Center(child: TextInput(text1: "No Data....")),
          );
        }
      } else {
        return const SizedBox(
          height: 200,
          child: Center(child: TextInput(text1: "No Data.....")),
        );
      }
    });
  }

  Consumer<SubCategoryProvider> _buildStoreList({required width}) {
    return Consumer<SubCategoryProvider>(builder: (context, value, child) {
      // ignore: unrelated_type_equality_checks
      if (value.subCategoryList != null && value.subCategoryList == 0) {
        return const SizedBox(
            height: 100, child: SnackBar(content: Text("data")));
      }

      if (!value.storeloader) {
        if (value.storeCategoryList == null && value.errorMsg != null) {
          // Display error message
          return Center(
            child: Text(
              value.errorMsg!,
              style: const TextStyle(color: Colors.green),
            ),
          );
        }

        var storeData = value.storeCategoryList?.data ?? [];

        if (storeData.isEmpty) {
          // Display message when store data is empty
          return const SizedBox(
            height: 210,
            child: Center(
              child: Text(
                "No stores available",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        var productCount = 4;
        var productWidth =
            (MediaQuery.of(context).size.width - 44 * 2) / productCount;
        var productheight =
            (MediaQuery.of(context).size.width - 44 * 2) / productCount;

        //var productWidth = (MediaQuery.of(context).size.width - 44 * 2) / productCount;

        return ListView.builder(
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: storeData.length,
          shrinkWrap: true,
          itemBuilder: ((context, index) => Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0, top: 8.0),
                child: Card(
                  //color: Color(int.parse('FFFFFF', radix: 16)).withOpacity(0.0),
                  color: (Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xFFF2F2F2), width: 1),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScreenStores(
                            parentCategoryId:
                                storeData[index].parentCategoryId == null
                                    ? "0"
                                    : storeData[index].parentCategoryId!,
                            storeId: int.parse(storeData[index].storeId!),
                            shoptype: int.parse(storeData[index].shopType!),
                            storename: storeData[index].title!,
                          ),
                        ),
                      );
                    },
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, bottom: 8.0, right: 8.0, top: 8.0),
                            child: Row(
                              children: [
                                _buildImageSection(storeData, index),
                                width5,
                                Expanded(
                                  child: _buildStoreDetailListColumn(
                                      storeData, index),
                                ),
                              ],
                            ),
                          ),
                          height5,
                          if (storeData[index].featuredProducts != null &&
                              storeData[index].featuredProducts!.isNotEmpty)
                            Row(
                              children: storeData[index]
                                  .featuredProducts!
                                  .take(productCount)
                                  .map(
                                    (product) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: productWidth,
                                        child: Stack(
                                          children: [
                                            // Image Container
                                            Positioned(
                                              top: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                width: productWidth,
                                                height: productheight,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xFFF2F2F2),
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    product.productImage ?? "",
                                                    //fit: BoxFit.cover,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Text Container
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 52.0),
                                              child: Container(
                                                height: 100,
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(15),
                                                    bottomRight:
                                                        Radius.circular(15),
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0.0,
                                                              top: 0.0),
                                                      child: Text(
                                                        product.name ?? "",
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                        ),
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 3),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0.0,
                                                              top: 0.0),
                                                      child: Text(
                                                        '₹ ${product.price ?? ""}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                        ]),
                  ),
                ),
              )),
        );
      } else {
        return const SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        );
      }
    });
  }

  Padding _buildStoreDetailListColumn(List<Datum> storeData, int index) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 0,
          // right: 8,
          top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Display main store information
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextInput(
                text1: storeData[index].title!,
                size: 15,
                weight: FontWeight.bold,
              ),
              SizedBox(
                width: 220,
                child: TextInput(
                  text1: storeData[index].description == null
                      ? ""
                      : storeData[index].description!,
                  size: 13,
                  colorOfText: Colors.grey,
                ),
              ),
              width5,
              Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset("images/28_PRODUCT DETAIL 2-60.png"),
                  ),
                  width5,
                  TextInput(
                    text1: storeData[index].deliveryDate == null
                        ? ""
                        : storeData[index].deliveryDate!,
                    colorOfText: Colors.grey,
                    weight: FontWeight.normal,
                  ),
                  width5,
                  const TextInput(
                    weight: FontWeight.normal,
                    text1: "Delivery",
                    colorOfText: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

//aswathy
  Container _buildImageSection(List<Datum> storeData, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Outer card border radius
        border: Border.all(color: const Color(0xFFF2F2F2)), // Border color
      ),
      height: 60,
      width: 65,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10), // Image border radius

        child: Image.network(
          storeData[index].image!,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // SizedBox _buildSubCategoryList(

  SizedBox _buildSubCategoryList(
      dynamic data, SubCategoryProvider valuee, double width) {
    return SizedBox(
      height: 35,
      child: Padding(
        padding: const EdgeInsets.only(left: 6, right: 6, top: 0),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: data.mainCategoryList!.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              var item = data.mainCategoryList![index];
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      valuee.setindex(index);
                      getStorefunction(
                          subCategoryId: int.parse(item.categoryId!));
                    },
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Container(
                        constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth, minWidth: 200),
                        height: 35,

                        // width: width / 2.1,
                        margin: const EdgeInsets.only(right: 5.0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 15.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: valuee.index == index
                                    ? Colors.white
                                    : Colors.grey.shade300),
                            color: valuee.index == index
                                ? primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(40)),
                        child: Center(
                            child: Align(
                          // alignment: Alignment.center,
                          child: Text(
                            item.categoryTitle!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: valuee.index == index
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 13),
                          ),
                        )),
                      );
                    }),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Consumer<CartCounterStore> _buildCartWidget() {
    return Consumer<CartCounterStore>(
      builder: (context, value, child) => (value.loader)
          ? const SizedBox()
          : WidgetCartBag(
              storename: "fazzmi",
              cartCount: value.cartCount,
            ),
    );
  }

  Padding _buildSearchBarSection() {
    return const Padding(
      padding: EdgeInsets.only(
        top: 8,
      ),
      child: CustomSearchBar(text: "Search for items"),
    );
  }

  Padding _buildAppBarSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey,
                    size: 20,
                  )),
            ],
          ),
          _buildCartWidget()
        ],
      ),
    );
  }
}
