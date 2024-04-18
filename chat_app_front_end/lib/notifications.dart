import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

class NotificationSetup {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initializeNotification() async {
    AwesomeNotifications().initialize(
      null, 
      [
        NotificationChannel(
          channelKey: 'high_importance_channel',
          channelName: 'Chat notifications',
          channelDescription: 'Chat notifications',
          channelShowBadge: true,
          importance: NotificationImportance.Max,
          vibrationPattern: highVibrationPattern,
        )
      ],
    );

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if(!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  void configurePushNotifications(BuildContext context) async {
    initializeNotification();
    await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true
      );
    
    if(Platform.isIOS) getIOSPermission();

    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('==========');
      print('=====${message.notification!.body}=====');
      print('==========');
      
      if(message.notification != null) {
        createOrderNotifications(
          title: message.notification!.title,
          body: message.notification!.body
        );
      }
    });
  }

  Future<void> createOrderNotifications({String? title, String? body}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0, 
        channelKey: 'high_importance_channel',
        title: title,
        body: body
      )
    );
  }

  void eventListenerCallback(BuildContext context) {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceiveMethod,
    );
  }
  
  void getIOSPermission() {
    _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true
    );
  }

}

Future<dynamic> myBackgroundMessageHandler (RemoteMessage message) async {
  await Firebase.initializeApp();
}

class NotificationController {
  static Future<void> onActionReceiveMethod(ReceivedNotification receivedNotification) async {
    
  }
}