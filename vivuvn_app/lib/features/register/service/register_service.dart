import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api/register_api.dart';
import '../data/dto/register_request.dart';
import '../data/dto/verify_email_request.dart';

final registerServiceProvider = Provider.autoDispose<IRegisterService>((
  final ref,
) {
  final api = ref.watch(registerApiProvider);
  return RegisterService(api);
});

abstract interface class IRegisterService {
  Future<void> register(final RegisterRequest request);
  Future<void> verifyEmail(final VerifyEmailRequest request);
}

final class RegisterService implements IRegisterService {
  final RegisterApi _api;
  RegisterService(this._api);

  @override
  Future<void> register(final RegisterRequest request) async {
    await _api.register(request);
  }

  @override
  Future<void> verifyEmail(final VerifyEmailRequest request) async {
    await _api.verifyEmail(request);
  }
}
