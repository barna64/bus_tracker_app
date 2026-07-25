import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lu_bus_tracker/screens/driver_home.dart';
import 'package:lu_bus_tracker/screens/email_verification_screen.dart';
import 'package:lu_bus_tracker/screens/login_screen.dart';
import 'package:lu_bus_tracker/screens/student_home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          }
          if (snapshot.hasData) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get(),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong!'));
                }

                if (snapshot.hasData && snapshot.data!.exists) {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  final role = userData['role'] ?? 'student';
                  if (FirebaseAuth.instance.currentUser!.emailVerified) {
                    //  print("Yes, email is verified");
                    if (role == 'driver') {
                      return DriverHome();
                    }
                    if (role == 'student') {
                      return StudentHome();
                    }
                  } else {
                    return EmailVerificationScreen();
                  }
                }
                return LoginScreen();
              },
            );
          }
          return LoginScreen();
        },
      ),
    );
  }
}
