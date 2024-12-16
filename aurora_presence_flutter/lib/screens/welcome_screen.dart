import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isLoginHovering = false;
  bool isCreateAccountHovering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0546FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Image.asset(
                'images/logo.png',
                height: 100.0,
                width: 100.0,
              ),
            ),
            const SizedBox(height: 1),
            Image.asset(
              'images/des.png',
              height: 150.0,
              width: 150.0,
            ),
            const SizedBox(height: 35),
            const Text(
              "Halo Sobat Aurora Presence",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  isLoginHovering = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isLoginHovering = false;
                });
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 100.0),
                  decoration: BoxDecoration(
                    color: isLoginHovering ? Colors.white : const Color(0xFF0546FF),
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: Colors.white, width: 2.0),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: isLoginHovering ? const Color(0xFF0546FF) : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  isCreateAccountHovering = true;
                });
              },
              onExit: (_) {
                setState(() {
                  isCreateAccountHovering = false;
                });
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 60.0),
                  decoration: BoxDecoration(
                    color: isCreateAccountHovering ? const Color(0xFF0546FF) : Colors.white,
                    borderRadius: BorderRadius.circular(
                        isCreateAccountHovering ? 50.0 : 30.0),
                    border: Border.all(
                      color: isCreateAccountHovering ? Colors.white : const Color(0xFF0546FF),
                      width: 2.0,
                    ),
                  ),
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                      color: isCreateAccountHovering ? Colors.white : const Color(0xFF0546FF),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Login with Social Media",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialIcon('images/instagram.png'),
                const SizedBox(width: 20),
                _buildSocialIcon('images/twitter.png'),
                const SizedBox(width: 20),
                _buildSocialIcon('images/facebook.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String imagePath) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Image.asset(
        imagePath,
        height: 30.0,
        width: 30.0,
        color: const Color(0xFF0546FF),
      ),
    );
  }
}