import 'package:pharmazool/constants_widgets/main_widgets/constants.dart';
import 'package:pharmazool/files_doctor/medicine_screen_doctor.dart';
import 'package:pharmazool/files_doctor/nav_screens/search_screen.dart';
import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/utils/strings.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

class HomeScreenDoctor1 extends StatefulWidget {
   HomeScreenDoctor1({super.key});

  @override
  State<HomeScreenDoctor1> createState() => _HomeScreenDoctor1State();
}

class _HomeScreenDoctor1State extends State<HomeScreenDoctor1> {
  TextEditingController searchcontroller = TextEditingController();


  @override
  Widget build(BuildContext context) {
  
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return ConditionalBuilder(
          condition: state is! GetDoctorGroubListLoadingState,
          fallback: (context) {
            return const Center(child: CircularProgressIndicator());
          },
          builder: (context) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.12),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    // shrinkWrap: true,
                    children: [
                      Container(
                        height: 140,
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/logo_11zon_low.png'),
                                fit: BoxFit.cover)),
                      ),
                      const SizedBox(height: 10),
                      //   ShowWidget(
                      //   child: SearchBar1(id:2),
                      // ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          onSubmitted: (value) {
                            AppCubit.get(context).getsearchmedicine(value);
                          },
                          onChanged: (value) {
                            AppCubit.get(context).getsearchmedicine(value);
                          },
                          controller: searchcontroller,
                          style: TextStyle(
                            fontFamily: cairoFont,
                            fontSize: context.height * 0.015,
                          ),
                          decoration: InputDecoration(
                            hintText: 'بحث',
                            hintStyle: TextStyle(
                              fontFamily: cairoFont,
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
                                searchcontroller.text =
                                    await AppCubit.get(context)
                                        .getImageForSeacrhPatient();
                                AppCubit.get(context)
                                    .getsearchmedicine(searchcontroller.text);
                              },
                              child: Image.asset(
                                scan,
                                color: Colors.black,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                        ),
                      ),

                      searchcontroller.text == ""
                          ? SizedBox(
                              height: context.height * .53,
                              child: Container(
                                color: Colors.white,
                                child: GridView.builder(
                                  padding: EdgeInsets.only(
                                      bottom: size.height * 0.1),
                                  shrinkWrap: true,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 2,
                                    mainAxisSpacing: 10,
                                    mainAxisExtent: 130,
                                  ),
                                  itemBuilder: (context, index) {
                                    return homeGridViewDoctor(
                                        homeList[index], context);
                                  },
                                  itemCount: homeList.length,
                                ),
                              ),
                            )
                          : SearchScreenDoctor(
                              searchController: searchcontroller),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

homeGridViewDoctor(HomeIconsModel homeIconModel, BuildContext context) {
  return InkWell(
    onTap: () {
      mycategorymodel = homeIconModel;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MedicineScreenDoctor(
                  int.parse(homeIconModel.genericid.toString()))));
      AppCubit.get(context).getMedicinesByID(id: homeIconModel.genericid!);
    },
    child: SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: context.height * 0.1,
              width: context.height * 0.1,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(
                homeIconModel.icon.toString(),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: context.height * 0.0035,
            ),
            AutoSizeText(
              homeIconModel.title.toString(),
              style: TextStyles.styleblackBold16,
            ),
            SizedBox(
              height: context.height * 0.02,
            ),
          ],
        ),
      ),
    ),
  );
}
