import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/custom/signout_widget.dart';

class PatientLayout extends StatefulWidget {
  const PatientLayout({super.key});

  @override
  State<PatientLayout> createState() => _PatientLayoutState();
}

class _PatientLayoutState extends State<PatientLayout> {
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => ShowCaseWidget.of(context).startShowCase([floatingKey]));
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  GlobalKey floatingKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return WillPopScope(
          onWillPop: () async {
            showCheckSignOut();
            return false;
          },
          child: Scaffold(
            body: SizedBox.expand(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  cubit.changeBottomNAv(index, _pageController);
                },
                children: const [
                  PatientHome(),
                  HistoryScreen(),
                ],
              ),
            ),
            floatingActionButton: Showcase(
                key: floatingKey,
                description:
                    "من هنا يمكنك البحث عن علاجك بنسخ اسم الدواء ( روشتة / ملف / علبة دواء)",
                child: const FloatingBottonPatient()),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            extendBody: true,
            bottomNavigationBar: bottomMainNavWidget(cubit, _pageController),
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
