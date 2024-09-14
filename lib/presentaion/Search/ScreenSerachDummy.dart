import 'package:fazzmi/presentaion/productDetailPage/screenProductDetailPage.dart';
import 'package:fazzmi/presentaion/store/screen_stores.dart';
import 'package:fazzmi/widgets/textInput.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/searchModel/searchModel.dart';
import '../../provider/searchPageprovider.dart';

class ScreenSearchh extends StatelessWidget {
  ScreenSearchh({super.key});
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(width: 1.0, color: Colors.grey.shade400),
    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
  );

  buildAppBar(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return PreferredSize(
      preferredSize: const Size.fromHeight(85),
      child: Padding(
        padding: const EdgeInsets.only(top: 25.0),
        child: AppBar(
            leading: IconButton(
                padding: EdgeInsets.only(left: 30),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.grey,
                  size: 20,
                )),
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: SizedBox(
              height: 55,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search Products',
                  focusedBorder: outlineInputBorder,
                  enabledBorder: outlineInputBorder,
                  prefixIcon: const Icon(
                    Icons.search_outlined,
                    color: Colors.grey,
                    size: 26,
                  ),
                  //  Image.asset(
                  //     "images/serachicon.png",
                  //     color: Colors.grey,
                  //   ),
                ),
                onChanged: (value) {
                  Provider.of<SearchPageProvider>(context, listen: false)
                      .getSearchData(searchText: value);
                },
                onEditingComplete: () {
                  searchController.clear();
                  Provider.of<SearchPageProvider>(context, listen: false)
                      .getSearchData(searchText: '');
                },
                onFieldSubmitted: (value) {
                  // Provider.of<SearchPageProvider>(context, listen: false)
                  //     .getSearchData(searchText: value);
                },
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body:
          Consumer<SearchPageProvider>(builder: (context, searchValue, child) {
        if (!searchValue.loader) {
          if (searchValue.searchItem != null) {
            if (searchValue.searchItem!.data != null) {
              // var storeItem = searchValue.searchItem!.data!.store;
              List<Products>? productItem =
                  searchValue.searchItem!.data!.products;
              return Column(children: [
                buildItemSerachProductWidget(context, productItem),
                // buildItemSerachStoreWidget(context, storeItem)
              ]);
            } else {
              return const TextInput(text1: "No Data...");
            }
          } else {
            return const SizedBox();
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  buildItemSerachProductWidget(
      BuildContext context, List<Products>? productItem) {
    return productItem!.isEmpty
        ? const SizedBox()
        : Expanded(
            child: ListView(
            children: List.generate(
                productItem.length,
                (index) => InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenProductDetail(
                                      parentCategoryId:
                                          productItem[index].parentCategoryId!,
                                      productId:
                                          int.parse(productItem[index].id!),
                                      productName: productItem[index].name!,
                                      qty: 1,
                                      shopType: productItem[index].shopType!,
                                      sku: productItem[index].sku!,
                                      storeId: int.parse(
                                          productItem[index].storeId!),
                                      storeName: productItem[index].storeName!,
                                      wishList: true,
                                    )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: SizedBox(
                                    height: 50,
                                    width: 55,
                                    child: Image.network(
                                        productItem[index].image!,
                                        fit: BoxFit.fill),
                                  )),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: TextInput(
                                          text1: productItem[index].name!)),
                                  const TextInput(text1: "Product", size: 12),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
          ));
  }

  // buildItemSerachStoreWidget(BuildContext context, List<Store>? storeItem) {
  //   return Expanded(
  //       child: Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: ListView(
  //       children: List.generate(
  //           storeItem!.length,
  //           (index) => InkWell(
  //                 onTap: () {
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (context) => ScreenStores(
  //                               storename: storeItem[index].name!,
  //                               shoptype: int.parse(storeItem[index].shopType!),
  //                               storeId: int.parse(storeItem[index].storeId!),
  //                               parentCategoryId:
  //                                   storeItem[index].parentCategoryId!)));
  //                 },
  //                 child: ListTile(
  //                   contentPadding: const EdgeInsets.all(0),
  //                   leading: ClipRRect(
  //                       borderRadius: BorderRadius.circular(25),
  //                       child: SizedBox(
  //                         height: 50,
  //                         width: 55,
  //                         child: Image.network(storeItem[index].image!,
  //                             fit: BoxFit.fill),
  //                       )),
  //                   title: Column(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       TextInput(text1: storeItem[index].name!),
  //                       const TextInput(text1: "Store", size: 12),
  //                     ],
  //                   ),
  //                 ),
  //               )),
  //     ),
  //   ));
  // }
}
