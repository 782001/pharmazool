import 'package:flutter/material.dart';
import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/network/local/cashhelper.dart';

void LogOut(context)async =>await CashHelper.RemoveData(key: 'uId').then((value) {
      if (value) {
        print("Loged Out done");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) {
            return const OnBoardingScreen();
          }),
          (Route<dynamic> route) => false,
        );
      }
    });
