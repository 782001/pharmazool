import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

class PharmacyFilterList extends StatefulWidget {
  const PharmacyFilterList({super.key});

  @override
  State<PharmacyFilterList> createState() => _PharmacyFilterListState();
}

class _PharmacyFilterListState extends State<PharmacyFilterList> {
  @override
  Widget build(BuildContext context) {
    var list = AppCubit.get(context).PharmaciesByMedicineIdList;

    return ConditionalBuilder(
        condition: list.isEmpty,
        builder: (context) {
          return const Center(
              child: Text(
            "نتأسف الدواء المطلوب غير متوفر في صيدليات فارمازول في الوقت الحالي",
            style: TextStyles.styleblackDefault,
            textAlign: TextAlign.center,
          ));
        },
        fallback: (context) => ListView.separated(
              itemCount: list.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                var item = list[index];
                return PharmacyItem(model: item);
              },
            ));
    // return list.isEmpty
    //     ? const Center(
    //         child: Text(
    //         "نتأسف الدواء المطلوب غير متوفر في صيدليات فارمازول في الوقت الحالي",
    //         style: TextStyles.styleblackDefault,
    //         textAlign: TextAlign.center,
    //       ))
    //     : ListView.separated(
    //         itemCount: list.length,
    //         separatorBuilder: (context, index) => const SizedBox(height: 10),
    //         itemBuilder: (context, index) {
    //           var item = list[index];
    //           return PharmacyItem(model: item);
    //         },
    //       );
  }
}
