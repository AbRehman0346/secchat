import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secchat/screens/register_screen.dart';
import 'package:secchat/services/firebase_auth_services.dart';
import 'package:secchat/xutils/xprogressbarbutton.dart';
import '../xutils/xtextfield.dart';
import '../xutils/route_generator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool isPasswordShown = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textFieldWidth = screenWidth / 1.25;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                RouteGenerator.generateRoute(
                    const RouteSettings(name: "/register")),
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.add_box,
              color: Colors.white,
            ),
            label: const Text(
              "Register",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Email Text Field.
          Center(
            child: SizedBox(
              width: textFieldWidth,
              child: XTextField(
                controller: emailController,
                prefixIcon: const Icon(Icons.email),
                hint: "Enter Email Address",
              ),
            ),
          ),
          const SizedBox(height: 20),

          //Password Text Field.
          Center(
            child: SizedBox(
              width: textFieldWidth,
              child: XTextField(
                controller: passwordController,
                hint: "Enter Password",
                obscureText: !isPasswordShown,
                autocorrect: false,
                enableSuggestions: false,
                prefixIcon: const Icon(Icons.password),
                suffixIcon: Checkbox(
                  value: isPasswordShown,
                  onChanged: (change) {
                    setState(() {
                      isPasswordShown = change!;
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),

          const SizedBox(width: 20),
          XProgressBarButton(
            loadingValue: isLoading,
            buttonText: "Login",
            onPressed: () async {
              String email = emailController.text.trim();
              String password = passwordController.text.trim();
              setState(() {
                isLoading = true;
              });
              try {
                if (email == "") {
                  throw Exception("Please Enter Your Email Address");
                }
                if (password == "") {
                  throw Exception("Please Enter Password");
                }
                User? user = await FirebaseAuthServices()
                    .signInWithEmailAndPassword(email, password);
                if (user != null) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      RouteGenerator.generateRoute(
                          RouteSettings(name: "/", arguments: user)),
                      (route) => false);
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              setState(() {
                isLoading = false;
              });
            },
          ),
        ],
      ),
    );
  }
}
