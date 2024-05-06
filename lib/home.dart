import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
      
          children: [
      
            Padding(
              padding: const EdgeInsets.only(left: 60,top: 50),
              child: InkWell(
                onTap: ()async{
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
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: const Center(
                    child: Text("Launch On",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15
                    ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60,top: 50),
              child: InkWell(
                onTap: ()async {
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
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: const Center(
                    child: Text("Turn Off",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 15
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30,),
            const Padding(
              padding:  EdgeInsets.only(left: 20),
              child: Text("Cover Your Sensor to turn ON_OFF THE Lights",
              style: TextStyle(
                fontSize: 20
              ),),
            )
      
      
          ],
        ),
      ),
    );
  }
}
