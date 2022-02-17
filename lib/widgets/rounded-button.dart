import 'package:flutter/material.dart';
import 'package:smartcity_app/pallete.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({Key? key, required this.buttonName, required this.onTap})
      : super(key: key);
  final VoidCallback onTap;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.08,
      width: size.width * 0.85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: kBlue,
      ),
      child: FlatButton(
        onPressed: onTap,
        child: Text(
          buttonName,
          style: kBodyText.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
