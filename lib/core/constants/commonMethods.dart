// capitalization
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

String capitalizeAllWord(String value) {
  var result = value[0].toUpperCase();
  for (int i = 1; i < value.length; i++) {
    if (value[i - 1] == " ") {
      result = result + value[i].toUpperCase();
    } else {
      result = result + value[i];
    }
  }
  return result;
}

// caluculate percentage
calcPercentage(price, offerP) {
  var percentage = ((offerP - price) / price) * 100;

  if (percentage.isInfinite) {
    return '';
  }
  if (percentage.isNaN) {
    return '';
  } else {
    return '${percentage.toInt()}% OFF';
  }
}

/// lounchUrlFunction
Future<void> launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}

/// Date time method

DateTime now = DateTime.now();

dateTimeConversion(DateTime time) {
  var actualDay = time.day;
  var nowdat = now.day;
  var differce = (actualDay - nowdat).abs();

  var actualtime = "${time.day} - ${time.month} - ${time.year}";
  if (differce == 0) {
    return "Today";
  }
  if (differce < 12) {
    return "$differce days ago";
  } else {
    return actualtime;
  }
}

deliveryDataConversion(DateTime time) {
  var deliveryDate = DateFormat.yMMMEd().format(time);
  return deliveryDate;
}
