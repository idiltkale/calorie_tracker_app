import 'package:final_project/firebaseActivition.dart';
import 'package:final_project/screens/FirstScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Register> {
  final FireBaseAuthService _auth = FireBaseAuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String _selectedGender = '';

  FireBaseAuthService _authService = FireBaseAuthService();

  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 38, 111, 82),
                    Color.fromARGB(255, 166, 220, 200),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.75),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _usernameController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                        hintText: 'Name',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    TextField(
                      controller: _ageController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixIcon:
                            Icon(Icons.calendar_today, color: Colors.white),
                        hintText: 'Age',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    TextField(
                      controller: _weightController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixIcon:
                            Icon(Icons.monitor_weight, color: Colors.white),
                        hintText: 'Weight (kg)',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    TextField(
                      controller: _heightController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.height, color: Colors.white),
                        hintText: 'Height (cm)',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    TextField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.mail, color: Colors.white),
                        hintText: 'E-Mail',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    TextField(
                      controller: _passwordController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.people, color: Colors.white),
                        fillColor: Color.fromARGB(255, 135, 217, 184),
                        hintText: 'Gender',
                        hintStyle:
                            TextStyle(color: Color.fromARGB(255, 11, 2, 2)),
                      ),
                      style: TextStyle(color: Colors.white),
                      dropdownColor: Color.fromARGB(255, 88, 150, 126),
                      onChanged: (String? value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                      items: <String>['', 'Male', 'Female']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: size.height * 0.02),
                    InkWell(
                      onTap: () {
                        signUp();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Center(
                              child: Text("Save",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: size.height * .06, left: size.width * .02),
            child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_ios_outlined,
                        color: Colors.blue.withOpacity(.75), size: 26),
                  ),
                  SizedBox(width: size.width * 0.3),
                  Text("Register",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white.withOpacity(.75),
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> signUp() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String email = _emailController.text;
    int age = int.parse(_ageController.text);
    int weight = int.parse(_weightController.text);
    int height = int.parse(_heightController.text);

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user != null) {

      await _authService.saveUserData(
          username, email, age, weight, height, _selectedGender);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FirstScreen(),
        ),
      );
    } else {
      print("some error happened #3");
    }
  }
}
