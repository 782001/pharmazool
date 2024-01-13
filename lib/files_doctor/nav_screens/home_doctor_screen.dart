import 'package:pharmazool/constants_widgets/main_widgets/constants.dart';
import 'package:pharmazool/files_doctor/medicine_screen_doctor.dart';
import 'package:pharmazool/files_doctor/nav_screens/search_screen.dart';
import 'package:pharmazool/src/core/config/routes/app_imports.dart';

class HomeScreenDoctor1 extends StatelessWidget {
  const HomeScreenDoctor1({Key? key}) : super(key: key);

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
              body: Padding(

                padding:   EdgeInsets.only(bottom:size.height*  0.12 ),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // shrinkWrap: true,
                  children: [
                    Container(
                      height: 140,
                      padding:
                          const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/logo_11zon_low.png'),
                              fit: BoxFit.cover)),
                    ),
                    const SizedBox(height: 10),
                    ShowWidget(
                      child: SearchBar1(() {
                        cubit.getsearchmedicine('');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SearchScreenDoctor()));
                      }),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: GridView.builder(
                          padding: EdgeInsets.only(bottom: size.height * 0.1),
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
                            return homeGridViewDoctor(homeList[index], context);
                          },
                          itemCount: homeList.length,
                        ),
                      ),
                    ),
                  ],
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
      physics: NeverScrollableScrollPhysics(),
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
              style: const TextStyle(
                  color: Colors.black,
                  // fontSize: context.height * 0.017,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Schyler'),
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
