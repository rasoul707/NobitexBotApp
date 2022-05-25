import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/account.dart';
import '../models/response.dart';

part 'main.g.dart';

@RestApi(baseUrl: "http://192.168.6.244:3000/api/")
abstract class API {
  factory API(Dio dio, {String baseUrl}) = _API;

  @POST("addAccount")
  Future<ApiResponse> addAccount(@Body() AddAccountReq accountReq);

  @POST("removeAccount")
  Future<ApiResponse> removeAccount();

  @GET("getAccount")
  Future<ApiResponse> getAccount();
}
