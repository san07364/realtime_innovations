import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:realtime_innovations/constants/color_constants.dart';
import 'package:realtime_innovations/services/dependency_injector.dart';

import 'routes/route_config.dart';
import 'services/local_database_service.dart';

final appRouter = AppRouter();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await DependencyInjector.init();
  await GetIt.I<LocalDatabaseService>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: "Realtime Innovations",
      themeMode: ThemeMode.light,
      theme: ThemeData.light().copyWith(
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: ColorConstants.primary,
          ),
          floatingActionButtonTheme:
              const FloatingActionButtonThemeData(elevation: 0),
          scaffoldBackgroundColor: ColorConstants.divider),
      routerConfig: appRouter.config(),
    );
  }
}
