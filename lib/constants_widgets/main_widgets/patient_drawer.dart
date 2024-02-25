import 'package:pharmazool/app/patient/drawer_screens/motabra_screen.dart';
import 'package:pharmazool/app/patient/drawer_screens/shared_for_spoken.dart';
import 'package:pharmazool/app/patient/drawer_screens/who_are_screen.dart';
import 'package:pharmazool/constants_widgets/utils/log_out_methode.dart';
import 'package:pharmazool/src/core/custom/signout_widget.dart';
import 'package:pharmazool/src/core/network/local/cashhelper.dart';
import 'package:pharmazool/src/core/utils/app_strings.dart';
import 'package:pharmazool/src/core/utils/styles.dart';
import 'package:pharmazool/src/features/patient/share_spoken/persentation/shared_for_spoken.dart';

import '../../src/core/config/routes/app_imports.dart';

class PatientDrawer extends StatefulWidget {
  const PatientDrawer({super.key});

  @override
  State<PatientDrawer> createState() => _PatientDrawerState();
}

class _PatientDrawerState extends State<PatientDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Stack(
              children: [
                Positioned(
                  right: 4.0,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Image.asset(
                      patient,
                      height: context.height * 0.2,
                      width: context.height * 0.2,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8.0,
                  right: 15.0,
                  child: Text(
                    userName ?? '',
                    style: TextStyles.styleblack20,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            // trailing: const Icon(Icons.arrow_forward_ios, size: 20),
            leading: const Icon(Icons.person_pin),
            //  horizontalTitleGap: 40,
            title: const Row(
              children: [
                Spacer(),
                Text(
                  'من نحن ؟',
                  style: TextStyles.styleblack20,
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WhoAreScreenPatient(),
                ),
              );
            },
          ),
          const SizedBox(),
          ListTile(
            // trailing: const Icon(Icons.arrow_forward_ios, size: 20),
            leading: const Icon(Icons.favorite),
            title: const Row(
              children: [
                Spacer(),
                Text(
                  'التبرع بالأدوية',
                  style: TextStyles.styleblack20,
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MotabraScreen(),
                ),
              );
            },
          ),
          const SizedBox(),
          ListTile(
            // trailing: const Icon(Icons.arrow_forward_ios, size: 20),
            leading: const Icon(Icons.message),
            title: const Row(
              children: [
                Spacer(),
                Text(
                  'شاركنا باقتراحك',
                  style: TextStyles.styleblack20,
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SharedForSpokenPatient(),
                ),
              );
            },
          ),
          const SizedBox(),
          ListTile(
            // trailing: const Icon(
            //   Icons.arrow_forward_ios,
            //   size: 20,
            // ),
            leading: const Icon(Icons.logout),
            title: const Row(
              children: [
                Spacer(),
                Text(
                  'تسجيل خروج',
                  style: TextStyles.styleblack20,
                ),
              ],
            ),
            onTap: () {
              showCheckSignOut();
            },
          ),
        ],
      ),
    );
  }

  showCheckSignOut() {
    showDialog(
        context: context,
        builder: (context) {
          return SignOutWidget(
            onPress: () async {
              setState(() {
                userName = '';
                token = '';
                //    Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(builder: (context) {
                //     return const OnBoardingScreen();
                //   }),
                //   (Route<dynamic> route) => false,
                // );
                CashHelper.RemoveData(key: 'uId').then((value) {
                  print(token);
                  if (value) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const OnBoardingScreen();
                      }),
                      (Route<dynamic> route) => false,
                    );
                  }
                });
                // LogOut(context);
                print("uId Log Out:$uId");
              });
            },
          );
        });
  }
}
