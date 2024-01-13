import 'package:pharmazool/src/core/config/routes/app_imports.dart';

class LocationInfo extends StatefulWidget {
  final String id;

  const LocationInfo(this.id, {super.key});

  @override
  State<LocationInfo> createState() => _LocationInfoState();
}

class _LocationInfoState extends State<LocationInfo> {
  late TextEditingController area;
  late TextEditingController locality;
  late TextEditingController stateController;
  AppCubit? appCubit;
  ProfilePharmacyCubit? profileCubit;

  @override
  void initState() {
    area = TextEditingController();
    locality = TextEditingController();
    stateController = TextEditingController();
    appCubit = BlocProvider.of<AppCubit>(context);
    profileCubit = BlocProvider.of<ProfilePharmacyCubit>(context);
    appCubit?.getAreaList();
    appCubit?.getLocalityList();
    appCubit?.getStateList();
    appCubit?.getpharmacies();
    AppCubit.get(context).getCurrentLocation();
    super.initState();
  }

  @override
  void dispose() {
    area.dispose();
    locality.dispose();
    stateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(elevation: 0),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.teal,
            ),
            Column(
              children: [
                const SizedBox(
                  child: Text(
                    'حددالولايةاوالمحليةاوالمنطقة ثم اضغط بحث و سيقوم فارمازول بالبحث عن دواءك في الصيدليات المتوفرة بها',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(70)),
                    ),
                    width: double.infinity,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BlocBuilder<AppCubit, AppStates>(
                          builder: (context, state) {
                            var cubit = AppCubit.get(context);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //الولاية

                                CustomSelectAreaAndLocalityTextField(
                                  controller: stateController,
                                  labelText: "الولاية",
                                  onPressCancel: () => stateController.clear(),
                                  onPress: () {
                                    setState(() {
                                      showStatePicker(
                                        context: context,
                                        stateList:
                                            appCubit?.stateModel?.data ?? [],
                                        result: stateController,
                                      );
                                    });
                                  },
                                ),

                                //المحلية
                                CustomSelectAreaAndLocalityTextField(
                                  controller: locality,
                                  onPressCancel: () => locality.clear(),
                                  labelText: 'المحلية',
                                  onPress: () {
                                    setState(() {
                                      showLocalityPicker(
                                        context: context,
                                        listLocality:
                                            profileCubit?.localityList ?? [],
                                        result: locality,
                                      );
                                    });
                                  },
                                ),
                                //المنطقة
                                CustomSelectAreaAndLocalityTextField(
                                  controller: area,
                                  onPressCancel: () => area.clear(),
                                  labelText: 'المنطقة',
                                  onPress: () {
                                    setState(() {
                                      showAreaPicker(
                                        context: context,
                                        areaList:
                                            profileCubit?.filterAreaList ?? [],
                                        result: area,
                                      );
                                    });
                                  },
                                ),

                                SearchButtonAreaAndLocalityAndState(
                                  area: area,
                                  locality: locality,
                                  stateController: stateController,
                                ),
                                const SizedBox(height: 50),
                                const Text(
                                  'او قم بالبحث عن طريق موقعك',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 50),
                                Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      color: Colors.teal,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: TextButton(
                                      child: const Text(
                                        'البحث عن طريق موقعي',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () {
                                        AppCubit.get(context).getpharmacies(
                                            id: int.parse(widget.id.toString()),
                                            area: area.text,
                                            locality: locality.text,
                                            street: stateController.text);

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const NearbyPharmacies()));
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        )),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

class CustomSelectAreaAndLocalityTextField extends StatelessWidget {
  const CustomSelectAreaAndLocalityTextField({
    Key? key,
    required this.controller,
    required this.onPress,
    required this.labelText,
    required this.onPressCancel,
    this.readOnly,
    this.validator,
  }) : super(key: key);
  final TextEditingController controller;
  final VoidCallback onPress;
  final VoidCallback onPressCancel;
  final String labelText;
 final String? Function(String?)? validator;
final  bool? readOnly;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(width: 1),
            borderRadius: BorderRadius.circular(10.0)),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: labelText,
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                ),
                textAlign: TextAlign.right,
                controller: controller,
                readOnly: readOnly ?? true,
                onTap: onPress,
                validator: validator,
              ),
            ),
            IconButton(onPressed: onPressCancel, icon: const Icon(Icons.cancel))
          ],
        ),
      ),
    );
  }
}

class SearchButtonAreaAndLocalityAndState extends StatelessWidget {
  const SearchButtonAreaAndLocalityAndState({
    Key? key,
    required this.locality,
    required this.area,
    required this.stateController,
  }) : super(key: key);
  final TextEditingController locality;
  final TextEditingController area;
  final TextEditingController stateController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePharmacyCubit, ProfilePharmacyState>(
      builder: (context, state) {
        var profileCubit = ProfilePharmacyCubit.get(context);
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: Colors.teal, borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextButton(
              child: const Text(
                'بحث',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PharmasyScreen()));

                profileCubit.filterPharmacyByLocalityAndStateAndArea(
                    locality: locality.text,
                    area: area.text,
                    state: stateController.text);
              },
            ),
          ),
        );
      },
    );
  }
}
