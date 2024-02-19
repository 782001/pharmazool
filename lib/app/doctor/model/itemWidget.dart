import 'package:flutter/material.dart';

import 'package:pharmazool/constants_widgets/main_widgets/catalog-model.dart';
import 'package:pharmazool/src/core/utils/styles.dart';

class ItemWidget extends StatelessWidget {
  final Item item;
  const ItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Image.network(
              item.image,
              height: 90,
              width: 90,
            ),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(item.name,
                      style: TextStyles.styleblackBold18)),
            ),
            subtitle: Center(
                child: Text(item.desc,
                    style: TextStyles.styleblue15)),
            trailing: Text(
              "${item.price} SDG",
              style: TextStyles.styleblackbold20,
            ),
          ),
        ),
      ),
    );
  }
}
