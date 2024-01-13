import 'package:pharmazool/src/core/config/routes/app_imports.dart';

class SignOutWidget extends StatelessWidget {
  const SignOutWidget({Key? key, required this.onPress}) : super(key: key);
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      content: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.1,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("هل تود المغادرة ؟"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const AutoSizeText(
                          'رجوع',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: onPress,
                        child: const AutoSizeText(
                          'غادر ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )),
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
