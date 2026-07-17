import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/network/env.dart';

void main() {
  // Fail fast if --dart-define=API_KEY=... wasn't supplied — every request
  // needs X-API-Key (blueprint Section 4), so there's no safe partial-boot
  // state to fall back to.
  Env.assertConfigured();

  runApp(const ProviderScope(child: AjopayApp()));
}
