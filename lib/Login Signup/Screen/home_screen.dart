import 'package:flutter/material.dart';
import 'package:flutter_application_4/WorkoutScreen.dart';
import 'package:flutter_application_4/google_auth.dart';
import 'package:flutter_application_4/YemenFitnessClubsMap.dart'; // استيراد صفحة الخرائط
import '../Widget/button.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم اللياقة البدنية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseServices().googleSignOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F3443), Color(0xFF34A694)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fitness_center, size: 100, color: Colors.white),
              const SizedBox(height: 30),
              const Text(
                'مرحبًا بك في فيتنس برو!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  ' ابدأ رحلتك في اللياقة البدنية مع تمارين مخصصة وخطط غذائية',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WorkoutScreen()),
                  );
                },
                child: const Text("عرض التمارين"),
              ),
              const SizedBox(height: 20), // مسافة بين الأزرار
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  YemenFitnessClubsMap()),
                  );
                },
                child: const Text('فتح الخرائط'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}