import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:pharmazool/src/core/config/routes/app_imports.dart';

part 'share_spoken_state.dart';

class ShareSpokenCubit extends Cubit<ShareSpokenState> {
  ShareSpokenCubit() : super(ShareSpokenInitial());

  static ShareSpokenCubit get(context) => BlocProvider.of(context);

  void sendByMalier(
      {required String name,
      required String phone,
      required String subject}) async {
    emit(SendEmailLoading());
    String currentEmail = "0ahmed0fayez0@gmail.com";
    String password = 'asar namq dgig rstc';

    final smtpServer = gmail(currentEmail, password);

    final message = Message()
      ..from = Address(currentEmail, 'Your name')
      ..recipients.add('Pharmazoolapp@gmail.com')
      ..subject = '''Hi Pharmazool  :: 😀 :: ${DateTime.now()} 
      I'am : $name , phone : $phone'''
      ..text = subject;
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      emit(SendEmailSuccess());

    } on MailerException catch (e) {
      print('Message not sent.');
      print(e);
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      emit(SendEmailFailure());

    }
  }

}
