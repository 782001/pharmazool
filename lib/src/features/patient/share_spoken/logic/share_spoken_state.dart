part of 'share_spoken_cubit.dart';

abstract class ShareSpokenState {}

class ShareSpokenInitial extends ShareSpokenState {}

class SendEmailSuccess extends ShareSpokenState {}

class SendEmailLoading extends ShareSpokenState {}

class SendEmailFailure extends ShareSpokenState {}
