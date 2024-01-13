import 'package:flutter/material.dart';
import 'package:pharmazool/api_dio/services_paths.dart';
import 'package:pharmazool/constants_widgets/utils/app_theme_colors.dart';
import 'package:pharmazool/constants_widgets/utils/media_query_values.dart';
import 'package:pharmazool/src/features/patient/patient_layout/presentation/screens/patient_layout.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:pharmazool/mymodels/medicine_model.dart';
import 'package:pharmazool/mymodels/pharmacy_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kGreyColor,
      appBar: AppBar(
        elevation: 0,
        leading: Container(),
        centerTitle: true,
        title: const AutoSizeText(
          "History",
          style: TextStyle(
            color: Colors.black,
            fontSize: 19,
          ),
        ),
        backgroundColor: AppColors.kGreyColor,
      ),
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: pharmacyhistory.length,
        itemBuilder: (context, index) {
          return history(context, pharmacyhistory[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
              // height: context.height * .03,
              );
        },
      ),
    );
  }
}

Widget history(BuildContext context, PharmacyModel model) {
  return Padding(
    padding: const EdgeInsetsDirectional.only(start: 30, end: 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: context.width * 0.8,
          height: context.height * 0.1,
          // height: context.height * .25,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // AppColors.kTealColor,
                AppColors.kGreyColor, Colors.white,
              ],
            ),
            borderRadius:
                BorderRadiusDirectional.horizontal(end: Radius.circular(5)),
            // color: Colors.white,
            // color: Colors.white,
          ),
          child: Row(
            children: [
              //in Column we made  Move Color Alinear
              Column(
                children: [
                  Container(
                    width: context.width * 0.004,
                    height: context.height * 0.04,
                    color: const Color.fromARGB(255, 87, 32, 115),
                    // height: context.height * .25,
                  ),
                  SizedBox(
                    height: context.height * 0.0032,
                  ),
                  CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 87, 32, 115),
                    radius: context.width * 0.01,
                  ),
                  SizedBox(
                    height: context.height * 0.00682,
                  ),
                  Container(
                    width: context.width * 0.004,
                    height: context.height * 0.0397,
                    color: const Color.fromARGB(255, 87, 32, 115),
                    // height: context.height * .25,
                  ),
                ],
              ),
              SizedBox(
                width: context.width * 0.25,
                // height: context.height * 0.04,
                // color: Colors.white,
                child: Center(
                  child: AutoSizeText(
                    '${model.block}:${model.street}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700),
                  ),
                ),
              ),
              Container(
                width: context.width * 0.006,
                height: context.height * 0.1,
                color: AppColors.kGreyColor,
                // height: context.height * .25,
              ),
              SizedBox(
                width: context.width * 0.05,
              ),
              SizedBox(
                height: context.height * 0.02,
              ),
              Expanded(
                child: Text(
                  model.name.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              )
            ],
          ),
        ),
        Row(
          children: [
            SizedBox(width: context.width * 0.008),
            Container(
              width: context.width * 0.004,
              height: context.height * 0.04,
              color: const Color.fromARGB(255, 87, 32, 115),
              // height: context.height * .25,
            ),
          ],
        ),
      ],
    ),
  );
}
