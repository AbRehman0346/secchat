import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secchat/services/firebase_auth_services.dart';
import 'package:secchat/xutils/xprogressbarbutton.dart';
import '../xutils/xtextfield.dart';
import '../constants/AppConstants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secchat/xutils/route_generator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isPasswordShown = false;
  bool isLoading = false;
  double spaceBetweenFields = 20;
  late final User? user;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conformPasswordController = TextEditingController();
  Map<String, Object?> profileImage = {
    "image": null,
    "width": 120.0,
    "height": 120.0,
  };
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //360.0
    double screenHeight = MediaQuery.of(context).size.height; //752.0
    double textFieldWidth = screenWidth / 1.25;
    double appBarHeight = screenHeight / (752 / 60);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        toolbarHeight: screenHeight / (752 / 60),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  RouteGenerator.generateRoute(
                      const RouteSettings(name: "/login")),
                  (route) => false);
            },
            icon: const Icon(
              Icons.login,
              color: Colors.white,
            ),
            label: const Text(
              "Login",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight - appBarHeight - 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Picture Container
              Container(
                width: profileImage["width"] as double,
                height: profileImage["height"] as double,
                // color: Colors.grey,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: double.infinity,
                      // backgroundImage: profileImage["image"] == null
                      //     ? AssetImage("assetName")
                      //     : FileImage(profileImage["image"] as File),
                      child: ClipOval(
                        child: profileImage["image"] == null
                            ? Image.asset(
                                AppContent.profilePlaceHolder,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                profileImage["image"] as File,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10, right: 25),
                        child: InkWell(
                          onTap: () async {
                            ImagePicker pic = ImagePicker();
                            XFile? picked = await pic.pickImage(
                                source: ImageSource.gallery);
                            setState(() {
                              profileImage["image"] = File(picked!.path);
                            });
                          },
                          child: const Icon(Icons.camera_alt_outlined,
                              color: Colors.blue, size: 30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              //First Name Text Field.
              Center(
                //First Name Entrance Field.
                child: Container(
                  width: textFieldWidth,
                  child: XTextField(
                    controller: firstNameController,
                    prefixIcon: const Icon(Icons.add_circle),
                    hint: "First Name",
                  ),
                ),
              ),
              SizedBox(height: spaceBetweenFields),

              //Last Name Entrance Field.
              Center(
                child: Container(
                  width: textFieldWidth,
                  child: XTextField(
                    controller: lastNameController,
                    prefixIcon: const Icon(Icons.add_circle),
                    hint: "Last Name",
                  ),
                ),
              ),
              SizedBox(height: spaceBetweenFields),

              //Phone TextField
              Center(
                child: Container(
                  width: textFieldWidth,
                  child: XTextField(
                    controller: phoneController,
                    prefixIcon: const Icon(Icons.phone),
                    hint: "Phone (Optional)",
                  ),
                ),
              ),
              SizedBox(height: spaceBetweenFields),

              //Email Text Field.
              Center(
                child: Container(
                  width: textFieldWidth,
                  child: XTextField(
                    controller: emailController,
                    prefixIcon: const Icon(Icons.email),
                    hint: "Enter Email Address",
                  ),
                ),
              ),
              SizedBox(height: spaceBetweenFields),

              //Password Text Field.
              Center(
                child: Container(
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
              SizedBox(height: spaceBetweenFields),

              //Conform Password Field
              Center(
                child: Container(
                  width: textFieldWidth,
                  child: XTextField(
                    controller: conformPasswordController,
                    hint: "Enter Password",
                    obscureText: !isPasswordShown,
                    autocorrect: false,
                    enableSuggestions: false,
                    prefixIcon: const Icon(Icons.password),
                  ),
                ),
              ),

              // Register Button
              const SizedBox(height: 15),
              //Check Box for Showing or Hiding Password.
              // Padding(
              //   padding: EdgeInsets.only(left: margin),
              //   child: XCheckBox(
              //     value: isPasswordShown,
              //     onChanged: () {
              //       setState(() {
              //         isPasswordShown = !isPasswordShown;
              //       });
              //     },
              //     s: "Show Password",
              //   ),
              // ),

              // SizedBox(width: spaceBetweenFields),
              XProgressBarButton(
                loadingValue: isLoading,
                buttonText: "Register",
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    if (firstNameController.text == "") {
                      throw Exception("First Name Field is Required");
                    }
                    if (lastNameController.text == "") {
                      throw Exception("Last Name Field is Required");
                    }
                    if (emailController.text == "") {
                      throw Exception("Email Field is Required");
                    }
                    if (passwordController.text == "") {
                      throw Exception("Password Field is Required");
                    }
                    if (conformPasswordController.text == "") {
                      throw Exception("Please Confirm Password");
                    }
                    if (passwordController.text !=
                        conformPasswordController.text) {
                      throw Exception("Passwords Doesn't Match");
                    }
                    user = await FirebaseAuthServices().registerNewUser(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      phone: phoneController.text == ""
                          ? null
                          : phoneController.text,
                      file: profileImage["image"] == null
                          ? null
                          : profileImage["image"] as File,
                    );
                    user ?? {throw Exception("Error: Can't Register")};
                    Navigator.pushAndRemoveUntil(
                      context,
                      RouteGenerator.generateRoute(
                          RouteSettings(name: "/", arguments: user)),
                      (route) => false,
                    );
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                    print("Flutter Error: $e");
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
