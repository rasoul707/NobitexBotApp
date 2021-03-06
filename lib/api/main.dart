import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../models/account.dart';
import '../models/group.order.req.dart';
import '../models/order.dart';
import '../models/response.dart';

part 'main.g.dart';

@RestApi(baseUrl: "http://62.3.41.73:3000/api/")
abstract class API {
  factory API(Dio dio, {String baseUrl}) = _API;

  @POST("addAccount")
  Future<ApiResponse> addAccount(@Body() AddAccountReq accountReq);

  @POST("removeAccount")
  Future<ApiResponse> removeAccount();

  @GET("getAccount")
  Future<ApiResponse> getAccount();

  @POST("newOrder")
  Future<ApiResponse> newOrder(@Body() GroupOrderRequest gOrderReq);

  @GET("getOrders")
  Future<ApiResponse> getOrders();

  @GET("getProperties")
  Future<ApiResponse> getProperties();

  @GET("getPairsList")
  Future<ApiResponse> getPairsList();
}
