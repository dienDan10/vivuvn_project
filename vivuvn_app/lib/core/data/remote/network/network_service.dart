import 'package:dio/dio.dart';
import 'package:dio_http_formatter/dio_http_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'network_service_interceptor.dart';

final networkServiceProvider = Provider<Dio>((final ref) {
  const String baseUrl = 'http://10.0.2.2:5277';

  final options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
  );

  final dio = Dio(options);

  final networkServiceInterceptor = ref.read(
    networkServiceInterceptorProvider(dio),
  );

  dio.interceptors.addAll([HttpFormatter(), networkServiceInterceptor]);

  return dio;
});
