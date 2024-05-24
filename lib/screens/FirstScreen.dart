import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MealTrackerScreen.dart';
import 'ProfileScreen.dart';
import 'SettingsScreen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class FirstScreen extends StatefulWidget {
  FirstScreen();

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  late Future<DocumentSnapshot> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calorie Tracker"),
      ),
      body: Container(
        child: FutureBuilder<DocumentSnapshot>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              final gender = userData['gender'];
              final weight = userData['weight'];
              final height = userData['height'];
              final age = userData['age'];
              String name = userData['name'];

              double calories = 0;
              int totalCalories = userData['totalCalories'] ?? 0;

              if (gender.toString() == 'Male') {
                calories =
                    66.5 + (13.75 * weight) + (5 * height) - (6.77 * age);
              } else {
                calories =
                    655.1 + (9.56 * weight) + (1.85 * height) - (4.67 * age);
              }

              double percentage = totalCalories / calories;
              bool isOverGoal = percentage > 1.0;

              return ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  Center(
                    child: Text(
                      'Welcome $name !',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 35,
                            fontFamily: 'Rajdhani',
                          ),
                    ),
                  ),
                  CircularPercentIndicator(
                    animation: true,
                    animationDuration: 1000,
                    radius: 120,
                    lineWidth: 30,
                    percent: percentage.clamp(0.0, 1.0),
                    progressColor: isOverGoal
                        ? Color.fromARGB(255, 190, 49, 39)
                        : Color.fromARGB(255, 80, 185, 143),
                    backgroundColor: isOverGoal
                        ? Color.fromARGB(255, 211, 127, 121)
                        : Color.fromARGB(255, 188, 241, 220),
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(
                      "${(percentage * 100).toStringAsFixed(1)}%",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 30,
                            fontFamily: 'Rajdhani',
                          ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      "Total Calories: $totalCalories",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 25,
                            fontFamily: 'Rajdhani',
                          ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      "Your goal: $calories",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 15,
                            fontFamily: 'Rajdhani',
                          ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MealTrackerScreen(mealType: 'Breakfast')),
                      ).then((_) {
                        setState(() {
                          _userDataFuture = _getUserData();
                        });
                      });
                    },
                    child: Container(
                      height: 170,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 54, 122, 95),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text("Breakfast",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 55,
                                fontFamily: 'Rajdhani')),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MealTrackerScreen(mealType: 'Lunch')),
                      ).then((_) {
                        setState(() {
                          _userDataFuture = _getUserData();
                        });
                      });
                    },
                    child: Container(
                      height: 170,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 54, 122, 95),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text("Lunch",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 55,
                                fontFamily: 'Rajdhani')),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MealTrackerScreen(mealType: 'Dinner')),
                      ).then((_) {
                        setState(() {
                          _userDataFuture = _getUserData();
                        });
                      });
                    },
                    child: Container(
                      height: 170,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 54, 122, 95),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text("Dinner",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 55,
                                fontFamily: 'Rajdhani')),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<DocumentSnapshot> _getUserData() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final user = _auth.currentUser;
    String? uid = user?.email;

    final docRef = _firestore.collection('users').doc(uid);
    return await docRef.get();
  }
}
