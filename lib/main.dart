import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ralamuli_translator/core/Routes/app_routes.dart';
import 'package:ralamuli_translator/core/Utils/screen_utils.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return ScreenUtilInit(
      designSize: const Size(ScreenUtils.designWidth, ScreenUtils.designHeight),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Ralamuli Translator',
          debugShowCheckedModeBanner: false,
          routerConfig: router,
        );
      },
    );
  }
}
