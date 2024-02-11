
import 'package:flutter/material.dart';

class TagListTile extends StatelessWidget{
  String text;
  bool value;
  Function(bool?) onComplete;

  TagListTile(this.text,this.value, this.onComplete);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.label_outline_rounded),
        trailing: Checkbox(value: value,
            onChanged:onComplete),
        title: Text( text), onTap: () {onComplete(!value);});
  }

}