
import 'package:fazzmi/helper/dialog_helper.dart';
import 'package:fazzmi/services/app_exception.dart';

class BaseController {
  void handleError(error) {
    hideLoading();

    if (error is BadRequestException) {
      var message = error.message;

      DialogHelper.showErrorDialog(description: message);
    } else if (error is FetchDataException) {
      var message = error.message;

      DialogHelper.showErrorDialog(description: message);
    } else if (error is ApiNotRespondingException) {
      var message = error.message;

      DialogHelper.showErrorDialog(
          description: "Oops! it took longer to respond.");
    }
  }

  showLoading([String? message]) {
    DialogHelper.showLoading(message);
  }

  hideLoading() {
    DialogHelper.hideLoading();
  }
}
