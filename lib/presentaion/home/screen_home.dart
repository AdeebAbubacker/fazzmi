import 'dart:io';

import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/core/constants/text_style.dart';
import 'package:fazzmi/model/homepageads/homepage_ads_model.dart';
import 'package:fazzmi/presentaion/StoreListingPage/StoreListingPage.dart';
import 'package:fazzmi/presentaion/login/login_page/screen_login.dart';
import 'package:fazzmi/presentaion/store/screen_stores.dart';
import 'package:fazzmi/provider/addBannerProvider.dart';
import 'package:fazzmi/provider/cartInStore.dart';
import 'package:fazzmi/provider/hompage_category_provider.dart';
import 'package:fazzmi/provider/locationButtonProvider.dart';
import 'package:fazzmi/services/api_services.dart';
import 'package:fazzmi/widgets/customButton2.dart';
import 'package:fazzmi/widgets/homePage_slider.dart';
import 'package:fazzmi/widgets/text_1_.dart';
import 'package:fazzmi/widgets/text_2_.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../../core/constants/commonMethods.dart';
import '../../model/list_of_items.dart';
import '../../widgets/textInput.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({Key? key}) : super(key: key);
  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  var hour = DateTime.now().hour;
  HomePageAds? addsList;
  int _categoryid = 0;
  final box = GetStorage();
  int index = 0;

  @override
  void initState() {
    loadAdsFunction();
    super.initState();
    loadData();
  }

  loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<HomepageCategoryProvider>(context, listen: false)
          .getCategory();
      // ignore: use_build_context_synchronously
      await Provider.of<LocationButtonProvider>(context, listen: false)
          .readLocation();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AddBannerProvider>(context, listen: false)
          .getAddBannerDetails(1);
    });
  }

  loadAdsFunction() async {
    addsList = await ApiServices().getHomepageadsSlider(0);
    print(":::::::::::::::$addsList");
  }

  refreshPage() {
    setState(() {});
  }

  String greeting() {
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  nnavigateLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScreenLoginPage()),
    ).then((value) => refreshPage());
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
            exit(0);
            return true; // true will exit the app
            
          }
        },
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              silverAppbar(context, screenWidth),
              silverList(screenWidth)
            ],
          ),
        ));
  }

  /// SILVER LIST
  SliverList silverList(double width) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text1(textname: "Hey, Good\t"),
                    ),
                    Text1(textname: greeting()),
                  ],
                ),
                Consumer<HomepageCategoryProvider>(
                    builder: (context, value, child) {
                  return value.categoryList != null
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 0),
                          itemCount: value.categoryList!.data!.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _categoryid = int.parse(value
                                      .categoryList!.data![index].categoryId!);
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StoreListingPage(
                                              categoryId: _categoryid,
                                            )));
                              },
                              child: SizedBox(
                                height: 300,
                                width: 50,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                            value.categoryList!.data![index]
                                                .categoryImage!,
                                            fit: BoxFit.cover),
                                      ),
                                      height: width / 5.9,
                                      width: width / 5.9,
                                    ),
                                    height5,
                                    TextStyleWidget(
                                        fontSize: 12,
                                        text: capitalizeAllWord(value
                                            .categoryList!
                                            .data![index]
                                            .categoryTitle!))
                                  ],
                                ),
                              ),
                            );
                          })
                      : const Center(
                          child: SizedBox(
                            height: 300,
                            child: TextInput(text1: "Loading...."),
                          ),
                        );
                }),
                height20,
                FutureBuilder<HomePageAds>(
                  future: ApiServices().getHomepageadsSlider(0),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.data!.isNotEmpty) {
                      var sliderlist = snapshot.data!.data!;

                      return SliderCls(sliderlist, addsList);
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                height40,
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// SILVER APP BAR
  SliverAppBar silverAppbar(
    BuildContext context,
    double width,
  ) {
    return SliverAppBar(
      elevation: .5,
      backgroundColor: Colors.white,
      toolbarHeight: 80,
      collapsedHeight: 80,
      expandedHeight: MediaQuery.of(context).size.height / 2.8,
      automaticallyImplyLeading: false,
      pinned: true,
      leadingWidth: 170,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height20,
          const Padding(
            padding: EdgeInsets.only(left: 0),
            child: TextInput(
              size: 14,
              text1: "Delivering to",
              colorOfText: Colors.black,
              weight: FontWeight.bold,
            ),
          ),
          Provider.of<LocationButtonProvider>(context).locationSelectDropdown(context)
        ],
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.none,
        background: Column(
          children: [
            Container(
              color: Colors.amber.shade50,
              width: width,
              child:
                  Consumer<CartCounterStore>(builder: (context, value, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    value.box.read("token") == null
                        ? _buildGuestUsers(context)
                        : _buildloginUserBanner(width, value)
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Consumer<AddBannerProvider> _buildloginUserBanner(
      double width, CartCounterStore value) {
    return Consumer<AddBannerProvider>(builder: (context, bannerData, child) {
      if (!bannerData.addBanerloader &&
          bannerData.addBannerList!.data!.isNotEmpty) {
        var dataa = bannerData.addBannerList!.data;

        return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(dataa![0].image!), fit: BoxFit.cover)),
            height: MediaQuery.of(context).size.height / 2.9,
            width: width,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                bottom: 20,
              ),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: value.box.read("token") == null
                      ? CustomButton2(
                          height: 35,
                          width: 80,
                          color: primaryColor,
                          buttonName: "Login",
                          buttonAction: () {
                            nnavigateLoginPage();
                          })
                      : SizedBox(
                          width: 100,
                          height: 30,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                color: primaryColor,
                              ),
                              primary: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ScreenStores(
                                            parentCategoryId: bannerData
                                                .addBannerList
                                                ?.data?[0]
                                                .parentCategoryId!,
                                            storeId: int.parse(bannerData
                                                .addBannerList!
                                                .data![0]
                                                .store!),
                                            shoptype: 2,
                                            storename: bannerData.addBannerList!
                                                .data![0].storeName!,
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
    });
  }

  Padding _buildGuestUsers(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text1(
                        textname: "Hey There!",
                      ),
                      height10,
                      const Text2(
                          textName:
                              "Log in or create an account for\na faster ordering experience"),
                      height20,
                      CustomButton2(
                          height: 40,
                          width: 100,
                          color: primaryColor,
                          buttonName: "Login",
                          buttonAction: () {
                            nnavigateLoginPage();
                          }),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3.5,
                  width: MediaQuery.of(context).size.width / 3.5,
                  child: Image.asset('images/h1.png'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategorySinglewidget extends StatelessWidget {
  final obj;
  final void Function()? function;
  final double textsize;
  const CategorySinglewidget({
    Key? key,
    this.function,
    required this.obj,
    required this.textsize,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: SizedBox(
        height: 260,
        width: 50,
        child: Column(
          children: [
            SizedBox(
              child: Image.asset(obj.images),
              height: 50,
              width: 60,
            ),
            height5,
            TextStyleWidget(
              fontSize: textsize,
              text: capitalizeAllWord(obj.names),
            )
          ],
        ),
      ),
    );
  }
}

class HorizonalList extends StatelessWidget {
  const HorizonalList({Key? key, required this.obj}) : super(key: key);
  final ListOfItems obj;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ScreenStores(
                      storeId: 13,
                      parentCategoryId: 'irumbuzhi',
                      storename: 'irumbuzhi',
                      shoptype: 2,
                    )));
      }),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade100),
              borderRadius: BorderRadius.circular(100),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(17.0),
              child: SvgPicture.asset(
                obj.images,
              ),
            ),
          ),
          height10,
          TextStyleWidget(
            fontSize: 12,
            text: capitalizeAllWord(obj.names),
          )
        ],
      ),
    );
  }
}

// class ListOfItemsDeliveryLocation {
//   String titile1;
//   String titile2;
//   bool value;
//   ListOfItemsDeliveryLocation(
//       {required this.titile1, required this.titile2, required this.value});
// }
