import 'package:fazzmi/widgets/app_bar_widget.dart';
import 'package:fazzmi/widgets/serach_bar.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/commonMethods.dart';
import '../../../model/categorymodel/category_model.dart';
import '../../../services/api_services.dart';
import '../../../widgets/custom_rounded_container.dart';
import '../../productDetailPage/screenProductDetailPage.dart';

class ScreenCategoryViewAll extends StatefulWidget {
  final int indexgiven;
  final String title;
  const ScreenCategoryViewAll(
      {super.key, required this.indexgiven, required this.title});

  @override
  State<ScreenCategoryViewAll> createState() => _ScreenCategoryViewAllState();
}

class _ScreenCategoryViewAllState extends State<ScreenCategoryViewAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: widget.title, icon: Icons.arrow_back_ios),
      body: Column(
        children: [
          const CustomSearchBar(text: "Search products"),
          Expanded(
            child: FutureBuilder<CategoryModel>(
                future: ApiServices().getMainCategory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.data!.isNotEmpty) {
                    var _categoryList = snapshot.data!.data!;

                    return GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 3 / 5,
                                crossAxisCount: 4,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2),
                        itemCount: _categoryList[widget.indexgiven]
                            .featuredProducts!
                            .length,
                        itemBuilder: (BuildContext ctx, index) {
                          return RoundedContainer(
                            roundedContainerFunction: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ScreenProductDetail(
                                          sku: _categoryList[widget.indexgiven]
                                              .featuredProducts![index]
                                              .sku!,
                                          qty: 1,
                                          productName: capitalizeAllWord(
                                              _categoryList[widget.indexgiven]
                                                  .featuredProducts![index]
                                                  .name
                                                  .toString()),
                                          shopType: _categoryList[widget.indexgiven]
                                              .featuredProducts![index]
                                              .shopType!,
                                          storeName:
                                              _categoryList[widget.indexgiven]
                                                  .featuredProducts![index]
                                                  .store_name!,
                                          wishList: true,
                                          productId: int.parse(
                                              _categoryList[widget.indexgiven]
                                                  .featuredProducts![index]
                                                  .productId!),
                                          parentCategoryId:
                                              _categoryList[widget.indexgiven]
                                                  .featuredProducts![index]
                                                  .parent_category_id!,
                                          storeId:
                                              int.parse(_categoryList[widget.indexgiven].featuredProducts![index].store!))));
                            },
                            containerTitle: _categoryList[widget.indexgiven]
                                .featuredProducts![index]
                                .name!,
                            containerImage: _categoryList[widget.indexgiven]
                                .featuredProducts![index]
                                .image!,
                          );
                        });
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ],
      ),
    );
  }
}
