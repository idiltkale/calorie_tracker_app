import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FireBaseAuthService {
    final FirebaseAuth _auth =FirebaseAuth.instance;


    Future<User?> signUpWithEmailAndPassword(String email, String password) async{
      try{
        UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        return credential.user;
      }catch(e){
        print("error #1");
      }
      return null;
    }
       Future<User?> signInWithEmailAndPassword(String email, String password) async{
      try{
        UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
        return credential.user;
      }catch(e){
        print("error #2");
      }
      return null;
    }

 
Future<void> saveUserData(String username, String email, int age, int weight, int height,String gender) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(email).set({
      'name': username,
      'email': email,
      'age': age,
      'weight': weight,
      'height': height,
      'gender': gender,
    });
  } catch (e) {
    print("Error #4");
  }
}


}
