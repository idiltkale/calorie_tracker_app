import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_project/screens/LoginScreen.dart';
import 'package:final_project/bloc/theme_bloc/theme_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Dark Mode',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Switch(
                      value: state.switchvalue,
                      onChanged: (newvalue) {
                        newvalue
                            ? context.read<ThemeBloc>().add(ThemeOnEvent())
                            : context.read<ThemeBloc>().add(ThemeOffEvent());
                      },
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 16),
                    Text(
                      'Log out',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
