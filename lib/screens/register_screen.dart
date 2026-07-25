import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:lu_bus_tracker/models/user_model.dart';

import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _selectedRole = "student";
  bool isObscure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController busNumberController = TextEditingController();
  TextEditingController routeNumberController = TextEditingController();
  bool isLoading = false;

  void register() async {
    final authService = AuthService();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final role = _selectedRole;
    final busNumber = busNumberController.text.trim();
    final routeNumber = routeNumberController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        confirmPasswordController.text.trim().isEmpty ||
        (role == 'driver' && (busNumber.isEmpty || routeNumber.isEmpty))) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all the fields")));
      return;
    }
    if (password != confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Passwords do not match")));
      return;
    }
    if (!email.contains('gmail') && !email.contains('lus.ac.bd')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please use university email or a gmail")),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      await authService.registerUser(
        User(
          uid: '',
          email: email,
          role: role,
          routeNumber: routeNumber,
          busNumber: busNumber,
        ),
        password,
        context,
      );

      if (_selectedRole == 'driver') {
        final firebaseFirestore = FirebaseFirestore.instance;
        final busId = '${routeNumber}_$busNumber';

        await firebaseFirestore.collection('live_buses').doc(busId).set({
          'routeNumber': routeNumber,
          'busNumber': busNumber,
          'latitude': 24.86928,
          'longitude': 91.80473,
          'isActive': false,
          'driverId': FirebaseAuth.instance.currentUser!.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        title: Text("Create New Account"),
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.onPrimaryContainer.withValues(alpha: 0.5),
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(12),
                color: colorScheme.primaryContainer.withValues(alpha: 0.2),
              ),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
                        ),
                      ),
                    ),

                    if (_selectedRole == 'driver') ...[
                      SizedBox(height: 20),
                      TextFormField(
                        controller: routeNumberController,
                        maxLength: 1,
                        decoration: InputDecoration(
                          hintText: "Example: 1,2,3 and 4",
                          labelText: "Route Number",

                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: busNumberController,
                        maxLength: 2,
                        decoration: InputDecoration(
                          hintText: 'Example: 1 or 2 or 4 etc',
                          labelText: "Bus Number",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      obscureText: isObscure,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          child: Icon(
                            isObscure ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        labelText: "Password",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: isObscure,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          child: Icon(
                            isObscure ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        labelText: "Confirm Password",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text("Select Role", style: textTheme.titleMedium),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'student',
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                        ),
                        Text("Student", style: textTheme.bodyMedium),
                        SizedBox(width: 20),
                        Radio<String>(
                          value: 'driver',
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                              print(_selectedRole);
                            });
                          },
                        ),
                        Text("Driver", style: textTheme.bodyMedium),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: colorScheme.primaryContainer,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: register,
                      child: isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.grey,
                              ),
                            )
                          : Text("Register", style: textTheme.titleLarge),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Login", style: textTheme.titleMedium),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
