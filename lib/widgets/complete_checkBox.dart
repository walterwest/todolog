
import 'package:flutter/material.dart';

class CompleteCheckBox extends StatelessWidget{
  bool value;
  Function(bool?) onComplete;

  CompleteCheckBox(this.value, this.onComplete);

  @override
  Widget build(BuildContext context) {
    return
      Checkbox(value: value, onChanged: onComplete,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      );

  }

}