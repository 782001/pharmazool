// ignore: must_be_immutable
import 'package:pharmazool/files_doctor/nav_screens/search_screen.dart';
import 'package:pharmazool/src/core/config/routes/app_imports.dart';
import 'package:pharmazool/src/core/utils/strings.dart';

class SearchBar1 extends StatefulWidget {
  final int id;
  const SearchBar1({required this.id, super.key});

  @override
  State<SearchBar1> createState() => _SearchBar1State();
}

class _SearchBar1State extends State<SearchBar1> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SizedBox(
        height: context.height * 0.1,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: context.height * 0.09,
                    child: TextField(
                      controller: searchController,
                      readOnly: false,
                      onTap: () {
                        // widget.id == 1
                        //     ? Navigator.of(context).push(
                        //         MaterialPageRoute(
                        //           builder: (context) => SearchScreenPatient(
                        //             search: searchController.text,
                        //           ),
                        //         ),
                        //       )
                        //     : Navigator.of(context).push(
                        //         MaterialPageRoute(
                        //           builder: (context) => SearchScreenDoctor(
                        //             search: searchController.text,
                        //           ),
                        //         ),
                        //       );
                      },
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
                            searchController.text = await AppCubit.get(context)
                                .getGalleryImageForPatientSearch();
                          },
                          child: Image.asset(
                            scan,
                            color: Colors.black,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
