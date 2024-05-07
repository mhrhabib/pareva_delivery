import 'package:firebase_messaging/firebase_messaging.dart';

import '/Screen/Widgets/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'Controllers/global-controller.dart';
import 'Locale/language.dart';
import 'Screen/SplashScreen/splash_screen.dart';
import 'services/firebase_api.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const firebaseOptions = FirebaseOptions(
    appId: '1:355415826812:android:e125cda3831749eec3c4f9',
    apiKey: 'AIzaSyDvb9CjqamR5CCosPpNXdxCDGGUqbULdMA',
    projectId: 'pareva-e14d9',
    messagingSenderId: '355415826812',
    authDomain: 'pareva-e14d9.appspot.com',
  );
  await Firebase.initializeApp(name: 'courier', options: firebaseOptions);

  await FirebaseApi().initNotifications();
  await FirebaseApi().setupFlutterLocalNotifications();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    FirebaseApi().showFlutterNotification(title: message.notification!.title!, body: message.notification!.body!);
    print("hello");
  });
  final box = GetStorage();
  await GetStorage.init();
  dynamic langValue = const Locale('en', 'US');
  if (box.read('lang') != null) {
    langValue = Locale(box.read('lang'), box.read('langKey'));
  } else {
    langValue = const Locale('en', 'US');
  }
  runApp(MyApp(lang: langValue));
}

class MyApp extends StatelessWidget {
  final Locale lang;
  MyApp({Key? key, required this.lang}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: kMainColor));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Get.put(GlobalController()).onInit();

    return ScreenUtilInit(
        designSize: Size(360, 800),
        builder: ((context, child) => GetMaterialApp(
              debugShowCheckedModeBanner: false,
              translations: Languages(),
              locale: lang,
              title: 'Merchant',
              theme: ThemeData(fontFamily: 'Display'),
              home: const SplashScreen(),
            )));
  }
}
