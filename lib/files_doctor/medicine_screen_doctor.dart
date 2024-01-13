import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pharmazool/api_dio/services_paths.dart';
import 'package:pharmazool/app_cubit/cubit.dart';
import 'package:pharmazool/app_cubit/states.dart';

import 'package:pharmazool/constants_widgets/utils/media_query_values.dart';
import 'package:pharmazool/constants_widgets/main_widgets/loadingwidget.dart';

import 'package:pharmazool/app/patient/category_screens/locationinfo.dart';
import 'package:pharmazool/mymodels/medicine_model.dart';
import 'package:pharmazool/mymodels/pharmacy_model.dart';

import '../constants_widgets/utils/app_theme_colors.dart';
import '../constants_widgets/utils/assets_images_path.dart';

import '../../../files_doctor/nav_screens/floating_botton.dart';

class MedicineScreenDoctor extends StatefulWidget {
  int? id;

  MedicineScreenDoctor(this.id);

  @override
  State<MedicineScreenDoctor> createState() => _MedicineScreenDoctorState();
}

class _MedicineScreenDoctorState extends State<MedicineScreenDoctor> {
  int page = 1;
  ScrollController controller = ScrollController();
  void scrolllistener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      page++;
      print(widget.id);
      print(AppCubit.get(context).medicinesbyId.length);
      print(page);
      AppCubit.get(context).medicinelistpagination(
          id: widget.id!,
          medicinelist: AppCubit.get(context).medicinesbyId,
          page: page,
          search: searchcontrolled.text);
      print('yess');
    } else {
      print(controller.position.pixels);
    }
  }

  var searchcontrolled = TextEditingController();

  @override
  void initState() {
    controller.addListener(scrolllistener);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);

    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green.withOpacity(0.7),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                ),
                onPressed: () {
                  AppCubit.get(context).searcher = '';
                  Navigator.pop(context);
                },
              ),
              // title: const Text(''),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                searchcontrolled.text =
                    await cubit.getGalleryImageForPatientSearch();
              },
              child: Image.asset(
                // cacheHeight: 20,
                scan,
                color: Colors.black,
                fit: BoxFit.scaleDown,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                          height: context.height * 0.5,
                          decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.7),
                              borderRadius: const BorderRadiusDirectional.only(
                                  bottomStart: Radius.circular(50),
                                  bottomEnd: Radius.circular(50)))),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(top: 0.0),
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 20, right: 20),
                                  child: Container(
                                    width: context.width * 0.99,
                                    height: context.height * .79,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        // textDirection: TextDirection.rtl,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            margin: const EdgeInsets.only(
                                                top: 20, bottom: 20),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(27),
                                              color: const Color(0xffB8F2EE),
                                            ),
                                            child: TextField(
                                              controller: searchcontrolled,
                                              style: TextStyle(
                                                fontSize:
                                                    context.height * 0.015,
                                              ),
                                              onSubmitted: (value) {
                                                cubit.getMedicinesByID(
                                                    id: widget.id!,
                                                    search:
                                                        searchcontrolled.text);
                                                cubit.searcher = '';
                                              },
                                              decoration: InputDecoration(
                                                hintText: 'بحث',
                                                hintStyle: const TextStyle(
                                                  color: Color(0xFF949098),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          27.0),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 8,
                                                ),
                                                prefixIcon: Icon(
                                                  Icons.search,
                                                  size: context.height * 0.03,
                                                  color: Color(0xFF949098),
                                                ),
                                                suffixIcon: InkWell(
                                                  onTap: () {
                                                    cubit.getPostImage2();
                                                  },
                                                  child: Image.asset(
                                                    // cacheHeight: 20,
                                                    scan,
                                                    color: Colors.black,
                                                    fit: BoxFit.scaleDown,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            height: context.height * .67,
                                            child: ConditionalBuilder(
                                              condition: state
                                                  is! GetMedicinesByIdLoadingState,
                                              fallback: (context) => Container(
                                                color: Colors.white,
                                                child: loading(),
                                              ),
                                              builder: (context) {
                                                return SizedBox(
                                                  width: double.infinity,
                                                  height: context.height * .70,
                                                  child: ListView(
                                                      controller: controller,
                                                      children: [
                                                        ...List.generate(
                                                            cubit.medicinesbyId
                                                                .length,
                                                            (index) {
                                                          return pharmacymedicineitem(
                                                            cubit.medicinesbyId[
                                                                index],
                                                          );
                                                        }),
                                                        state is IncreamentOfMedicineListLoadingState
                                                            ? Center(
                                                                child:
                                                                    loading())
                                                            : const SizedBox()
                                                      ]),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget pharmacymedicineitem(MedicineModel model) {
    getBytesDoctor(imageurl) {
      var bytes = Uri.parse(imageurl);
      return bytes.data!.contentAsBytes();
    }

    model.image ??=
        'https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(70),
            side: const BorderSide(width: 2, color: Colors.teal)),
        color: Colors.white,
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
                width: 60,
                height: 60,
                child: model.image!.contains('base64')
                    ? Image.memory(
                        getBytesDoctor(model.image),
                        scale: 2.0,
                        errorBuilder: (BuildContext context, exception,
                            StackTrace? stackTrace) {
                          return const Center(
                              child: Icon(
                            Icons.notification_important,
                          ));
                        },
                      )
                    : FadeInImage.assetNetwork(
                        placeholder: 'assets/images/default_loading.jpg',
                        placeholderScale: 2,
                        imageScale: 1,
                        image: model.image!,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Text('error occured');
                        },
                        fit: BoxFit.fill,
                      )),
          ),
          title: Text(model.name.toString(),
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
          trailing: Switch(
            value: model.status!,
            onChanged: (value) {
              if (model.status == true) {
                AppCubit.get(context).deletepharmacymedicine(
                    int.parse(model.id!),
                    int.parse(pharmamodel!.id!),
                    context,
                    widget.id!);
              } else {
                AppCubit.get(context).addpharmacymedicine(int.parse(model.id!),
                    int.parse(pharmamodel!.id!), context, widget.id!);
              }
              setState(() {
                model.status = value;
              });
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
        ),
      ),
    );
  }
}
