 import 'package:pharmazool/src/core/config/routes/app_imports.dart';
 
class PharmasyScreen extends StatelessWidget {
  const PharmasyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);

    return BlocBuilder<AppCubit, AppStates>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.kGreyColor,
          appBar: AppBar(
            backgroundColor: Colors.green.withOpacity(0.7),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Stack(
            children: [
              Container(
                height: context.height * 0.1,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.7),
                  borderRadius: const BorderRadiusDirectional.only(
                    bottomStart: Radius.circular(50),
                    bottomEnd: Radius.circular(50),
                  ),
                ),
              ),
              const PharmacyFilterList(),
            ],
          ),
          floatingActionButton: const FloatingBotton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomNavWidget(cubit: cubit),
        );
      },
    );
  }
}
