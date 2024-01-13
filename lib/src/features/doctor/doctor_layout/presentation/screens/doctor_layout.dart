import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/custom/signout_widget.dart';

class HomeLayoutDoctor extends StatefulWidget {
  const HomeLayoutDoctor({Key? key}) : super(key: key);

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
            key: key,
            appBar: AppBar(
              elevation: 0,
              title: const AutoSizeText(
                "الرئيسية",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 19,
                ),
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
                children: const [
                  HomeScreenDoctor1(),
                  HistoryScreen(),
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  return const OnBoardingScreen();
                }),
              );
              setState(() {
                userName = '';
                token = '';
              });
            },
          );
        });
  }
}
