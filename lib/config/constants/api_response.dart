// import 'package:alfred/alfred.dart';

// class ResponseStatus {
//   static Future<void> responseHandler(int statusCode,
//       ApiResponseStatus apiResponseStatus, HttpResponse response) async {
//     response.statusCode = statusCode;
//     await response.json(ApiResponse(apiResponseStatus));
//   }
// }

// enum ApiResponseStatus {
//   userNotFound,
//   userLogout,
//   passwordIncorrect,
//   userAdded,
//   userDeleted,
//   unauthorizedOperation,
//   success,
//   failure,
//   tokenInvalid,
//   emailOrPasswordInvalid,
//   allFieldMustBeFilled,
//   invalidRequest,
//   userAlreadyExist,
//   transactionNotFound,
//   transactionDeleted,
//   walletNotFound,
//   walletAlreadyExist,
//   walletDeleted,
//   walletUpdated,
//   withdrawalNotFound,
//   withdrawalAlreadyExist,
//   withdrawalDeleted,
//   withdrawalUpdated,
//   withdrawalQuantityHigh,
//   withdrawalMinimum,
//   sendNewPassword,
// }


//   final ApiResponseStatus status;

//   ApiResponse(this.status);

//   Map<String, dynamic> toJson() {
//     String message;

//     switch (status) {
//       case ApiResponseStatus.userNotFound:
//         message = "User bulunamadı";
//         break;
//       case ApiResponseStatus.passwordIncorrect:
//         message = "Şifre yanlış";
//         break;
//       case ApiResponseStatus.userAdded:
//         message = "Kullanıcı eklendi";
//         break;
//       case ApiResponseStatus.userDeleted:
//         message = "Kullanıcı silindi";
//         break;
//       case ApiResponseStatus.unauthorizedOperation:
//         message = "Yetkisiz işlem";
//         break;
//       case ApiResponseStatus.success:
//         message = "İşlem başarılı";
//         break;
//       case ApiResponseStatus.failure:
//         message = "İşlem başarısız";
//         break;

//       case ApiResponseStatus.tokenInvalid:
//         message = 'Token geçersiz';
//       case ApiResponseStatus.emailOrPasswordInvalid:
//         message = 'Email veya şifre yanlış formatta';
//       case ApiResponseStatus.allFieldMustBeFilled:
//         message = "Tüm alanları doldurun";
//       case ApiResponseStatus.invalidRequest:
//         message = 'Geçersiz istek';
//       case ApiResponseStatus.userAlreadyExist:
//         message = 'Kullanıcı zaten kayıtlı';
//       case ApiResponseStatus.transactionNotFound:
//         message = 'İşlem bulunamadı';
//       case ApiResponseStatus.walletNotFound:
//         message = 'Cüzdan bulunamadı';
//       case ApiResponseStatus.walletAlreadyExist:
//         message = 'Cüzdan zaten kayıtlı';
//       case ApiResponseStatus.walletDeleted:
//         message = "Cüzdan silindi";
//       case ApiResponseStatus.walletUpdated:
//         message = 'Cüzdan adresi güncellendi';
//       case ApiResponseStatus.withdrawalNotFound:
//         message = 'Çekim talebi bulunamadı';
//       case ApiResponseStatus.withdrawalAlreadyExist:
//         message = 'Çekim talebi zaten mevcut';
//       case ApiResponseStatus.withdrawalDeleted:
//         message = 'Çekim talebi silindi';
//       case ApiResponseStatus.withdrawalUpdated:
//         message = 'Çekim talebi güncellendi';
//       case ApiResponseStatus.withdrawalQuantityHigh:
//         message = 'Çekmek istediğiniz tutar bakiyenizden fazla olamaz';
//       case ApiResponseStatus.withdrawalMinimum:
//         message = 'Çekim tutarı en az 25 olmalı';
//       case ApiResponseStatus.userLogout:
//         message = 'Kullanıcı başarılı ile çıkış yaptı';
//       case ApiResponseStatus.transactionDeleted:
//         message = 'İşlem silindi';
//       case ApiResponseStatus.sendNewPassword:
//         message = 'Yeni şifreniz mailinize gönderilmiştir';
//     }

//     return {'message': message};
//   }


// extension ApiResponseStatusExtension on ApiResponseStatus {
//   int get statusCode {
//     switch (this) {
//       case ApiResponseStatus.userNotFound:
//         return 404; // Not Found
//       case ApiResponseStatus.passwordIncorrect:
//         return 401; // Unauthorized
//       case ApiResponseStatus.userAdded:
//         return 201; // Created
//       case ApiResponseStatus.userDeleted:
//         return 200; // OK
//       case ApiResponseStatus.unauthorizedOperation:
//         return 401; // Forbidden
//       case ApiResponseStatus.success:
//         return 200; // OK
//       case ApiResponseStatus.failure:
//         return 500; // Internal Server Error
//       case ApiResponseStatus.tokenInvalid:
//         return 401; // Unauthorized
//       case ApiResponseStatus.emailOrPasswordInvalid:
//         return 400; // Bad Request
//       case ApiResponseStatus.allFieldMustBeFilled:
//         return 422; // Unprocessable Entity
//       case ApiResponseStatus.invalidRequest:
//         return 400; // Bad Request
//       case ApiResponseStatus.userAlreadyExist:
//         return 409; // Conflict
//       case ApiResponseStatus.transactionNotFound:
//         return 404; // Not Found
//       case ApiResponseStatus.walletNotFound:
//         return 404;
//       case ApiResponseStatus.walletAlreadyExist:
//         return 409;
//       case ApiResponseStatus.walletDeleted:
//         return 200;
//       case ApiResponseStatus.walletUpdated:
//         return 200;
//       case ApiResponseStatus.withdrawalNotFound:
//         return 404;
//       case ApiResponseStatus.withdrawalAlreadyExist:
//         return 409;
//       case ApiResponseStatus.withdrawalDeleted:
//         return 200;
//       case ApiResponseStatus.withdrawalUpdated:
//         return 200;
//       case ApiResponseStatus.withdrawalQuantityHigh:
//         return 400;
//       case ApiResponseStatus.withdrawalMinimum:
//         return 400;
//       case ApiResponseStatus.userLogout:
//         return 200;
//       case ApiResponseStatus.transactionDeleted:
//         return 200;
//       case ApiResponseStatus.sendNewPassword:
//         return 200;
//     }
//   }
// }
