import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartcity_app/main.dart';
import 'package:smartcity_app/pallete.dart';
import 'package:smartcity_app/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailCtrl = TextEditingController();

  TextEditingController passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(
          image: 'assets/images/smart.jpg',
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Flexible(
                child: Center(
                  child: Text(
                    'SmartCity',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextInputField(
                    icon: FontAwesomeIcons.envelope,
                    hint: 'Email',
                    controller: emailCtrl,
                    inputType: TextInputType.emailAddress,
                    inputAction: TextInputAction.next,
                  ),
                  PasswordInput(
                    icon: FontAwesomeIcons.lock,
                    hint: 'Password',
                    controller: passwordCtrl,
                    inputAction: TextInputAction.done,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, 'ForgotPassword'),
                    child: Text(
                      'Forgot Password',
                      style: kBodyText,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  RoundedButton(
                    buttonName: 'Login',
                    onTap: _onLogin,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'CreateNewAccount'),
                child: Container(
                  child: Text(
                    'Create New Account',
                    style: kBodyText,
                  ),
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(width: 1, color: kWhite))),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        )
      ],
    );
  }

  void _onLogin() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text,
        password: passwordCtrl.text,
      );
      print('user login successfully: ID: ${userCredential.user!.uid}');
      _getUserDataFromFireStore();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        _showAlert('الرقم السرى الذى قمت بادخاله غير صحيح');
      }
    }
  }

  _showAlert(String msg) {
    SnackBar snackbar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void _getUserDataFromFireStore() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.get().then((value) {
       userData = value.docs
          .firstWhere((element) => element['email'] == emailCtrl.text);
      print('UserData: $userData ');
     
      if (userData.get('type') == 'user') {
        //TODO: navigate to user screens
        print('this is a default User');
        Navigator.pushNamedAndRemoveUntil(context, '/worker', (r) => false);
      } else {
        //TODO: navigate to employee screens
        print('this is an Employee');
        Navigator.pushNamedAndRemoveUntil(context, 'Map', (r) => false);
      }
    }).catchError((error) => print("Failed to add user: $error"));
  }
}
