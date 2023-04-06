import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomInterceptor extends Interceptor{
  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {

    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401){
      SharedPreferences cache = await SharedPreferences.getInstance();
      await cache.remove("user_id");
      await cache.remove("token");
      //TODO previous screens need to be refreshed
    }
    super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);
  }
}