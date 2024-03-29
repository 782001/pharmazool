import 'package:pharmazool/mymodels/GetPharmaciesByMedicineModel.dart';
import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

class PharmacyItem extends StatelessWidget {
  const PharmacyItem({super.key, required this.model});

  final GetPharmaciesByMedicineModel model;

  @override
  Widget build(BuildContext context) {
    String? phoneNumber = model.phone;
    return InkWell(
      onTap: () {
        name = model.name;
        address = model.address;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ShowWidget(child: MapScreen(model))));
        pharmacyhistory.add(
          GetPharmaciesByMedicineModel(
              name: model.name,
              block: DateTime.now().hour.toString(),
              street: DateTime.now().minute.toString()),
        );
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.only(top: 20),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27),
            color: const Color(0xffB8F2EE),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    child: IconButton(
                  icon: const Icon(
                    Icons.phone_rounded,
                    size: 30,
                  ),
                  onPressed: () async {
                    if (await canLaunch('tel:$phoneNumber')) {
                      await launch('tel:$phoneNumber');
                    }
                  },
                )),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AutoSizeText(
                      model.name ?? '',
                      style: TextStyles.styleblackbold20,
                    ),
                    AutoSizeText(
                      model.locality ?? '',
                      maxLines: 3,
                      style: TextStyles.styleellipsisbold15,
                    ),
                    AutoSizeText(
                      model.area ?? '',
                      maxLines: 3,
                      style: TextStyles.styleellipsisbold15,
                    ),
                    AutoSizeText(
                      model.address ?? '',
                      maxLines: 3,
                      style: TextStyles.styleellipsisbold15,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
