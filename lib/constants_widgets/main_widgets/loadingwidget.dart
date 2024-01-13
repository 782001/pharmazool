import 'package:flutter/material.dart';

Widget loading() {
  return const Center(
    child: Image(
      width: 70,
      height: 70,
      image: AssetImage('assets/images/pharmaloading.gif'),
    ),
  );
}
