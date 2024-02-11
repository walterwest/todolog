import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todolog/models/Task.dart';
import '../DatabaseHelper.dart';
import '../models/task_model.dart';
import '../utils.dart';

class AppModel with ChangeNotifier {

  List<TaskModel> taskModels = [];
  DateTime currentDate = DateTime.now();
  bool showCompletedTask = false;
  String get currentDateString => Utils.dateToString(currentDate);

  AppModel(){
    reloadTasks();
  }

  reloadTasks() async{
    taskModels = await DatabaseHelper().getTasks(currentDate,showCompletedTask);
    saveListOrder();
    updateView();
  }

  onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    var movedItem = taskModels.removeAt(oldItemIndex);
    taskModels.insert(newItemIndex, movedItem);
    saveListOrder();
    updateView();
  }

  saveListOrder(){
    for (final mapEntry in taskModels.asMap().entries) {
      final key = mapEntry.key;
      final taskModel = mapEntry.value;
      taskModel.setIndex(key+2);
    }
  }

  void setCurrentDate(DateTime dateTime){
    currentDate = DateTime(dateTime.year,dateTime.month,dateTime.day);
    reloadTasks();
  }

  Future<void> updateTaskInDb(Task task)async{
    await DatabaseHelper().update(task);
  }

  onTapLeading(){
    showCompletedTask = !showCompletedTask;
    reloadTasks();
  }

  updateView(){
    notifyListeners();
  }

  onStartTask(int index)async{
    if(taskModels[index].isStrated){
      await taskModels[index].stop();
    }else{
     for (var value in taskModels) {
       if (value.isStrated){
         await value.stop();
       }
     }

     await taskModels[index].start();
     var movedItem = taskModels.removeAt(index);
     taskModels.insert(0, movedItem);
     saveListOrder();
    }

    notifyListeners();
  }

  onSwipeTask(int index)async{
      await taskModels[index].skip();
      reloadTasks();
  }

}