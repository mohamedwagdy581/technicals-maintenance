// ignore_for_file: unused_local_variable

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'home_layout/home_layout.dart';
import 'shared/components/constants.dart';
import 'shared/network/cubit/cubit.dart';
import 'shared/network/cubit/states.dart';
import 'shared/network/local/cash_helper.dart';
import 'shared/network/style/themes.dart';
import 'splash_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as FireStore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print('Get a Message While in the foreground');
    }
    if (kDebugMode) {
      print('Message Data ${message.data}');
    }
    if (message.notification != null) {
      if (kDebugMode) {
        print('Message also Contain Notification: ${message.notification}');
      }
    }
  });

  await CashHelper.init();
  bool? isDark = CashHelper.getData(key: 'isDark');
  uId = CashHelper.getData(key: 'uId');
  //city = CashHelper.getData(key: 'city');
  //technicalPhone = CashHelper.getData(key: 'technicalPhone');

  runApp(TechnicalRequests(
    isDark: isDark,
  ));
}

class TechnicalRequests extends StatelessWidget {
  final bool? isDark;
  const TechnicalRequests({super.key, this.isDark});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..getUserData()
        ..changeAppModeTheme(
          fromShared: isDark,
        ),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode:
                AppCubit.get(context).isDark ? ThemeMode.light : ThemeMode.dark,
            home: uId == null ? const SplashScreen() : const HomeLayout(),
          );
        },
      ),
    );
  }
}
