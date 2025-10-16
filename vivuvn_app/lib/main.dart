import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'my_app.dart';

void main() async {
  await initializeDateFormatting('vi_VN', null);
  runApp(const ProviderScope(child: MyApp()));
}
