import 'package:flutter/services.dart';
import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/network/local/cashhelper.dart';
import 'package:pharmazool/src/core/utils/app_strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CashHelper.init();
  uId = (await CashHelper.GetData(key: 'uId'));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(   
      providers: [
        BlocProvider(
            create: (BuildContext context) => AppCubit()),
        BlocProvider(create: (BuildContext context) => ProfilePharmacyCubit()),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            theme: ThemeData(
                appBarTheme: const AppBarTheme(
                    systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarBrightness: Brightness.light,
                  statusBarIconBrightness: Brightness.dark,
                )),
                primarySwatch: Colors.teal),
            debugShowCheckedModeBanner: false,
            home:
                // HomeScreen()
                const SplashScreen(),
          );
        },
      ),
    );
  }
}
