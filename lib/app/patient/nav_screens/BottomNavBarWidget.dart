import 'package:flutter/material.dart';
import 'package:pharmazool/app_cubit/cubit.dart';
import 'package:pharmazool/src/features/patient/patient_home/presentation/widgets/show_widget.dart';
import '../../../src/features/patient/patient_layout/presentation/screens/patient_layout.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class BottomNavWidget extends StatelessWidget {
  const BottomNavWidget({
    super.key,
    required this.cubit
  });
  final cubit;

  @override
  Widget build(BuildContext context) {
    goToIndexPage(int index) {
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ShowWidget(child: const PatientLayout())),
        );
      } else if (index == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ShowWidget(child: const PatientLayout())),
        );
      } else if (index == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ShowWidget(child: const PatientLayout())),
        );
      } else if (index == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ShowWidget(child: const PatientLayout())),
        );
      }
    }

    return AnimatedBottomNavigationBar(
      backgroundColor: Colors.white,
      activeIndex: cubit.currentIndex,
      notchSmoothness: NotchSmoothness.verySmoothEdge,
      gapLocation: GapLocation.center,
      activeColor: const Color(0xff3CD2CB),
      inactiveColor: Colors.black,
      // waterDropColor: const Color(0xff3CD2CB),
      // dotIndicatorColor: const Color(0xff3CD2CB),
      onTap: (index) {
        goToIndexPage(index);
      },

      icons: iconList,
    );
  }
}

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  // final autoSizeGroup = AutoSizeGroup();
  // var _bottomNavIndex = 0; //default index of a first screen

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;

  final iconList = <IconData>[
    Icons.apps,
    Icons.history_toggle_off_outlined,
    Icons.qr_code_rounded,
    Icons.receipt,
  ];

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

final iconList = <IconData>[
  Icons.apps,
  Icons.history_toggle_off_outlined,
  // Icons.qr_code_rounded,
];
Widget bottomMainNavWidget(AppCubit cubit, PageController? pageController) {
  return AnimatedBottomNavigationBar(
    backgroundColor: Colors.white,
    activeIndex: cubit.currentIndex,
    notchSmoothness: NotchSmoothness.verySmoothEdge,
    gapLocation: GapLocation.center,
    activeColor: const Color(0xff3CD2CB),
    inactiveColor: Colors.black,
    // waterDropColor: const Color(0xff3CD2CB),
    // dotIndicatorColor: const Color(0xff3CD2CB),
    onTap: (index) {
      cubit.changeBottomNAv(index, pageController);
    },

    icons: iconList,
  );
}
