import 'package:fazzmi/provider/faq_provider.dart';
import 'package:fazzmi/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/constants.dart';
import '../../../widgets/textInput.dart';

class ScreenFaq extends StatefulWidget {
  const ScreenFaq({Key? key}) : super(key: key);
  @override
  State<ScreenFaq> createState() => _ScreenFaqState();
}

class _ScreenFaqState extends State<ScreenFaq> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<FaqProvider>(context, listen: false).getFaqDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Frequently Asked Questions",
        icon: Icons.arrow_back_ios,
      ),
      body: Consumer<FaqProvider>(builder: (context, value, child) {
        if (!value.faqloader) {
          var data = value.faqlList!.data;
          return ListView.separated(
            itemCount: value.faqlList!.data!.length,
            itemBuilder: (context, index) {
              return ExpansionWidget(
                title: data![index].title!,
                comment: data[index].comment!,
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}

class ExpansionWidget extends StatefulWidget {
  final String title;
  final String comment;
  const ExpansionWidget({
    Key? key,
    required this.title,
    required this.comment,
  }) : super(key: key);

  @override
  State<ExpansionWidget> createState() => _ExpansionWidgetState();
}

class _ExpansionWidgetState extends State<ExpansionWidget> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Theme(
      //Theme
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
        expansionTileTheme: ExpansionTileThemeData(
          iconColor: Colors.grey,
          backgroundColor: _isExpanded ? Colors.grey.withOpacity(0.2) : null,
        ),
      ),
      child: Column(
        children: [
          ExpansionTile(
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            childrenPadding: const EdgeInsets.fromLTRB(15, 5, 10, 10),
            title: TextInput(
              text1: widget.title,
              colorOfText: primaryColor,
              maxLines: 10,
            ),
            children: [
              TextInput(
                text1: widget.comment,
                maxLines: 50,
              ),
            ],
            onExpansionChanged: (expand) {
              setState(() {
                _isExpanded = expand;
              });
            },
          ),
          Divider(
            height: 0,
            color: Colors.grey.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
