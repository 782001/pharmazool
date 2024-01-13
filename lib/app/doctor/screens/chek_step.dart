import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pharmazool/app_cubit/cubit.dart';

class CheckStep extends StatefulWidget {
  const CheckStep({super.key});

  @override
  State<CheckStep> createState() => _CheckStepState();
}

class _CheckStepState extends State<CheckStep> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController licenceidcontroller = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: 600,
        height: 600,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: namecontroller,
                  keyboardType: TextInputType.emailAddress,
                  validator: (namecontoller) {
                    if (namecontoller!.isEmpty) {
                      return 'برجاء ادخال اسم الصيدلية';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'اسم الصيدلية',
                    labelText: 'أسم الصيدلية',
                  ),
                ),
                SizedBox(
                  child: TextFormField(
                    controller: licenceidcontroller,
                    keyboardType: TextInputType.number,
                    validator: (licenceController) {
                      if (licenceController!.isEmpty) {
                        return 'برجاء ادخال رقم الرخصة';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'رقم الرخصة',
                      labelText: 'رقم الرخصة',
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        print(licenceidcontroller.text);
                        if (await AppCubit.get(context).checkpharmacy(
                            licenceidcontroller.text, namecontroller.text)) {
                          AppCubit.get(context).getDoctorPharmacy(
                              licenceId: licenceidcontroller.text);
                        }
                      }
                    },
                    child: const AutoSizeText(
                      'تأكيد ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
