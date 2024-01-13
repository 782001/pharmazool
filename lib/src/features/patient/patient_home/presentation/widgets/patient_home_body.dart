import 'package:pharmazool/src/core/config/routes/app_imports.dart';

class PatientHomeBody extends StatefulWidget {
  const PatientHomeBody({super.key});

  @override
  State<PatientHomeBody> createState() => _PatientHomeBodyState();
}

class _PatientHomeBodyState extends State<PatientHomeBody> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: context.height * 0.2,
              width: context.width * 0.9,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                image: DecorationImage(
                    image: AssetImage('assets/images/logo_11zon_low.png'),
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: context.height * 0.01),
            SearchBar1(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchScreenPatient(),
                ),
              );
            }),
            Container(
              color: Colors.white,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 130,
                ),
                itemBuilder: (context, index) {
                  return PatientHomeGridViewItem(
                    homeIconsModel: homeList[index],
                  );
                },
                itemCount: homeList.length,
              ),
            ),
            SizedBox(height: context.height * 0.2),
          ],
        ),
      ),
    );
  }
}
