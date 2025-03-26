import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'addevent.dart';
import 'clubmanager.dart'; // Import the ClubManagerPage

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int selectedUserType = 0; // 0 = Student, 1 = Event Organizer, 2 = Club Manager
  bool obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      String collectionName;
      Widget destination;

      switch (selectedUserType) {
        case 0: // Student
          collectionName = 'student';
          final querySnapshot = await FirebaseFirestore.instance
              .collection(collectionName)
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

          if (querySnapshot.docs.isEmpty) {
            throw FirebaseAuthException(
              code: 'user-not-found',
              message: 'No student found with that email.',
            );
          }

          final userDoc = querySnapshot.docs.first;
          final userData = userDoc.data();

          if (userData['password'] != password) {
            throw FirebaseAuthException(
              code: 'wrong-password',
              message: 'Incorrect password.',
            );
          }

          destination = HomePage(studentData: userData);
          break;

        case 1: // Event Organizer
          collectionName = 'eventorganizer';
          final querySnapshot = await FirebaseFirestore.instance
              .collection(collectionName)
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

          if (querySnapshot.docs.isEmpty) {
            throw FirebaseAuthException(
              code: 'user-not-found',
              message: 'No organizer found with that email.',
            );
          }

          final userDoc = querySnapshot.docs.first;
          final userData = userDoc.data();

          if (userData['password'] != password) {
            throw FirebaseAuthException(
              code: 'wrong-password',
              message: 'Incorrect password.',
            );
          }

          destination = EventForm(organizerData: userData);
          break;

        case 2: // Club Manager
          collectionName = 'clubmanager';
          final querySnapshot = await FirebaseFirestore.instance
              .collection(collectionName)
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

          if (querySnapshot.docs.isEmpty) {
            throw FirebaseAuthException(
              code: 'user-not-found',
              message: 'No club manager found with that email.',
            );
          }

          final userDoc = querySnapshot.docs.first;
          final userData = userDoc.data();

          if (userData['password'] != password) {
            throw FirebaseAuthException(
              code: 'wrong-password',
              message: 'Incorrect password.',
            );
          }

          // Redirect to ClubManagerPage with the manager's data
          destination = ClubManagerPage(managerData: userData);
          break;

        default:
          throw Exception('Invalid user type selected');
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Authentication failed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.jpg', height: 100),
              SizedBox(height: 30),
              Text(
                'Login to NSBM Events',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildToggleButton('Student', 0)),
                  SizedBox(width: 10),
                  Expanded(child: _buildToggleButton('Organizer', 1)),
                  SizedBox(width: 10),
                  Expanded(child: _buildToggleButton('Club Manager', 2)),
                ],
              ),
              SizedBox(height: 20),
              _buildEmailField(),
              SizedBox(height: 15),
              _buildPasswordField(),
              SizedBox(height: 30),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, int userType) {
    return ElevatedButton(
      onPressed: () => setState(() => selectedUserType = userType),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedUserType == userType ? Colors.green : Colors.grey[300],
        padding: EdgeInsets.symmetric(vertical: 15),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selectedUserType == userType ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    String labelText;
    switch (selectedUserType) {
      case 0:
        labelText = 'Student Email';
        break;
      case 1:
        labelText = 'Organizer Email';
        break;
      case 2:
        labelText = 'Club Manager Email';
        break;
      default:
        labelText = 'Email';
    }

    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () => setState(() => obscurePassword = !obscurePassword),
        ),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
          'LOGIN',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}