import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:readeck/app/data/translations.dart';
import 'app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/data/localization_service.dart';
import 'app/data/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final box = GetStorage();
  final hasToken = box.read('token') != null;

  // 初始化本地化服务
  final localizationService = LocalizationService();
  final themeService = ThemeService();

  runApp(GetMaterialApp(
    title: "Readeck",
    getPages: AppPages.routes,
    builder: combineBuilder,
    debugShowCheckedModeBanner: false,
    initialRoute: hasToken ? Routes.HOME : Routes.LOGIN,
    theme: themeService.currentTheme,
    translations: AppTranslations(),
    locale: localizationService.getCurrentLocale(),
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    fallbackLocale: const Locale('zh', 'CN'),
    supportedLocales: const [
      Locale('zh', 'CN'),
      Locale('zh', 'TW'),
      Locale('en', 'US')
    ],
  ));

  Get.config(
    enableLog: true,
    defaultTransition: Transition.rightToLeft,
    defaultDurationTransition: const Duration(milliseconds: 150),
  );

  Future.delayed(const Duration(milliseconds: 10), () {
    configEasyLoading();
    configUiOverlayStyle();
  });
}

Widget combineBuilder(BuildContext context, Widget? child) {
  Widget easyLoadingWrappedChild =
      EasyLoading.init(builder: (innerContext, innerWidget) {
    return MediaQuery(
      data: MediaQuery.of(innerContext)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: innerWidget!,
      ),
    );
  })(context, child);
  return easyLoadingWrappedChild;
}

configUiOverlayStyle() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
}

configEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorWidget = LoadingAnimationWidget.fourRotatingDots(
        color: const Color.fromARGB(255, 67, 67, 67), size: 60)
    ..loadingStyle = EasyLoadingStyle.custom
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.transparent
    ..boxShadow = []
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskType = EasyLoadingMaskType.custom
    ..maskColor = Colors.white.withAlpha(200)
    ..userInteractions = false
    ..dismissOnTap = false;
}
