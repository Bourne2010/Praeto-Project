import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

var log = Logger();

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  late String fullName = 'guest';
  late String username = 'guest';
  late String phoneNumber = '00000000';
  late String email = 'guest@com';


  getData() async {
    final QuerySnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance.collection('Accounts').where('email', isEqualTo: currentUser?.email).get();
    DocumentSnapshot Document = documentSnapshot.docs[0];
    Map<String, dynamic> profileData = Document.data() as Map<String, dynamic>;
    // log.d(profileData);
    setState(() {
      fullName = profileData['full_name'];
      username = profileData['username'];
      phoneNumber = profileData['phone_number'];
      email = profileData['email'];
    });
  }

  onEditPhoneNumber(String phoneNumber2) async {
    final QuerySnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance.collection('Accounts').where('email', isEqualTo: currentUser?.email).get();
      await documentSnapshot.docs.first.reference.update({
        'phone_number':phoneNumber2,
      });
      setState(() {
        phoneNumber = phoneNumber2;
      });
  }

  onEditFullName(String fullName2) async {
    if(fullName2.length < 6){
      Fluttertoast.showToast(
            msg: "Full Name must be at least 5 character",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      return;
    }
    final QuerySnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance.collection('Accounts').where('email', isEqualTo: currentUser?.email).get();
      await documentSnapshot.docs.first.reference.update({
        'full_name':fullName2,
      });
      setState(() {
        fullName = fullName2;
      });
  }


  @override
  void initState() {
    getData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Detail Profile",
                      style: TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Text(
                      "Full Name",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      fullName,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      child: InkWell(
                        onTap: () {
                          showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Edit full name'),
                                    content: TextField(
                                      controller: fullNameController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          hintText: "Input full name"),
                                    ),
                                    actions: [
                                      Center(
                                        child: InkWell(
                                          onTap: () {
                                            onEditFullName(fullNameController.text);
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 8.0,
                                              horizontal: 12.0,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(6.0),
                                              ),
                                              color: Colors.teal[100],
                                            ),
                                            child: Text("Confirm"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit,
                              size: 18.0,
                            ),
                            Text("Edit"),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Username",
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          username,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Text(
                      "Phone Number",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      phoneNumber,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      child: InkWell(
                        onTap: () {
                          showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Edit phone number'),
                                    content: TextField(
                                      controller: phoneNumberController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          hintText: "Input number"),
                                    ),
                                    actions: [
                                      Center(
                                        child: InkWell(
                                          onTap: () {
                                            onEditPhoneNumber(phoneNumberController.text);
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 8.0,
                                              horizontal: 12.0,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(6.0),
                                              ),
                                              color: Colors.teal[100],
                                            ),
                                            child: Text("Confirm"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit,
                              size: 18.0,
                            ),
                            Text("Edit"),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.0,),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(32.0),
            child: InkWell(
              onTap: () {
                FirebaseAuth.instance.signOut();
                // FirebaseUser user = FirebaseAuth.instance.currentUser;
                Navigator.pushNamed(
                  context,
                  '/',
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.red[300],
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: Center(
                  child: Text("Sign Out"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
