import 'package:flutter/widgets.dart';

import 'api_services.dart';

class Route {
  var token = box.read("token");

  homePage(params) async {
    // var url = baseUrl + endUrl;

    // Navigator.push(context, "LoadScreen")

    Map<String, dynamic> pageConfig = {
      "MainBanner": {
        "status": "success",
        "required": true,
        "show": true,
        "icon": "icon-1",
        "message": "NoData"
      },
      "Categories": {"status": "empty", "required": true, "show": true},
      "AdBanner": {"status": "fail", "required": false, "show": true}
    };

    print(pageConfig["MainBanner"]["status"]); // Output: success

    // var Categories = ApiServices.getCategories("jhgkhghmbm");

    // if (!Categories && pageConfig["Categories"]["required"]) {
    //   abort;
    //   Go_to_previous_page; Show_Error_Popup
    // }

    // if (Categories && count(Categories) === 0 ) {
    //   pageConfig["Categories"]["show"] = true;
    // }

    // Send 'pageConfig' Variable, And Categories Variable to the below screen
    // Navigator.pushReplacement(context, "ActualScreen");
  }
}
