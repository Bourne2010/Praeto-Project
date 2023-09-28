import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

var log = Logger();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = true;
  bool isButtonEnabled = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


Future<void> signIn(
      // String fullName,
      // String username,
      // String phoneNumber,
      String email,
      String password,
      // String confirmPassword
      ) async {
    try {
      // log.d('aaaa');
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        
        Navigator.pushNamed(context, '/home');
        Fluttertoast.showToast(
            msg: "Successfully Login",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }
      Fluttertoast.showToast(
          msg: "Login Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Login Failed",
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
    emailController.addListener(updateButtonState);
    passwordController.addListener(updateButtonState);
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled = emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          fontFamily: 'DancingScript',
                        ),
                      ),
                    ],
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Login to your account",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
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
                const SizedBox(height: 20.0),
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
                    keyboardType: TextInputType.text,
                    obscureText: passwordVisible,
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
                          child: Icon( passwordVisible ? 
                            Icons.visibility_off_outlined : Icons.visibility_outlined
                          ),
                          onTap: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
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
                          signIn(emailController.text,passwordController.text);
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
                              "Login",
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
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: 50.0),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                      ),
                      SizedBox(width: 10.0),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
