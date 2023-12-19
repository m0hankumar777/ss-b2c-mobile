import 'dart:async';
import 'dart:io';
import 'package:B2C/controller/localization_controller.dart';
import 'package:B2C/utility/translation_files.dart';
import 'package:B2C/const/config.dart' as config;
import 'package:B2C/const/url.dart' as env;
import 'package:B2C/view/screens/HomeScreen/notifications_screen.dart';
import 'package:B2C/view/screens/OnBoardingScreens/splash_screen.dart';
import 'package:B2C/view/screens/no_internet_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:B2C/controller/login_controller.dart' as login_auth;
import 'package:sentry_flutter/sentry_flutter.dart';

import 'model/Authentication/customer_model.dart';

const String exampleDsn =
    'https://e85b375ffb9f43cf8bdf9787768149e0@o447951.ingest.sentry.io/5428562';

const channel = MethodChannel('example.flutter.sentry.io');
final localizationController = Get.put(LocalizationController());
Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  final appPathDir = await getApplicationDocumentsDirectory();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Hive.initFlutter();
  Hive.init(appPathDir.path);
  Hive.registerAdapter<Customer>(CustomerAdapter());
  await Hive.openBox('login');
  await Hive.openBox("language");
  await Hive.openBox<Customer>("customer");
  await env.getBaseUrl();
  set();
  if (config.isProduction == true) {
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://bd3104f921994d4ca488b1dfba67bc50@o1178081.ingest.sentry.io/4505204653162496';
        options.tracesSampleRate = 0.01;
      },
      appRunner: () => runApp(MyApp()),
    );
  } else {
    runApp(MyApp());
  }

  // try{
  //   int? test;
  //   test! + 3 ;
  // }catch( Exception , StackTrace){
  //   debugPrint('CATHCH ERROR');
  //   await Sentry.captureException(Exception, stackTrace: StackTrace);

  // }

  // runApp(MyApp());
  DefaultAssetBundle(
    bundle: SentryAssetBundle(),
    child: MyApp(),
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xff580176),
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark));

  Connectivity().onConnectivityChanged.listen((event) {
    if (event == ConnectivityResult.none) {
      Get.to(const NoInternetScreen());
    } else {
      Get.back();
    }
  });
}

set() {
  if (Hive.box("language").values.contains("Hebrew")) {
    localizationController.changeLocale(const Locale('he', 'IL'));
  } else if (Hive.box("language").values.contains("English")) {
    localizationController.changeLocale(const Locale('en', 'US'));
  }
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});
  bool isLogin = login_auth.getLoginStatus();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        navigatorObservers: [
          SentryNavigatorObserver(),
        ],
        debugShowCheckedModeBanner: config.isProduction ? false : true,
        title: 'Glamz',
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        // supportedLocales: L10n.all,
        translations: LocaleString(),
        locale: Get.locale,
        fallbackLocale: const Locale('he', 'IL'),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('en', 'US'),
          Locale('he', 'IL'),
        ],
        home: const SplashScreen());
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class PushNotification {
  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  initNotifications(context) async {
    AndroidInitializationSettings androidSettings =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    var initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await notificationPlugin.initialize(
      initializationSettings,
      // onDidReceiveBackgroundNotificationResponse: (details) async {
      //   // if ( details.payload == "AppointmentScreen") {
      //   //    Get.to(() => const NotificationsScreen());
      //   // }
      // },
      onDidReceiveNotificationResponse: (details) async {
        if (details.payload == "AppointmentScreen") {
          Get.to(() => const NotificationsScreen());
        }
      },
    );
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          // "channelId",
          // "channelName",
          // importance: Importance.high,
          // priority: Priority.high,
          // color: Colors.red,
          // icon: "@mipmap/ic_launcher",
          // styleInformation: BigTextStyleInformation(" "),
          'channelId',
          'channelName',
          importance: Importance.high,
          priority: Priority.high, color: Colors.red,
          styleInformation: BigTextStyleInformation(''),
        ),
        iOS: DarwinNotificationDetails());
  }

  Future showNotifications(
      int id, String title, String body, String payload) async {
    return notificationPlugin.show(id, title, body, await notificationDetails(),
        payload: payload);
  }
}
