import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: getUserProfileData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            String name = data['name'];
            int age = data['age'];
            String weight = '${data['weight']} kg';
            String height = '${data['height']} cm';
            String gender = data['gender'];
            String imageUrl;
            if (gender == 'Male') {
              imageUrl =
                  'https://cdn.icon-icons.com/icons2/2643/PNG/512/man_boy_people_avatar_user_person_black_skin_tone_icon_159355.png';
            } else {
              imageUrl =
                  'https://cdn.icon-icons.com/icons2/2643/PNG/512/avatar_female_woman_person_people_white_tone_icon_159360.png';
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.network(
                      imageUrl,
                      width: 250,
                      height: 250,
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    name,
                    style: TextStyle(fontSize: 24.0, fontFamily: 'Rajdhani'),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Age: $age',
                    style: TextStyle(fontSize: 18.0, fontFamily: 'Rajdhani'),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Weight: $weight',
                    style: TextStyle(fontSize: 18.0, fontFamily: 'Rajdhani'),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Height: $height',
                    style: TextStyle(fontSize: 18.0, fontFamily: 'Rajdhani'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<DocumentSnapshot> getUserProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.email;
    DocumentSnapshot userProfile =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userProfile;
  }
}
