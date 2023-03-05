
import 'dart:math';

import '../../modules/login/login_screen.dart';
import '../network/local/cash_helper.dart';
import 'components.dart';

void signOut(context) {
  CashHelper.removeData(key: 'uId').then((value)
  {
    if (value) {
      navigateAndFinish(context, const LoginScreen());
    }
  });
}

String getRandomString(int length){
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  return String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

String? uId = '';
String? city = 'جازان';
String? technicalPhone = '';
/*String city = CashHelper.getData(key: 'city');
String technicalPhone = CashHelper.getData(key: 'technicalPhone');*/
String profileImage = '';
String coverImage = '';

// void printFullText(String text) {
//   final pattern = RegExp('.{1,800}');
//   pattern.allMatches(text).forEach((match) => print(match.group(0)));
// }