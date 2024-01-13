part of 'profilepharmacy_cubit.dart';

abstract class ProfilePharmacyState {}
 class ProfilePharmacyInitial  extends ProfilePharmacyState{}
class GetPressPositionProfileLoading extends ProfilePharmacyState {}
class GetPressPositionProfileSuccess extends ProfilePharmacyState {}
class GetPressPositionProfileError extends ProfilePharmacyState {}
 

class UpdatePharmacySuccessProfileState extends ProfilePharmacyState {}

class UpdatePharmacyErrorProfileState extends ProfilePharmacyState {}
class FilterPharmacyByLocalityAndStateAndAreaSuccess extends ProfilePharmacyState {}
class FilterPharmacyByLocalityAndStateAndAreaLoading extends ProfilePharmacyState {}
class FilterPharmacyByLocalityAndStateAndAreaError extends ProfilePharmacyState {}

class FilterLocalityByStateIdSuccess extends ProfilePharmacyState {}
class FilterLocalityByStateIdLoading extends ProfilePharmacyState {}
class FilterLocalityByStateIdError extends ProfilePharmacyState {}
class FilterAreaByLocalityIdError extends ProfilePharmacyState {}
class FilterAreaByLocalityIdLoading extends ProfilePharmacyState {}
class FilterAreaByLocalityIdSuccess extends ProfilePharmacyState {}
