import 'package:fazzmi/presentaion/splashScreen/splashScreen.dart';
import 'package:fazzmi/provider/ProductDetailPageProviderApi.dart';
import 'package:fazzmi/provider/addBannerProvider.dart';
import 'package:fazzmi/provider/addressProvider.dart';
import 'package:fazzmi/provider/cartInStore.dart';
import 'package:fazzmi/provider/deals_provider.dart';
import 'package:fazzmi/provider/hompage_category_provider.dart';
import 'package:fazzmi/provider/locationButtonProvider.dart';
import 'package:fazzmi/provider/notificationProvider.dart';
import 'package:fazzmi/provider/paymentSuccessProvider.dart';
import 'package:fazzmi/provider/productDetailPageProvider.dart';
import 'package:fazzmi/provider/searchPageprovider.dart';
import 'package:fazzmi/provider/sliderProvider.dart';
import 'package:fazzmi/provider/storeSubCategoryProvider.dart';
import 'package:fazzmi/provider/timerProvider.dart';
import 'package:fazzmi/widgets/sample.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'provider/cartTotalGstProvider.dart';
import 'provider/faq_provider.dart';
import 'provider/myOrderProvider.dart';
import 'provider/shippingAddressConfirmationProvider.dart';
import 'provider/subCategoryProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  DynamicLinks.initialize(FirebaseDynamicLinks.instance);
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartCounterStore>(
          create: (context) => CartCounterStore(),
        ),
        ChangeNotifierProvider<SliderProvider>(
            create: (context) => SliderProvider()),
        ChangeNotifierProvider<SearchPageProvider>(
            create: (_) => SearchPageProvider()),
        ChangeNotifierProvider<ProductDetailPageProvider>(
          create: (context) => ProductDetailPageProvider(),
        ),
        ChangeNotifierProvider<NotificationProvider>(
          create: (context) => NotificationProvider(),
        ),
        ChangeNotifierProvider<HomepageCategoryProvider>(
            create: (_) => HomepageCategoryProvider()),
        ListenableProvider<LocationButtonProvider>(
            create: (_) => LocationButtonProvider(_)),
        ChangeNotifierProvider<FaqProvider>(create: (_) => FaqProvider()),
        ChangeNotifierProvider<AddBannerProvider>(
            create: (_) => AddBannerProvider()),
        ChangeNotifierProvider<MyOrderProvider>(
            create: (_) => MyOrderProvider()),
        ChangeNotifierProvider<CartTotalGstProvider>(
            create: (_) => CartTotalGstProvider()),
        ChangeNotifierProvider<ShipppingAddressConfirmProvider>(
            create: (_) => ShipppingAddressConfirmProvider(_)),
        // ChangeNotifierProvider<ProductProvider>(
        //     create: (_) => ProductProvider(_)),
        ChangeNotifierProvider<SubCategoryProvider>(
            create: (_) => SubCategoryProvider(_)),
        ChangeNotifierProvider<ProductDetailPageProviderApi>(
            create: (_) => ProductDetailPageProviderApi()),
        ChangeNotifierProvider<StoreSubCategoryProvider>(
            create: (_) => StoreSubCategoryProvider()),
        ChangeNotifierProvider<PaymentSuccessPageProvider>(
            create: (_) => PaymentSuccessPageProvider()),
        ChangeNotifierProvider<AddressProvider>(
            create: (_) => AddressProvider()),
        ChangeNotifierProvider<DealsProvider>(create: (_) => DealsProvider()),
        ListenableProvider<TimerProvider>(create: (_) => TimerProvider()),
      ],
      child: MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        title: 'Fazzmi',
        theme: ThemeData(
          useMaterial3: false,
          colorScheme: ColorScheme.fromSwatch(
            backgroundColor: Colors.red,
            primarySwatch: Colors.red,
          ),
        ),
       home: const SplashScreen(),
     //  home: DemoScreen(),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
