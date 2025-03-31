import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isGoogleSignInLoading = false;
  bool _isFacebookSignInLoading = false;
  bool _isAppleSignInLoading = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Username & Password Login
  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String username = _usernameController.text;
      final String password = _passwordController.text;

      if (username == 'admin' && password == 'password') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        Navigator.pushReplacementNamed(context, '/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password')),
        );
      }
    }
  }

  // Google Sign-In
  Future<void> _signInWithGoogle() async {
    setState(() => _isGoogleSignInLoading = true);

    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', googleUser.displayName ?? 'Google User');
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Sign-In Failed')),
      );
    }

    setState(() => _isGoogleSignInLoading = false);
  }

  //Facebook Login
  Future<void> _signInWithFacebook() async {
    setState(() => _isFacebookSignInLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', 'Facebook User');
    Navigator.pushReplacementNamed(context, '/');

    setState(() => _isFacebookSignInLoading = false);
  }

  // Apple Login
  Future<void> _signInWithApple() async {
    setState(() => _isAppleSignInLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', 'Apple User');
    Navigator.pushReplacementNamed(context, '/');

    setState(() => _isAppleSignInLoading = false);
  }

  //Continue as Guest
  Future<void> _continueAsGuest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', 'Guest');
    Navigator.pushReplacementNamed(context, '/');
  }

  // Forgot Password
  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Forgot Password'),
          content: TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Enter your email'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reset link sent to email')),
                );
                Navigator.pop(context);
              },
              child: const Text('Send Reset Link'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Social Login Button 
  Widget _buildSocialButton({
    required String label,
    required IconData icon,
    required bool isLoading,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
          : Icon(icon),
      label: isLoading ? Text('Signing in...') : Text('Login with $label'),
      style: ElevatedButton.styleFrom(backgroundColor: color),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }
//  Login Form
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a username' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a password' : null,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 16),

                    // Register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        const SizedBox(width: 20),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/register'),
                          child: const Text('Register', style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Social Login Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSocialButton(
                          label: 'Google',
                          icon: Icons.account_circle,
                          isLoading: _isGoogleSignInLoading,
                          onPressed: _signInWithGoogle,
                          color: Colors.white,
                        ),
                        _buildSocialButton(
                          label: 'Facebook',
                          icon: Icons.facebook,
                          isLoading: _isFacebookSignInLoading,
                          onPressed: _signInWithFacebook,
                          color: Colors.white,
                        ),
                        _buildSocialButton(
                          label: 'Apple',
                          icon: Icons.apple,
                          isLoading: _isAppleSignInLoading,
                          onPressed: _signInWithApple,
                          color: Colors.white,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Continue as Guest Button
                    TextButton(
                      onPressed: _continueAsGuest,
                      child: const Text('Continue as Guest', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
