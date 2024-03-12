import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pharmazool/app/patient/category_screens/widgets/pharmacy_item.dart';
import 'package:pharmazool/constants_widgets/main_constants.dart';
import 'package:pharmazool/constants_widgets/utils/media_query_values.dart';
import 'package:pharmazool/mymodels/pharmacy_model.dart';
import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/utils/styles.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants_widgets/utils/app_theme_colors.dart';

class MapScreen extends StatefulWidget {
  PharmacyModel model;

  MapScreen(this.model, {super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Map<String, Marker> markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    markers.clear();
    setState(() {
      final marker = Marker(
        markerId: MarkerId(name!),
        position: LatLng(lat!, long!),
        infoWindow: InfoWindow(title: name, snippet: address, onTap: () {}),
        onTap: () {
          print("Clicked on marker");
        },
      );

      markers[name!] = marker;
    });
  }

  GlobalKey mapKey = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ShowCaseWidget.of(context).startShowCase([mapKey]));
  }

  @override
  Widget build(BuildContext context) {
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
            Navigator.pop(context);
          },
        ),
        // title: const Text(''),
      ),
      body: Column(
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
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Container(
                            width: context.width * 0.9,
                            height: context.height * .798,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Column(
                                    children: [
                                      PharmacyItem(model: widget.model),
                                      SizedBox(
                                        height: context.height * 0.05,
                                      ),
                                      Container(
                                        width: context.width * 0.8,
                                        height: context.height * .4,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Showcase(
                                          key: mapKey,
                                          descriptionTextDirection:
                                              TextDirection.rtl,
                                          descTextStyle:
                                              TextStyles.styleblackDefault,
                                          description:
                                              "لتحديد مسار من موقعك الحالي الى موقع الصيدلية قم بالضغط على رمز الموقع اعلاه",
                                          child: GoogleMap(
                                            onMapCreated: _onMapCreated,
                                            initialCameraPosition:
                                                CameraPosition(
                                              target: LatLng(lat!, long!),
                                              zoom: 14.8,
                                            ),
                                            markers: markers.values.toSet(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: context.height * 0.02),
                                    ],
                                  )),
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
    );
  }
}

class CardWidget extends StatelessWidget {
  PharmacyModel model;

  CardWidget(this.model, {super.key});

  // bool ExpanasionTouche = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: context.width * 0.8,
        // height: context.height * .25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          color: const Color(0xffB8F2EE),
          // color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      width: context.width * 0.21,
                      height: context.height * 0.15,
                      child: IconButton(
                        icon: const Icon(
                          Icons.phone_rounded,
                          size: 30,
                        ),
                        onPressed: () async {
                          if (await canLaunch('tel:${model.phone}')) {
                            await launch('tel:${model.phone}');
                          }
                        },
                      )),
                  SizedBox(
                    width: context.width * .025,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AutoSizeText(
                          model.name ?? '..',
                          style: TextStyles.stylebold29,
                        ),
                        AutoSizeText(
                          model.area ?? '..',
                          style: TextStyles.stylebold29,
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: AutoSizeText(
                            model.address ?? '',
                            maxLines: 3,
                            style: TextStyles.styleellipsisbold13,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
