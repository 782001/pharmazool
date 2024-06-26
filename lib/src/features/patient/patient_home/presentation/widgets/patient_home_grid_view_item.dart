import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

class PatientHomeGridViewItem extends StatelessWidget {
  const PatientHomeGridViewItem({super.key, required this.homeIconsModel});
  final HomeIconsModel homeIconsModel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        mycategorymodel = homeIconsModel;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MedicineScreen(
                    int.parse(homeIconsModel.genericid.toString()))));
        AppCubit.get(context).getMedicinesPatientByID(id: homeIconsModel.genericid!);
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
                  homeIconsModel.icon.toString(),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: context.height * 0.0035,
              ),
              AutoSizeText(
                homeIconsModel.title.toString(),
                style: TextStyles.styleblackBold16,
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
}
