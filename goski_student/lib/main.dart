import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:goski_student/const/text_theme.dart';
import 'package:goski_student/const/util/custom_dio.dart';
import 'package:goski_student/const/util/screen_size_controller.dart';
import 'package:goski_student/data/data_source/auth_service.dart';
import 'package:goski_student/data/data_source/main_service.dart';
import 'package:goski_student/data/data_source/notification_service.dart';
import 'package:goski_student/data/data_source/settlement_service.dart';
import 'package:goski_student/data/data_source/ski_resort_service.dart';
import 'package:goski_student/data/data_source/user_service.dart';
import 'package:goski_student/data/repository/auth_repository.dart';
import 'package:goski_student/data/repository/main_repository.dart';
import 'package:goski_student/data/repository/notification_repository.dart';
import 'package:goski_student/data/repository/settlement_repository.dart';
import 'package:goski_student/data/repository/ski_resort_repository.dart';
import 'package:goski_student/fcm/fcm_config.dart';
import 'package:goski_student/ui/main/u003_student_main.dart';
import 'package:goski_student/ui/reservation/u018_reservation_select.dart';
import 'package:goski_student/ui/user/u001_login.dart';
import 'package:goski_student/ui/user/u002_signup.dart';
import 'package:goski_student/view_model/lesson_list_view_model.dart';
import 'package:goski_student/view_model/login_view_model.dart';
import 'package:goski_student/view_model/main_view_model.dart';
import 'package:goski_student/view_model/notification_view_model.dart';
import 'package:goski_student/view_model/settlement_view_model.dart';
import 'package:goski_student/view_model/signup_view_model.dart';
import 'package:goski_student/view_model/ski_resort_view_model.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:logger/logger.dart';

import 'data/data_source/lesson_list_service.dart';
import 'data/repository/lesson_list_repository.dart';
import 'firebase_options.dart';

Logger logger = Logger();

void initDependencies() {
  Get.put(AuthService(), permanent: true);
  Get.put(SkiResortService(), permanent: true);
  Get.put(UserService(), permanent: true);
  Get.put(NotificationService(), permanent: true);
  Get.put(MainService(), permanent: true);
  Get.put(LessonListService(), permanent: true);
  Get.put(SettlementService(), permanent: true);

  Get.put(AuthRepository(), permanent: true);
  Get.put(SkiResortRepository(), permanent: true);
  Get.put(NotificationRepository(), permanent: true);
  Get.put(MainRepository(), permanent: true);
  Get.put(LessonListRepository(), permanent: true);
  Get.put(SettlementRepository(), permanent: true);

  Get.put(LoginViewModel(), permanent: true);
  Get.put(SignupViewModel(), permanent: true);
  Get.put(SkiResortViewModel(), permanent: true);
  Get.put(NotificationViewModel(), permanent: true);
  Get.put(MainViewModel(), permanent: true);
  Get.put(LessonListViewModel(), permanent: true);
  Get.put(SettlementViewModel(), permanent: true);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await dotenv.load(fileName: ".env");
  CustomDio.initialize();
  await EasyLocalization.ensureInitialized();
  initDependencies();
  final kakaoApiKey = dotenv.env['KAKAO_API_KEY'];
  KakaoSdk.init(nativeAppKey: kakaoApiKey);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setFCM();
  await FlutterDownloader.initialize(debug: true);
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
      getPages: [
        GetPage(
          name: '/reservation',
          page: () => const ReservationSelectScreen(),
        )
      ],
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
