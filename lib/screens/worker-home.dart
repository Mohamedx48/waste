import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:smartcity_app/firebase_options.dart';

import '../main.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

class WorkerHome extends StatefulWidget {
  const WorkerHome({Key? key}) : super(key: key);

  @override
  _WorkerHomeState createState() => _WorkerHomeState();
}

class _WorkerHomeState extends State<WorkerHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  handleNotification() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.requestPermission(
        sound: true, badge: true, alert: true, provisional: true);
    await _firebaseMessaging.subscribeToTopic('pushNotifications');
    await Firebase.initializeApp();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        flutterLocalNotificationsPlugin.show(notification.hashCode,
            notification.title, notification.body, androidDetails);
      }
      // copy code here
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        flutterLocalNotificationsPlugin.show(notification.hashCode,
            notification.title, notification.body, androidDetails);
      }
    });
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        flutterLocalNotificationsPlugin.show(notification.hashCode,
            notification.title, notification.body, androidDetails);
      }
      return Future.value(null);
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    if (userData.get('type') == 'employee') handleNotification();
    _getData();
  }

  _getData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    try {
      DatabaseEvent event = await ref.once();
      print(event.snapshot.value); 
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: FirebaseDatabase.instance.ref('dist').onValue,
          builder: (c, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            final data = snapshot.data as DatabaseEvent;

            final distance = data.snapshot.value;
            if (int.parse(distance.toString()) <= 8) {
              sendNotification("الحق", "الزبالة يبنى");
              print("$distance send notification.. the bin is full");
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('GPS  Sensor'),
                Text(
                  'Distance $distance',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            );
          },
        ),
      ),
    ));
  }
}

class GpsSensor {
  String lat;
  String lng;

  GpsSensor(this.lat, this.lng);

  fromJson(Map<String, dynamic> data) {
    lat = data['lat'].toString();
    lng = data['lng'].toString();
  }
}
