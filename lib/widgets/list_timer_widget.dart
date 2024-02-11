

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todolog/view_models/task_view_model.dart';

class ListTimerWidget extends StatefulWidget {

  TaskViewModel taskModel;


  ListTimerWidget(this.taskModel,{ super.key});

  @override
  State<ListTimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<ListTimerWidget> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {

      });
    });
  }

  @override
  void dispose(){
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.taskModel.durationString(),style:widget.taskModel.isStrated?TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Theme.of(context).colorScheme.primary):TextStyle());
  }
}