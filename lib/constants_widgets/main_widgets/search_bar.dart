import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pharmazool/app_cubit/cubit.dart';
import 'package:pharmazool/constants_widgets/main_widgets/constants.dart';
import 'package:pharmazool/src/core/utils/strings.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: [
          Expanded(
            child:  SizedBox(
              height: 40.0,
              child: TextField(
                style:TextStyles.style12,
                decoration: InputDecoration(
                  hintText: 'search',
                  hintStyle: TextStyles.stylekTextLightColor15,
                  filled: true,
                  fillColor: kWhite,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  contentPadding:const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  suffixIcon: SvgPicture.asset(
                    'assets/icons/search.svg',
                    color: kPrimaryColor,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
