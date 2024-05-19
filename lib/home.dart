import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:torch_light/torch_light.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isNear = false;
  String _text = "Stop service";
  @override
  void initState() {
    super.initState();
    // Listen to proximity sensor events
    _shownotification();
    ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = event > 0; // 0 means far, 1 means near
        _handleProximityChange();
      });
    });
  }
void _shownotification() async {
  final service = FlutterBackgroundService();
  bool isRunning = await service.isRunning();
  if (isRunning) {
    service.invoke('stopService');
  } else {
    service.startService();
  }
  if (!isRunning) {
    _text = "Stop Service";
  } else {
    _text = "Start Service";
  }
  setState(() {});
}

  void _handleProximityChange() async {
    if (_isNear) {
      // Turn on the torch when near
      try {

        await TorchLight.enableTorch();
      } on Exception catch (_) {
        // Handle error
      }
    } else {
      // Turn off the torch when far
      try {
        await TorchLight.disableTorch();
      } on Exception catch (_) {
        // Handle error
      }
    }
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
              padding: const EdgeInsets.only(left: 60, top: 50,right: 60),
              child: InkWell(
                onTap: () async {
                  try {
                    await TorchLight.enableTorch();
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
              padding: const EdgeInsets.only(left: 60, top: 50,right: 60),
              child: InkWell(
                onTap: () async {
                  try {

                    await TorchLight.disableTorch();
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
            const SizedBox(height: 30,),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Cover Your Sensor to turn ON_OFF THE Lights",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
