import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmazool/api_dio/services_paths.dart';
import 'package:pharmazool/app_cubit/cubit.dart';
import 'package:pharmazool/app_cubit/states.dart';
import 'package:pharmazool/constants_widgets/utils/app_theme_colors.dart';
import 'package:pharmazool/constants_widgets/utils/assets_images_path.dart';
import 'package:pharmazool/constants_widgets/utils/media_query_values.dart';
import 'package:pharmazool/constants_widgets/main_widgets/loadingwidget.dart';
import 'package:pharmazool/mymodels/medicine_model.dart';

class SearchScreenDoctor extends StatefulWidget {
  const SearchScreenDoctor({super.key});

  @override
  State<SearchScreenDoctor> createState() => _SearchScreenDoctorState();
}

class _SearchScreenDoctorState extends State<SearchScreenDoctor> {
  var searchcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: ConditionalBuilder(
            fallback: (context) => Container(
              color: Colors.white,
              child: loading(),
            ),
            condition: state is! GetMedicinesByIdLoadingState,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  TextField(
                    onSubmitted: (value) {
                      AppCubit.get(context).getsearchmedicine(value);
                    },
                    controller: searchcontroller,
                    style: TextStyle(
                      fontSize: context.height * 0.015,
                    ),
                    decoration: InputDecoration(
                      hintText: 'بحث',
                      hintStyle: TextStyle(
                        color: const Color(0xFF949098),
                        fontSize: context.height * 0.018,
                      ),
                      filled: true,
                      fillColor: AppColors.kGreyColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: context.height * 0.03,
                        color: const Color(0xFF949098),
                      ),
                      suffixIcon: InkWell(
                        onTap: () async {
                          searchcontroller.text = await AppCubit.get(context)
                              .getImageForSeacrhPatient();
                        },
                        child: Image.asset(
                          scan,
                          color: Colors.black,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemBuilder: (context, index) {
                      return pharmacymedicineitem(
                          AppCubit.get(context).searchList[index]);
                    },
                    itemCount: AppCubit.get(context).searchList.length,
                  ))
                ]),
              );
            },
          ),
        );
      },
    );
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
                AppCubit.get(context).deletesearchpharmacymedicine(
                    int.parse(model.id!),
                    int.parse(pharmamodel!.id!),
                    context,
                    searchcontroller.text);
              } else {
                AppCubit.get(context).addsearchpharmacymedicine(
                    int.parse(model.id!),
                    int.parse(pharmamodel!.id!),
                    context,
                    searchcontroller.text);
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
