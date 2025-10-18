import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/register_api.dart';
import '../data/dto/register_request.dart';
import '../data/dto/register_response.dart';

final registerServiceProvider = Provider.autoDispose<IRegisterService>((
  final ref,
) {
  final api = ref.watch(registerApiProvider);
  return RegisterService(api);
});

abstract class IRegisterService {
  Future<RegisterResponse> register(final RegisterRequest request);
}

final class RegisterService implements IRegisterService {
  final RegisterApi _api;
  RegisterService(this._api);

  @override
  Future<RegisterResponse> register(final RegisterRequest request) async {
    return await _api.register(request);
  }
}
