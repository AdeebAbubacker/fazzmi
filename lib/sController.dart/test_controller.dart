
import 'package:fazzmi/sController.dart/base_controller.dart';
import 'package:fazzmi/services/baseClient.dart';

class TestController with BaseController {
  void getData() async {
    showLoading("Fetching data");

    var response = await BaseClientt()
        .get("http://jsonplaceholder.typicodew.com", "/todos/1")
        .catchError(handleError);
    if (response == null) return;
    hideLoading();
  }

  void postData() async {
    var request = {"message": "CodeX sucks!!!"};
    showLoading("posting data...");
    var response = await BaseClientt()
        .post("http://jsonplaceholder.typicodee.com", "/posts", request)
        .catchError(handleError);
    if (response == null) return;

    hideLoading();
  }
}
