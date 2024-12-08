import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshlink/views/screens/auth/login_screen.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyAF5KRZPnTUjPKjf_3M27BbJYw3g-M6I6w',
              appId: '1:810821731815:android:e4d328337a97a6a844e942',
              messagingSenderId: '810821731815',
              projectId: 'fresh-1bb19',
              storageBucket: 'fresh-1bb19.appspot.com'),
        )
      : await Firebase.initializeApp();

  // Initialize Stripe
  Stripe.publishableKey =  "pk_test_51QTNwwE6LP0EGzPeQCxQVtufj1nE0t8fkLwbUWfpRnNRVvEXBhH9P1S38MKpX0HvmWRK3tLngMux39wE0VFjno3m00xnu6WaMQ";
  //Stripe.merchantIdentifier = "your_merchant_identifier_here"; // Optional for Apple Pay

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}
