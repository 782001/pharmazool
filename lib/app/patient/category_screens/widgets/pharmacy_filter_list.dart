  
import 'package:pharmazool/src/core/config/routes/app_imports.dart';

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
                ? const Center(child: Text("No Pharmacy"))
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
