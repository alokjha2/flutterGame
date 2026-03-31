import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../application/root_bloc_scope.dart';
import '../../core/theme/app_theme.dart';
import 'routing/app_router.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class ElderQuestApp extends StatelessWidget {
  const ElderQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = AppRouter.router;
    final updater = ShorebirdUpdater();



    return RootBlocScope(
      child: MaterialApp.router(
        title: 'ElderQuest',
        theme: AppTheme.light(),
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
