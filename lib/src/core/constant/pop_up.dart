import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmazool/src/core/config/routes/app_imports.dart';
 
flutterToast({required String msg, Color? color}) {
  return Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 2,
    backgroundColor: color ?? Colors.teal,
    textColor: Colors.white,
    fontSize: 14.0,
  );
}
