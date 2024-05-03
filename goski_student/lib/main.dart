import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:goski_student/const/text_theme.dart';
import 'package:goski_student/const/util/custom_dio.dart';
import 'package:goski_student/const/util/screen_size_controller.dart';
import 'package:goski_student/data/data_source/auth_service.dart';
import 'package:goski_student/data/repository/auth_repository.dart';
import 'package:goski_student/test.dart';
import 'package:goski_student/ui/component/goski_main_header.dart';
import 'package:goski_student/ui/main/u003_student_main.dart';
import 'package:goski_student/ui/user/u001_login.dart';
import 'package:goski_student/ui/user/u002_signup.dart';
import 'package:goski_student/view_model/login_view_model.dart';
import 'package:goski_student/view_model/signup_view_model.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

void initDependencies() {
  Get.lazyPut(() => AuthService());
  Get.lazyPut(() => AuthRepository());
  Get.lazyPut(() => LoginViewModel());
  Get.lazyPut(() => SignupViewModel());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await dotenv.load(fileName: ".env");
  await EasyLocalization.ensureInitialized();
  initDependencies();
  final kakaoApiKey = dotenv.env['KAKAO_API_KEY'];
  KakaoSdk.init(nativeAppKey: kakaoApiKey);
  CustomDio.initialize(); // CustomDio 초기화
  runApp(EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ko', 'KR')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ko', 'KR'),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    return GetMaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        fontFamily: 'Jua',
        textTheme: AppTextTheme.lightTextTheme,
      ),
      home: FutureBuilder(
        future: secureStorage.read(key: "isLoggedIn"),
        builder: (context, snapshot) {
          final mediaQueryData = MediaQuery.of(context);
          final screenSizeController = Get.put(ScreenSizeController());
          screenSizeController.setScreenSize(
            mediaQueryData.size.width,
            mediaQueryData.size.height,
          );
          logger.d(
              "ScreenHeight: ${screenSizeController.height}, ScreenWidth: ${screenSizeController.width}");
          if (snapshot.data != null) {
            return StudentMainScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}