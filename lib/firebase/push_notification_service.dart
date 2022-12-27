import 'dart:async';
//import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../routes.dart';
import '../screens/notification_screen.dart';
import 'notification_service.dart';

class PushNotificationService {

  //static FirebaseMessaging messagin = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messageStream = new StreamController();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async{
    //La app esta en segundo plano
    //print('on Background Handler ${message.messageId}');
    _messageStream.add(message.notification!.title ?? 'No title');
    print('Lego en 1');
    Routes.navigatorKey?.currentState?.pushNamed('/notification');
    
  }

  static Future _onMessageHandler(RemoteMessage message) async{
    //La app esta abierta
    //print('on Message Handler ${message.messageId}');
    print('Lego en dos');
    _messageStream.add(message.notification!.title ?? 'No title');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async{
    //La app esta cerrada
    //print('on Message Open App ${message.messageId}');
    print('Lego en tres');
    Routes.navigatorKey?.currentState?.pushNamed('/notification');
    _messageStream.add(message.notification!.title ?? 'No title');
  }

  static Future initializeApp() async{

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );

    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');
    

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);//app abierta
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static closeStreams(){
    _messageStream.close();
  }
}