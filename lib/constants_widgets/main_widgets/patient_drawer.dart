import 'package:pharmazool/app/patient/drawer_screens/motabra_screen.dart';
import 'package:pharmazool/app/patient/drawer_screens/shared_for_spoken.dart';
import 'package:pharmazool/app/patient/drawer_screens/who_are_screen.dart';
import 'package:pharmazool/src/core/custom/signout_widget.dart';

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
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Image.asset(
                    patient,
                    height: context.height * 0.2,
                    width: context.height * 0.2,
                  ),
                ),
                Positioned(
                  bottom: 8.0,
                  left: 4.0,
                  child: Text(
                    userName ?? '',
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            trailing: const Icon(Icons.arrow_forward_ios, size: 20),
            leading: const Icon(Icons.person_pin),
            title: const Text(
              'من نحن ؟',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontStyle: FontStyle.normal,
                fontFamily: 'Schyler',
              ),
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
            trailing: const Icon(Icons.arrow_forward_ios, size: 20),
            leading: const Icon(Icons.favorite),
            title: const Text(
              'التبرع بالأدوية',
              style: TextStyle(
                color: Colors.black,
                // fontSize: context.height * 0.017,
                fontSize: 20,
                fontStyle: FontStyle.normal,
                fontFamily: 'Schyler',
              ),
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
            trailing: const Icon(Icons.arrow_forward_ios, size: 20),
            leading: const Icon(Icons.message),
            title: const Text(
              'شاركنا باقتراحك',
              style: TextStyle(
                  color: Colors.black,
                  // fontSize: context.height * 0.017,
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Schyler'),
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
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
            leading: const Icon(Icons.logout),
            title: const Text(
              'تسجيل خروج',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontStyle: FontStyle.normal,
                fontFamily: 'Schyler',
              ),
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

              userName = '';
              token = '';
            },
          );
        });
  }
}
