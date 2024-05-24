import 'package:final_project/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/screens/LoginScreen.dart';
import 'package:final_project/firebase_options.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'bloc/bloc_exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
            apiKey: "AIzaSyCUBvk-Xy7Bwj9XOmTPC2GwSb0d1r7lAxk",
            authDomain: "finalproject-755.firebaseapp.com",
            projectId: "finalproject-755",
            storageBucket: "finalproject-755.appspot.com",
            messagingSenderId: "423477202439",
            appId: "1:423477202439:web:92a3532b94e2837dad24a2",
            measurementId: "G-XEX2LMJNV7")
        : DefaultFirebaseOptions.currentPlatform,
  );

  runPeriodicTask();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  runApp(const MyApp());
}

void runPeriodicTask() async {
  var now = DateTime.now();
  var targetTime = DateTime(now.year, now.month, now.day, 21, 54);
  
  if (now.isAfter(targetTime)) {
    targetTime = targetTime.add(Duration(days: 1));
  }

  var timeUntilTarget = targetTime.difference(now);

  Timer(timeUntilTarget, () {
    resetDailyData();
    runPeriodicTask();
  });
}

Future<void> resetDailyData() async {
  await resetSelectedItems();
  await resetTotalCalories();
}

Future<void> resetSelectedItems() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = _auth.currentUser;

  if (user != null) {
    String? uid = user.email;
    final docRef = _firestore.collection('users').doc(uid);

    await docRef.set({
      'selectedItemsBreakfast': [],
      'selectedItemsLunch': [],
      'selectedItemsDinner': [],
    }, SetOptions(merge: true));
  }
}

Future<void> resetTotalCalories() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = _auth.currentUser;

  if (user != null) {
    String? uid = user.email;
    final docRef = _firestore.collection('users').doc(uid);

    await docRef.set(
      {'totalCalories': 0}, 
      SetOptions(merge: true),
    );
  }
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Your App Title',
            theme: state.switchvalue
                ? AppThemes.appThemeData[AppTheme.darkTheme]
                : AppThemes.appThemeData[AppTheme.lightTheme],
            home: LoginScreen(),
          );
        },
      ),
    );
  }
}