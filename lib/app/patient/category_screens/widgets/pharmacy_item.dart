import 'package:pharmazool/src/core/config/routes/app_imports.dart';

class PharmacyItem extends StatelessWidget {
  const PharmacyItem({super.key, required this.model});

  final PharmacyModel model;

  @override
  Widget build(BuildContext context) {
    String? phoneNumber = model.phone;
    return InkWell(
      onTap: () {
        name = model.name;
        address = model.address;
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ShowWidget(child: MapScreen(model))));
        pharmacyhistory.add(
          PharmacyModel(
              name: model.name,
              block: DateTime.now().hour.toString(),
              street: DateTime.now().minute.toString()),
        );
      },
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
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  AutoSizeText(
                    model.locality ?? '',
                    maxLines: 3,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis),
                  ),
                  AutoSizeText(
                    model.area ?? '',
                    maxLines: 3,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis),
                  ),
                  AutoSizeText(
                    model.address ?? '',
                    maxLines: 3,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
