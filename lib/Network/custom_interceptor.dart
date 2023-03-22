import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomInterceptor extends Interceptor{
  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 401) {
      SharedPreferences cache = await SharedPreferences.getInstance();
      await cache.remove("user_id");
      await cache.remove("token");
    }
    super.onResponse(response, handler);
  }
}