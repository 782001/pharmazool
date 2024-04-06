import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/utils/strings.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

class PatientHomeBody extends StatefulWidget {
  const PatientHomeBody({super.key});

  @override
  State<PatientHomeBody> createState() => _PatientHomeBodyState();
}

class _PatientHomeBodyState extends State<PatientHomeBody> {
  TextEditingController searchController = TextEditingController();

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
            // const SearchBar1(id: 1),
            BlocConsumer<AppCubit, AppStates>(
                listener: (context, state) {},
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      TextField(
                        onSubmitted: (value) {
                          AppCubit.get(context).getsearchmedicine(value);
                        },
                        onChanged: (value) {
                          AppCubit.get(context).getsearchmedicine(value);
                        },
                        controller: searchController,
                        style: TextStyle(
                          fontFamily: cairoFont,
                          fontSize: context.height * 0.015,
                        ),
                        decoration: InputDecoration(
                          hintText: 'بحث',
                          hintStyle: TextStyle(
                            fontFamily: cairoFont,
                            color: const Color(0xFF949098),
                            fontSize: context.height * 0.018,
                          ),
                          filled: true,
                          fillColor: AppColors.kGreyColor,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            size: context.height * 0.03,
                            color: const Color(0xFF949098),
                          ),
                          suffixIcon: InkWell(
                            onTap: () async {
                              searchController.text =
                                  await AppCubit.get(context)
                                      .getGalleryImageForPatientSearch();
                              AppCubit.get(context)
                                  .getsearchmedicine(searchController.text);
                            },
                            child: Image.asset(
                              scan,
                              color: Colors.black,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      searchController.text == ""
                          ? Container(
                              color: Colors.white,
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
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
                            )
                          : ConditionalBuilder(
                              fallback: (context) => Container(
                                    color: Colors.white,
                                    child: loading(),
                                  ),
                              condition: state is! GetMedicinesByIdLoadingState,
                              builder: (context) {
                                return ConditionalBuilder(
                                  condition: AppCubit.get(context)
                                      .searchList
                                      .isNotEmpty,
                                  builder: (context) {
                                    return SizedBox(
                                        height: context.height * 0.53,
                                        child: ListView.separated(
                                          separatorBuilder: (context, _) {
                                            return const SizedBox(
                                              height: 10,
                                            );
                                          },
                                          itemBuilder: (context, index) {
                                            return medicineItem(
                                                AppCubit.get(context)
                                                    .searchList[index],
                                                context);
                                          },
                                          itemCount: AppCubit.get(context)
                                              .searchList
                                              .length,
                                        ));
                                  },
                                  fallback: (context) => Container(
                                    color: Colors.white,
                                    child: const Text(
                                      "لا يوجد عناصر مطابقه",
                                      style: TextStyles.styleblack15,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              })
                    ]),
                  );
                }),

            // Container(
            //   color: Colors.white,
            //   child: GridView.builder(
            //     shrinkWrap: true,
            //     physics: const NeverScrollableScrollPhysics(),
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 3,
            //       crossAxisSpacing: 2,
            //       mainAxisSpacing: 10,
            //       mainAxisExtent: 130,
            //     ),
            //     itemBuilder: (context, index) {
            //       return PatientHomeGridViewItem(
            //         homeIconsModel: homeList[index],
            //       );
            //     },
            //     itemCount: homeList.length,
            //   ),
            // ),

            SizedBox(height: context.height * 0.2),
          ],
        ),
      ),
    );
  }
}
