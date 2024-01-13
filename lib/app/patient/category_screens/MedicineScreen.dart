
import 'package:auto_size_text/auto_size_text.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmazool/app_cubit/cubit.dart';
import 'package:pharmazool/app_cubit/states.dart';
import 'package:pharmazool/constants_widgets/utils/media_query_values.dart';
import 'package:pharmazool/constants_widgets/main_widgets/loadingwidget.dart';
import 'package:pharmazool/app/patient/category_screens/locationinfo.dart';
import 'package:pharmazool/constants_widgets/main_constants.dart';
import 'package:pharmazool/mymodels/medicine_model.dart';
import '../../../constants_widgets/utils/app_theme_colors.dart';
import '../../../constants_widgets/utils/assets_images_path.dart';
import '../nav_screens/BottomNavBarWidget.dart';

class MedicineScreen extends StatefulWidget {
  int? id;

  MedicineScreen(this.id);

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  int page = 1;
  ScrollController controller = ScrollController();
  void scrolllistener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      page++;
      AppCubit.get(context).medicinelistpagination(
          id: widget.id!,
          medicinelist: AppCubit.get(context).medicinesbyId,
          page: page,
          search: searchcontrolled.text);

      print(page);
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
    searchcontrolled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);

    return BlocBuilder<AppCubit, AppStates>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.kGreyColor,
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                    padding: const EdgeInsetsDirectional.only(top: 20.0),
                    child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: context.height * .025,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, left: 20, right: 20),
                              child: Container(
                                width: context.width * 0.95,
                                height: context.height * .7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      // textDirection: TextDirection.rtl,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          margin: const EdgeInsets.only(
                                              top: 40, bottom: 20),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(27),
                                            color: const Color(0xffB8F2EE),
                                          ),
                                          child: TextField(
                                            controller: searchcontrolled,
                                            style: TextStyle(
                                              fontSize: context.height * 0.015,
                                            ),
                                            onSubmitted: (value) {
                                              cubit
                                                  .searchGenericMedicinePatient(
                                                      searchcontrolled.text,
                                                      widget.id!);
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'بحث',
                                              hintStyle: const TextStyle(
                                                color: Color(0xFF949098),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(27.0),
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
                                                onTap: () async {
                                                  searchcontrolled.text =
                                                      await cubit
                                                          .getImageForSeacrhPatient();
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
                                        ConditionalBuilder(
                                          condition: state
                                                  is! GetMedicinesByIdLoadingState &&
                                              state
                                                  is! SearchGenericMedicinePatientLoadingState,
                                          fallback: (context) => Container(
                                            color: Colors.white,
                                            child: loading(),
                                          ),
                                          builder: (context) {
                                            return SizedBox(
                                              width: double.infinity,
                                              height: context.height * .50,
                                              child: ListView(
                                                  controller: controller,
                                                  children: [
                                                    ...List.generate(
                                                        cubit.medicinesbyId
                                                            .length, (index) {
                                                      return medicineItem(
                                                          cubit.medicinesbyId[
                                                              index],
                                                          context);
                                                    }),
                                                    state is IncreamentOfMedicineListLoadingState
                                                        ? Center(
                                                            child: loading())
                                                        : const SizedBox()
                                                  ]),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                            top: 0,
                            bottom: context.height * .64,
                            child:
                                Image.asset(mycategorymodel!.icon.toString())),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavWidget(
          cubit: cubit,
        ),
      );
    });
  }
}

Widget medicineItem(MedicineModel medicineModel, context) {
  getBytes2(imageurl) {
    var bytes = Uri.parse(imageurl);
    return bytes.data!.contentAsBytes();
  }

  medicineModel.image ??=
      'https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        color: const Color(0xffB8F2EE),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13.0)),
                    clipBehavior: Clip.antiAlias,
                    width: 70,
                    height: 70,
                    child: medicineModel.image!.contains('base64')
                        ? Image.memory(
                            getBytes2(medicineModel.image),
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
                            image: medicineModel.image!,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.image_not_supported_rounded,
                                color: Colors.red,
                              );
                            },
                            fit: BoxFit.fill,
                          )

                    //Image.network(
                    //medicineModel.image!.toString().contains('string')
                    //  ? 'https://resize.indiatvnews.com/en/resize/newbucket/730_-/2021/12/omicron-med-1639726841.jpg'
                    //: medicineModel.image.toString(),
                    //fit: BoxFit.cover,
                    //errorBuilder: (BuildContext context, Object exception,
                    //  StackTrace? stackTrace) {
                    //return const Text('loading failed');
                    // },
                    //),
                    ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      medicineModel.name.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: TextButton(
                  onPressed: () {
                    BlocProvider.of<AppCubit>(context).getAreaList();
                    BlocProvider.of<AppCubit>(context).getLocalityList();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            LocationInfo(medicineModel.id.toString())));
                  },
                  child: const AutoSizeText(
                    'بحث',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      ),
    ),
  );
}
