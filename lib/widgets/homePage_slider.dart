import 'package:cached_network_image/cached_network_image.dart';
import 'package:fazzmi/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/homepageads/homepage_ads_model.dart';
import '../presentaion/store/screen_stores.dart';
import '../provider/sliderProvider.dart';

class SliderCls extends StatefulWidget {
  final List<Datum>? imageList;
  final HomePageAds? addList;
  const SliderCls(
    this.imageList,
    this.addList, {
    super.key,
  });

  @override
  State<SliderCls> createState() => _SliderClsState();
}

class _SliderClsState extends State<SliderCls> {
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Consumer<SliderProvider>(builder: (context, value, child) {
          return SizedBox(
            height: 160,
            width: double.infinity,
            child: PageView.builder(
              physics: widget.imageList!.length <= 1
                  ? const NeverScrollableScrollPhysics()
                  : const ScrollPhysics(),
              controller: controller,
              onPageChanged: (index) {
                value.changeCurrentIndex(
                    imageLength: widget.imageList!.length, index: index);
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScreenStores(
                          parentCategoryId:
                              widget.addList?.data?[index].parentCategoryId ??
                                  "",
                          shoptype: int.parse(
                              widget.addList?.data?[index].shop_type ?? ""),
                          storeId:
                              int.parse(widget.addList!.data![index].store!),
                          storename:
                              widget.addList?.data?[index].storeName ?? "",
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CachedNetworkImage(
                      imageUrl: widget
                          .imageList![index % widget.imageList!.length].image!,
                      imageBuilder: (context, imageProvider) => Container(
                        width: MediaQuery.of(context).size.width,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.fill),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                );
              },
            ),
          );
        }),
        const SizedBox(
          height: 20,
        ),
        widget.imageList!.length > 1
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < widget.imageList!.length; i++)
                    Consumer<SliderProvider>(builder: (context, value, child) {
                      return buildIndicator(value.currentIndex == i);
                    })
                ],
              )
            : const SizedBox(),
      ],
    );
  }

  Widget buildIndicator(bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
        height: isSelected ? 10 : 8,
        width: isSelected ? 10 : 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? primaryColor : Colors.grey,
        ),
      ),
    );
  }
}
