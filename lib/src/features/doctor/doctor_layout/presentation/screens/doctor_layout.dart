import 'package:pharmazool/constants_widgets/utils/log_out_methode.dart';
import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/custom/signout_widget.dart';
import 'package:pharmazool/src/core/utils/app_strings.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

class HomeLayoutDoctor extends StatefulWidget {
  const HomeLayoutDoctor({super.key});

  @override
  State<HomeLayoutDoctor> createState() => _HomeLayoutDoctorState();
}

class _HomeLayoutDoctorState extends State<HomeLayoutDoctor> {
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey();
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return WillPopScope(
          onWillPop: () async {
            showCheckSignOut();
            return false;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: key,
            appBar: AppBar(
              elevation: 0,
              title: const AutoSizeText(
                "الرئيسية",
                style: TextStyles.styleblack19,
              ),
              leading: Container(),
              backgroundColor: Colors.white,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            endDrawer: const DoctorDrawer(),
            backgroundColor: Colors.white,
            floatingActionButton: const FloatingBotton(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            extendBody: true,
            bottomNavigationBar: bottomMainNavWidget(cubit, _pageController),
            body: SizedBox.expand(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  cubit.changeBottomNAv(index, _pageController);
                },
                children: [
                  HomeScreenDoctor1(),
                  const HistoryScreen(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  showCheckSignOut() {
    showDialog(
        context: context,
        builder: (context) {
          return SignOutWidget(
            onPress: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) {
                  return const OnBoardingScreen();
                }),
                (Route<dynamic> route) => false,
              );
              LogOut(context);
              setState(() {
                DoctoruserName = '';
                Doctortoken = null;
                uId = null;
              });
            },
          );
        });
  }
}
