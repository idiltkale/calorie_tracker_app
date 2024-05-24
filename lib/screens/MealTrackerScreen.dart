import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/FoodItem.dart';

class CustomFoodItemWidget extends StatelessWidget {
  final String foodName;
  final int calories;
  final bool isChecked;
  final Function(bool?) onChanged;

  CustomFoodItemWidget({
    required this.foodName,
    required this.calories,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.restaurant),
      title: Text(
        foodName,
        style: TextStyle(fontSize: 25, fontFamily: 'Rajdhani'),
      ),
      subtitle: Text(
        '$calories calories',
        style:
            TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'Rajdhani'),
      ),
      trailing: Checkbox(
        value: isChecked,
        onChanged: (newValue) {
          onChanged(newValue);
        },
      ),
    );
  }
}

class MealTrackerScreen extends StatefulWidget {
  final String mealType;

  MealTrackerScreen({
    required this.mealType,
  });

  @override
  _MealTrackerScreenState createState() => _MealTrackerScreenState();
}

class _MealTrackerScreenState extends State<MealTrackerScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<FoodItem> foodItems = [];
  List<FoodItem> filteredItems = [];
  Set<String> selectedItems = {};
  int totalCalories = 0;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _loadFoodItems();
    _loadTotalCalories();
    _loadSelectedItems();
  }

  @override
  void dispose() {
    _searchController.dispose;
    _saveSelectedItems();
    super.dispose();
  }

  Future<void> _loadFoodItems() async {
    final jsonString = await rootBundle.loadString('assets/data/foods.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);

    final List<FoodItem> foodList =
        jsonData.map((item) => FoodItem.fromJson(item)).toList();

    setState(() {
      foodItems = foodList;
      filteredItems = foodItems;
    });
  }

  Future<void> _loadTotalCalories() async {
    final user = _auth.currentUser;

    if (user != null) {
      String? uid = user.email;
      final docRef = _firestore.collection('users').doc(uid);
      final docSnap = await docRef.get();

      if (docSnap.exists && docSnap.data()!.containsKey('totalCalories')) {
        setState(() {
          totalCalories = docSnap.data()!['totalCalories'];
        });
      }
    }
  }

  Future<void> _loadSelectedItems() async {
    final user = _auth.currentUser;

    if (user != null) {
      final fieldName = _getFieldName();
      String? uid = user.email;
      final docRef = _firestore.collection('users').doc(uid);
      final docSnap = await docRef.get();

      if (docSnap.exists && docSnap.data()!.containsKey(fieldName)) {
        final List<String> selectedItemIds =
            List<String>.from(docSnap.data()![fieldName]);
        setState(() {
          selectedItems = Set.from(selectedItemIds);
        });
      }
    }
  }

  Future<void> _saveSelectedItems() async {
    final user = _auth.currentUser;

    if (user != null) {
      final fieldName = _getFieldName();
      String? uid = user.email;
      final docRef = _firestore.collection('users').doc(uid);
      await docRef.set(
        {
          fieldName: selectedItems.toList(),
          'totalCalories': totalCalories,
        },
        SetOptions(merge: true),
      );
    }
  }

  String _getFieldName() {
    switch (widget.mealType) {
      case "Breakfast":
        return "selectedItemsBreakfast";
      case "Lunch":
        return "selectedItemsLunch";
      case "Dinner":
        return "selectedItemsDinner";
      default:
        return "";
    }
  }

  void _toggleItemSelection(String foodName, int calories) {
    setState(() {
      if (selectedItems.contains(foodName)) {
        selectedItems.remove(foodName);
        totalCalories -= calories;
      } else {
        selectedItems.add(foodName);
        totalCalories += calories;
      }
      _moveToTop(foodName);
      _saveToFirestore();
    });
  }

  void _saveToFirestore() async {
    final user = _auth.currentUser;
    if (user != null) {
      final fieldName = _getFieldName();
      String? uid = user.email;
      final docRef = _firestore.collection('users').doc(uid);
      await docRef.set(
        {
          fieldName: selectedItems.toList(),
          'totalCalories': totalCalories,
        },
        SetOptions(merge: true),
      );
    }
  }

  void _moveToTop(String foodName) {
    final index = foodItems.indexWhere((item) => item.foodName == foodName);
    if (index != -1) {
      final foodItem = foodItems.removeAt(index);
      if (!selectedItems.contains(foodName)) {
        foodItems.add(foodItem);
      } else {
        foodItems.insert(0, foodItem);
      }
    }
  }

  void _ForSearch(String input) {
    setState(() {
      filteredItems = foodItems
          .where((item) =>
              item.foodName.toLowerCase().contains(input.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.mealType} List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('foods').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final List<FoodItem> foodItems = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return FoodItem(
                foodName: data['foodName'],
                calories: data['calories'],
              );
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: _ForSearch,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total Calories: $totalCalories',
                    style: TextStyle(fontSize: 30, fontFamily: 'Rajdhani'),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final foodItem = filteredItems[index];
                      final isChecked =
                          selectedItems.contains(foodItem.foodName);

                      return CustomFoodItemWidget(
                        foodName: foodItem.foodName,
                        calories: foodItem.calories,
                        isChecked: isChecked,
                        onChanged: (value) {
                          _toggleItemSelection(
                              foodItem.foodName, foodItem.calories);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
