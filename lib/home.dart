import 'package:flutter/material.dart';

import 'package:torch_light/torch_light.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isNear = false;
  bool _isFlashlightOn = false;

  @override
  void initState() {
    super.initState();
    // Listen to proximity sensor events
    ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = event > 0; // 0 means far, 1 means near
        _handleProximityChange();
      });
    });
  }

  void _handleProximityChange() async {
    if (_isNear) {
      // Turn on the torch when near
      try {
        await TorchLight.enableTorch();
        setState(() {
          _isFlashlightOn = true;
        });
      } on Exception catch (_) {
        // Handle error
      }
    } else {
      // Turn off the torch when far
      try {
        await TorchLight.disableTorch();
        setState(() {
          _isFlashlightOn = false;
        });
      } on Exception catch (_) {
        // Handle error
      }
    }
  }

  Future<void> _showFlashlightNotification() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Flashlight Control',
      null,
      _buildFlashlightNotification(),
      payload: 'Flashlight Control',
    );
  }

  NotificationDetails _buildFlashlightNotification() {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'flashlight_notification_channel',
      'Flashlight Notification Channel',
      channelDescription: 'Channel for flashlight control notification',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
      enableVibration: false,
      onlyAlertOnce: true,
      showWhen: false,
      ongoing: true,
    );
    return NotificationDetails(android: androidPlatformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 60, top: 50, right: 60),
              child: InkWell(
                onTap: () async {
                  try {
                    await TorchLight.enableTorch();
                    setState(() {
                      _isFlashlightOn = true;
                    });
                  } on Exception catch (_) {
                    // Handle error
                  }
                },
                child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "Launch On",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60, top: 50, right: 60),
              child: InkWell(
                onTap: () async {
                  try {
                    await TorchLight.disableTorch();
                    setState(() {
                      _isFlashlightOn = false;
                    });
                  } on Exception catch (_) {
                    // Handle error
                  }
                },
                child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "Turn Off",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Cover Your Sensor to turn ON_OFF THE Lights",
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: _showFlashlightNotification,
              child: Text('Show Flashlight Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
