  
import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

class PharmacyFilterList extends StatelessWidget {
  const PharmacyFilterList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePharmacyCubit, ProfilePharmacyState>(
      builder: (context, state) {
        var cubit = ProfilePharmacyCubit.get(context);
        var list = cubit.filteredList;
        return list == null
            ? const Center(child: CircularProgressIndicator())
            : list.isEmpty
                ? const Center(child: Text("نتأسف الدواء المطلوب غير متوفر في صيدليات فارمازول في الوقت الحالي",style: TextStyles.styleblackDefault ,))
                : ListView.separated(
                  itemCount: list.length
                  ,separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      var item = list[index];
                      return PharmacyItem(model: item);
                    },
                  );
      },
    );
  }
}
