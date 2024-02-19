import 'package:pharmazool/files_doctor/drawer_screens/edite_profile.dart';
import 'package:pharmazool/files_doctor/drawer_screens/who_are_screen.dart';
import 'package:pharmazool/src/core/custom/signout_widget.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

import '../../src/core/config/routes/app_imports.dart';
import '../../src/features/doctor/share_spoken/persentation/shared_for_spoken.dart';

class DoctorDrawer extends StatefulWidget {
  const DoctorDrawer({super.key});

  @override
  State<DoctorDrawer> createState() => _DoctorDrawerState();
}

class _DoctorDrawerState extends State<DoctorDrawer> {
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
                      doctor,
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
                )
              ],
            ),
          ),
          ListTile(
            // trailing: const Icon(Icons.arrow_forward_ios, size: 20),
            leading: const Icon(Icons.person_pin),
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
                  builder: (context) => const WhoAreScreen(),
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
                  builder: (context) => SharedForSpoken(),
                ),
              );
            },
          ),
          const SizedBox(),
          ListTile(
            // trailing: const Icon(Icons.arrow_forward_ios, size: 20),
            leading: const Icon(Icons.location_on),
            title: const Row(
              children: [
                Spacer(),
                Text(
                  'تعديل الملف الشخصي',
                  style: TextStyles.styleblack20,
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowWidget(child: EditeProfile()),
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
            horizontalTitleGap: 10,
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
