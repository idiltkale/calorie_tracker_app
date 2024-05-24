class FoodItem {
  final String foodName;
  final int calories;

  FoodItem({required this.foodName, required this.calories});

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      foodName: json['foodName'],
      calories: json.containsKey('calories') ? json['calories'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodName': foodName,
      'calories': calories,
    };
  }
}