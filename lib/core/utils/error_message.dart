import '../network/app_exception.dart';
import '../constants/app_strings.dart';

String userFacingError(Object error) {
  if (error is AppException) return error.message;
  return AppStrings.genericError;
}
