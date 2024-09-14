import 'package:fazzmi/core/constants/constants.dart';
import 'package:fazzmi/presentaion/notifications/section1.dart';
import 'package:fazzmi/provider/notificationProvider.dart';
import 'package:fazzmi/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/commonMethods.dart';

class ScreenNotifications extends StatefulWidget {
  const ScreenNotifications({Key? key}) : super(key: key);

  @override
  State<ScreenNotifications> createState() => _ScreenNotificationsState();
}

class _ScreenNotificationsState extends State<ScreenNotifications> {
  @override
  void initState() {
    loadData();

    super.initState();
  }

  loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<NotificationProvider>(context, listen: false)
          .getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scafoldBackgroundColor,
      appBar: const CustomAppBar(
        icon: Icons.arrow_back_ios,
        title: "Notifications",
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(children: [
          height10,
          Expanded(
            child: Consumer<NotificationProvider>(
                builder: (context, value, child) {
              if (!value.loader) {
                return ListView(
                  children: List.generate(
                      value.notificationList!.data!.length,
                      (index) => WithoutIconWidget(
                          time: dateTimeConversion(DateTime.parse(
                              value.notificationList!.data![index]!.created!)),
                          paragraph:
                              value.notificationList!.data![index]!.content!,
                          text2: value.notificationList!.data![index]!.title!)),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
          ),
          // const WithoutIconWidget(
          //   paraBold: textOnStarting,
          //   text2: "Didn't you deliver",
          //   paragraph: textonparagraph,
          //   time: "7 minutes ago",
          // ),
          // Divider(),
          // WithIconWidget(
          //   parabold: textOnStarting,
          //   time: "7 minutes ago",
          //   paragraph: textonparagraph,
          //   image1: "images/24_NOTIFICATIONS-40.png",
          //   color1: Colors.white,
          //   text2: "Good job!",
          // ),
          // Divider(),
          // WithoutIconWidget(
          //   text2: "Hi Brawn, please",
          //   paraBold: textOnStarting,
          //   paragraph: textonparagraph,
          //   time: "7 minutes ago",
          // ),
          // Divider(),
          // WithIconWidget(
          //   paragraph: textonparagraph,
          //   time: "7 minutes ago",
          //   parabold: textOnStarting,
          //   text2: "Floria Fernandas",
          //   image1: "images/24_NOTIFICATIONS-32.png",
          //   color1: Colors.white,
          // ),
          // Divider(),
          // WithoutIconWidget(
          //   text2: "You got a gift, want to see ?",
          //   time: "7 minutes ago",
          // ),
          // Divider(),
          // WithoutIconWidget(
          //   text2: "Hi Brawn, please",
          //   time: "7 minutes ago",
          // ),
        ]),
      ),
    );
  }
}
