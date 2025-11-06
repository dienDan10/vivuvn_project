import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/auth/controller/auth_controller.dart';
import '../../common/auth/state/auth_state.dart';

class GoRouterNotifier extends ChangeNotifier {
  GoRouterNotifier(this.ref) {
    // listen to auth state changes
    ref.listen<AuthStatus>(
      authControllerProvider.select((final state) => state.status),
      (_, final next) => notifyListeners(),
    );
  }
  final Ref ref;
}
