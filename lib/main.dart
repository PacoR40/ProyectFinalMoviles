import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:practica7/firebase/push_notification_service.dart';
import 'package:practica7/screens/onboarding_screen.dart';
import 'package:practica7/screens/sign_up_screen.dart';
import 'package:provider/provider.dart';
import 'provider/theme_provider2.dart';
import 'screens/add_product_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/detail_profile_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/subscriptions_screen.dart';
import 'screens/update_product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  final settings = await Hive.openBox('settings');
  bool isLightTheme = settings.get('isLightTheme') ?? false;
  print(isLightTheme);

  await PushNotificationService.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  
  runApp(
    // MultiProvider(
    //   providers: [
    //     Provider<ThemeProvider>(
    //       create: (_) => ThemeProvider(isLightTheme: isLightTheme),
    //     )
    //   ],
    //   child: AppStart(),
    // ),
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(isLightTheme: isLightTheme),
      child: AppStart(),
    )
  );

}

class AppStart extends StatelessWidget {
  const AppStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    // return MultiProvider(
    //   providers: [
    //       Provider<NotificationService>(
    //         create: (context) => NotificationService(),
    //       ),
    //   ],
    //   child: MyApp( themeProvider: themeProvider)
    // );
    return MyApp(
      themeProvider: themeProvider,
    );
  }
}

class MyApp extends StatefulWidget with WidgetsBindingObserver {
  final ThemeProvider? themeProvider;

  const MyApp({Key? key, this.themeProvider}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    PushNotificationService.messagesStream.listen((message) {
      print('MyApp: $message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Control Abarrotera',
      theme: widget.themeProvider?.themeData(),
      home: SplashScreen(),
      routes: {
        '/signUp' : (BuildContext) => SignUpScreen(),
        '/onBoarding' : (BuildContext) => onBoardingScreen(),
        '/dashboard' : (BuildContext) => DashboardScreen(),
        '/addProduct' : (BuildContext) => addProductScreen(),
        '/updateProduct' : (BuildContext) => updateProductScreen(),
        '/selectSubs' : (BuildContext) => subscriptionsScreen(),
        '/profile' : (BuildContext) => ProfileScreen(),
        '/notification' : (BuildContext) => notificationScreen(),
      },
    );
  }
}