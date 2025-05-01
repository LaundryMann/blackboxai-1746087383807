import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _errorMessage;

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      if (userCredential.user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => DashboardScreen()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      if (userCredential.user != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => DashboardScreen()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Planner Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration:
                  InputDecoration(labelText: 'Email', icon: Icon(Icons.email)),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration:
                  InputDecoration(labelText: 'Password', icon: Icon(Icons.lock)),
              obscureText: true,
            ),
            SizedBox(height: 20),
            if (_errorMessage != null)
              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            if (_isLoading)
              CircularProgressIndicator()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: _login, child: Text('Login')),
                  ElevatedButton(onPressed: _register, child: Text('Register')),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
