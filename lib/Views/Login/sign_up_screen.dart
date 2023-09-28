import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

var log = Logger();

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isButtonEnabled = false;
  bool passwordVisible = true;   
  bool confirmPasswordVisible = true;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> createAccount(
      String fullName,
      String username,
      String phoneNumber,
      String email,
      String password,
      String confirmPassword) async {
    try {
      if(password != confirmPassword){
        Fluttertoast.showToast(
          msg: "Password must be same with confirm password",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
        return;
      }
      await FirebaseFirestore.instance.collection("Accounts").add({
          "full_name": fullName,
          "username": username,
          "phone_number": phoneNumber,
          "email": email,
          "balance": 0,
        });
      
      final result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        Navigator.pushNamed(context, '/');        
        Fluttertoast.showToast(
            msg: "Account successfully created",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed to create account",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      throw Exception;
    }
  }

  @override
  void initState() {
    super.initState();
    isButtonEnabled = false;
    fullNameController.addListener(updateButtonState);
    usernameController.addListener(updateButtonState);
    phoneNumberController.addListener(updateButtonState);
    emailController.addListener(updateButtonState);
    passwordController.addListener(updateButtonState);
    confirmPasswordController.addListener(updateButtonState);
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled = fullNameController.text.length > 5 &&
          usernameController.text.isNotEmpty &&
          phoneNumberController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Your-Wallet",
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.indigo[900],
                            fontFamily: 'DancingScript'),
                      ),
                    ],
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Create a new account",
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 1.0,
                        // offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: fullNameController,
                    keyboardType: TextInputType.text,
                    // textInputAction: TextInputAction.continueAction,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      hintText: "Full Name",
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 1.0,
                        // offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: usernameController,
                    keyboardType: TextInputType.text,
                    // textInputAction: TextInputAction.continueAction,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      hintText: "Username",
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 1.0,
                        // offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.number,
                    // textInputAction: TextInputAction.continueAction,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      hintText: "Phone Number",
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 1.0,
                        // offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    // textInputAction: TextInputAction.continueAction,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      hintText: "Email",
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 1.0,
                        // offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: passwordVisible,
                    keyboardType: TextInputType.text,
                    // textInputAction: TextInputAction.continueAction,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      hintText: "Password",
                      suffixIcon: Container(
                        margin: EdgeInsets.only(right: 20.0),
                        child: InkWell(
                          child: Icon(passwordVisible ?
                            Icons.visibility_off_outlined : Icons.visibility_outlined
                          ),
                          onTap: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                            // Navigator.pushNamed(context, '/signup');
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 1.0,
                        // offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: confirmPasswordController,
                    obscureText: confirmPasswordVisible,
                    keyboardType: TextInputType.text,
                    // textInputAction: TextInputAction.continueAction,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      hintText: "Confirm Password",
                      suffixIcon: Container(
                        margin: EdgeInsets.only(right: 20.0),
                        child: InkWell(
                          child: Icon(confirmPasswordVisible ?
                            Icons.visibility_off_outlined : Icons.visibility_outlined
                          ),
                          onTap: () {
                            setState(() {
                              confirmPasswordVisible = !confirmPasswordVisible;
                            });
                            // Navigator.pushNamed(context, '/signup');
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                isButtonEnabled
                    ? InkWell(
                        onTap: () {
                          createAccount(
                            fullNameController.text,
                            usernameController.text,
                            phoneNumberController.text,
                            emailController.text,
                            passwordController.text,
                            confirmPasswordController.text,
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 45.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.indigoAccent[400],
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: Colors.blueAccent,
                              width: 1.0,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5.0,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: 45.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
