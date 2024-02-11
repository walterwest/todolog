
import 'package:flutter/material.dart';

class RepeatListItem extends StatelessWidget{
  bool value;
  Function(bool?) onComplete;

  RepeatListItem(this.value, this.onComplete);

  @override
  Widget build(BuildContext context) {
    return Checkbox(value: value,
      onChanged: onComplete,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),);
  }

}