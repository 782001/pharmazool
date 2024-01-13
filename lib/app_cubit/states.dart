abstract class AppStates {}

class InitialState extends AppStates {}

class changeBottomNAvState extends AppStates {}

class changeExpanasionToucheState extends AppStates {}

class changeBarCodeResultState extends AppStates {}

//login states

class AppLoginLoadingState extends AppStates {}

class AppLoginSuccesState extends AppStates {}

class AppLoginErrorState extends AppStates {}

//register states

class AppRegisterLoadingState extends AppStates {}

class AppRegisterSuccesState extends AppStates {}

class AppRegisterErrorState extends AppStates {}

//doctor register states

class DoctorRegisterLoadingState extends AppStates {}

class DoctorRegisterSuccesState extends AppStates {}

class DoctorRegisterErrorState extends AppStates {}

//groublist states

class GetDoctorGroubListLoadingState extends AppStates {}

class GetDoctorGroubListSuccesState extends AppStates {}

class GetDoctorGroubListErrorState extends AppStates {}

//reset password states

class AppResetPasswordErrorState extends AppStates {}

class AppResetPasswordSuccesState extends AppStates {}

//get pharmacies

class GetPharmaciesLoadingState extends AppStates {}

class GetPharmaciesSuccesState extends AppStates {}

class GetPharmaciesErrorState extends AppStates {}

//scan image
class PickImageSuccessState extends AppStates {}

// getmedicines by id
class GetMedicinesByIdLoadingState extends AppStates {}

class GetMedicinesByIdSuccesState extends AppStates {}

class GetMedicinesByIdErrorState extends AppStates {}

// getmedicines by id
class SearchGenericMedicinePatientLoadingState extends AppStates {}

class SearchGenericMedicinePatientSuccesState extends AppStates {}

class SearchGenericMedicinePatientErrorState extends AppStates {}

//change location
class ChangeLocalityState extends AppStates {}

//getfiltered pharmacies

class GetFilteredPharmaciesLoadingState extends AppStates {}

class GetFilteredPharmaciesSuccesState extends AppStates {}

class GetFilteredPharmaciesErrorState extends AppStates {}

///pick scan image
class PickImageLoadingState extends AppStates {}

class PickImageSuccesState extends AppStates {}

class PickImageErrorState extends AppStates {}

//maps

class MapSuccesState extends AppStates {}

class MapErrorState extends AppStates {}

//get doctor pharmacy

class GetDoctorPharmacyLoadingState extends AppStates {}

class GetDoctorPharmacySuccesState extends AppStates {}

class GetDoctorPharmacyErrorState extends AppStates {}

//get doctor pharmacymedicinebyId

class GetDoctorPharmacyMedicineLoadingState extends AppStates {}

class GetDoctorPharmacyMedicineSuccesState extends AppStates {}

class GetDoctorPharmacyMedicineErrorState extends AppStates {}

// change productstatus
class ChangeMedicineSatteLoadingState extends AppStates {}

class ChangeMedicineSatteSuccesState extends AppStates {}

class ChangeMedicineSatteErrorState extends AppStates {}

// updatepharmacy
class UpdatePharmacyLoadingState extends AppStates {}

class UpdatePharmacySuccesState extends AppStates {}

class UpdatePharmacyErrorState extends AppStates {}

// updatepharmacy
class UpdatePharmacyMedicineLoadingState extends AppStates {}

class UpdatePharmacyMedicineSuccesState extends AppStates {}

class UpdatePharmacyMedicineErrorState extends AppStates {}

// pagination
class IncreamentOfMedicineListLoadingState extends AppStates {}

class IncreamentOfMedicineListSuccesState extends AppStates {}

class IncreamentOfMedicineListErrorState extends AppStates {}
class GetPressPositionLoading extends AppStates {}
class GetPressPositionSuccess extends AppStates {}
class GetPressPositionError extends AppStates {}

class GetAreaListSuccess extends AppStates {}
class GetAreaListLoading extends AppStates {}
class GetAreaListError extends AppStates {}

class GetLocalityError extends AppStates {}
class GetLocalityLoading extends AppStates {}
class GetLocalitySuccess extends AppStates {}
class GetStateSuccess extends AppStates {}
class GetStateLoading extends AppStates {}
class GetStateError extends AppStates {}


