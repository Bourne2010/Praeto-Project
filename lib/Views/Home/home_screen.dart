import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

var log = Logger();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  late String username = 'guest';
  late int balance = 0;
  final TextEditingController payMoneyController = TextEditingController();
  final TextEditingController payUserController = TextEditingController();
  final TextEditingController topUpController = TextEditingController();

  Future<void> getData() async {
    try{
    // log.d(currentUser?.email);
    final QuerySnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance.collection('Accounts').where('email', isEqualTo: currentUser?.email).get();
    DocumentSnapshot Document = documentSnapshot.docs[0];
    Map<String, dynamic> homeData = Document.data() as Map<String, dynamic>;
    // log.d(homeData);
    // log.d(homeData[0]);
    setState(() {
    username = homeData['username'];
    balance = homeData['balance'];
    });
    } catch(e) {
      log.d(e);
    }
  }

  onPay(String usernamePay, int balancePay) async {
    try{
      final balancePayed2 = balance - balancePay;
      if(balancePayed2 < 0 || balancePay < 0){
        Fluttertoast.showToast(
            msg: "Invalid Amount",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      }

      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('Accounts').where('username', isEqualTo: usernamePay).get();
      final balanceAnother =  querySnapshot.docs[0].data()['balance'] + balancePay;
      await querySnapshot.docs.first.reference.update({
        'balance':balanceAnother,
      });

      
      final QuerySnapshot<Map<String, dynamic>> querySnapshot2 = await FirebaseFirestore.instance.collection('Accounts').where('email', isEqualTo: currentUser?.email).get();
      await querySnapshot2.docs.first.reference.update({
        'balance':balancePayed2,
      });
      setState(() {
        balance = balancePayed2;
      });
      Fluttertoast.showToast(
            msg: "Successfuly paid",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
    }catch(e){
      log.d(e);
      Fluttertoast.showToast(
            msg: "Pay Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
    }
  }

  onTopUp(int topUp) async {
    topUp = balance + topUp;
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('Accounts').where('email', isEqualTo: currentUser?.email).get();
    await querySnapshot.docs.first.reference.update({
        'balance':topUp,
      });

    setState(() {
      balance = topUp;
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
      // appBar: AppBar(),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 22, 170, 156),
            ),
            // padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.0,vertical: 32.0),
                        child: Text(
                          "Your-Wallet",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.indigo[900],
                            fontFamily: 'DancingScript',
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.0,vertical: 32.0),
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // color: Colors.black,
                                border: Border.all(
                                  color: Colors.black,
                                )),
                            child: Icon(
                              Icons.person,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Text(
                        "Hello, ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        username,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Your balance :",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Rp ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                              ),
                            ),
                            Text(
                              balance.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 16.0),
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  // height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              getData();
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Pay'),
                                    content: Container(
                                      height: 100.0,
                                      child: Column(
                                        children: [
                                          TextField(
                                            controller: payMoneyController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                hintText: "Input amount of money"),
                                          ),
                                          TextField(
                                            controller: payUserController,
                                            // keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                hintText: "Input user"),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      Center(
                                        child: InkWell(
                                          onTap: () {
                                            onPay(payUserController.text, int.tryParse(payMoneyController.text) ?? 0 );
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
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                      color: Colors.teal[50],
                                      border: Border.all(width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  child: Icon(
                                    Icons.arrow_upward_rounded,
                                  ),
                                ),
                                Text(
                                  "Pay",
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Top Up'),
                                    content: TextField(
                                      controller: topUpController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          hintText: "Input top up amount"),
                                    ),
                                    actions: [
                                      Center(
                                        child: InkWell(
                                          onTap: () {
                                            onTopUp(int.tryParse(topUpController.text) ?? 0);
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
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                      color: Colors.teal[50],
                                      border: Border.all(width: 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  child: Icon(
                                    Icons.add,
                                  ),
                                ),
                                Text(
                                  "Top-up",
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
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
