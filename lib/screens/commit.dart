import 'package:flutter/material.dart';
import 'package:smartcity_app/widgets/rounded-button.dart';

class UserCommit extends StatefulWidget {
  const UserCommit({Key? key}) : super(key: key);

  @override
  _UserCommitState createState() => _UserCommitState();
}

class _UserCommitState extends State<UserCommit> {
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(32),
          shrinkWrap: true,
          children: [
            Container(
              height: 200,
              width: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/mx.jpg'),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            SizedBox(height: 50),
            Text(
              "Write your opinion ....",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 2, color: Colors.grey),
              ),
              child: TextFormField(
                controller: textController,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: 'Write your opinion ....',
                  hintStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 40),
            RoundedButton(
                buttonName: 'Send',
                onTap: () {
                  print(textController.text);
                }),
          ],
        ),
      ),
    );
  }
}
