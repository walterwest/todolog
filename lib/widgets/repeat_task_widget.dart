import 'package:flutter/material.dart';
import '../models/repeat_object.dart';

class RepeatTaskWidget extends StatelessWidget {
  Repeat  repetObject;
  Function() onTap;
  RepeatTaskWidget(this.repetObject,this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
            width: 15,
          ),
          Icon(Icons.repeat_outlined),
          SizedBox(
            width: 30,
          ),
          Expanded(
              child:  Text(repetObject.repeatString))
        ],
      ),
    );
  }

}
