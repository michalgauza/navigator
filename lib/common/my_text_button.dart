import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  final Function onTap;
  final String text;
  final IconData iconData;
  final isActive;

  const MyTextButton({@required this.onTap, @required this.text, this.iconData, this.isActive = true});
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: (){
        if(isActive) onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 18, color: isActive ? Colors.white : Colors.white54),
            ),
            iconData != null ? Icon(iconData, color: isActive ? Colors.white : Colors.white54,) : SizedBox(),
          ],
        ),
      ),
      color: Colors.black,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: isActive ? Colors.white : Colors.white54, width: 2),
        borderRadius: BorderRadius.circular(18.0),
      ),
    );
  }
}
