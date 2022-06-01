import 'package:dio/dio.dart';
import 'package:nobibot/models/order.dart';
import '../models/account.dart';
import '../models/response.dart';

import 'main.dart';

class Services {
  static dynamic errorHandler(Object obj, err, ty) {
    //
    // print(obj);
    if (obj.runtimeType == DioError) {
      obj = (obj as DioError);
      switch (obj.type) {
        case DioErrorType.response:
          if (err is ErrorAction && err.response is void Function(dynamic)) {
            err.response!(obj.response!);
          }
          break;
        case DioErrorType.connectTimeout:
        case DioErrorType.receiveTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.other:
          if (err is ErrorAction && err.connection is void Function()) {
            err.connection!();
          }
          break;
        case DioErrorType.cancel:
          if (err is ErrorAction && err.cancel is void Function()) {
            err.cancel!();
          }
          break;
        default:
          break;
      }
    } else {
      err.connection!();
    }
    return ty;
  }

  static Future<Dio> dioWithToken(String token) async {
    return Dio(BaseOptions(headers: {"token": token}));
  }

  ///************************************************/
  //
  //

  static Future<ApiResponse> addAccount(
          AddAccountReq m, ErrorAction? e) async =>
      await API(Dio())
          .addAccount(m)
          .catchError((o) => errorHandler(o, e, ApiResponse(ok: false)));

  static Future<ApiResponse> removeAccount(String t, ErrorAction? e) async =>
      await API(await dioWithToken(t))
          .removeAccount()
          .catchError((o) => errorHandler(o, e, ApiResponse(ok: false)));

  static Future<ApiResponse> getAccount(String t, ErrorAction? e) async =>
      await API(await dioWithToken(t))
          .getAccount()
          .catchError((o) => errorHandler(o, e, ApiResponse(ok: false)));

  static Future<ApiResponse> newOrder(
          String t, Order m, ErrorAction? e) async =>
      await API(await dioWithToken(t))
          .newOrder(m)
          .catchError((o) => errorHandler(o, e, ApiResponse(ok: false)));



  static Future<ApiResponse> getProperties(String t, ErrorAction? e) async =>
      await API(await dioWithToken(t))
          .getProperties()
          .catchError((o) => errorHandler(o, e, ApiResponse(ok: false)));


          
  static Future<ApiResponse> getOrders(String t, ErrorAction? e) async =>
      await API(await dioWithToken(t))
          .getOrders()
          .catchError((o) => errorHandler(o, e, ApiResponse(ok: false)));
  //
  //
  ///************************************************/
}

class ErrorAction {
  void Function(dynamic res)? response;
  void Function()? connection;
  void Function()? cancel;

  ErrorAction({this.response, this.connection, this.cancel});
}
