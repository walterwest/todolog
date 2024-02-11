import 'package:flutter/material.dart';
import 'package:todolog/models/task_model.dart';
import 'package:todolog/view_models/repeat_view_model.dart';
import '../models/repeat_object.dart';
import '../models/tag.dart';
import '../utils.dart';

class TaskViewModel with ChangeNotifier {

  TaskModel taskModel;
  String get dueDate => taskModel.dueDate;
  List<String> get selectedTags => taskModel.tags;
  int get id => taskModel.task.id!;
  String get title => taskModel.title;
  bool get done => taskModel.done;
  bool get isStrated => taskModel.isStrated;
  Repeat  get repetObject => taskModel.repetObject;
  RepeatType get repeatType => repetObject.repeatType;
  int cursorPosition = 0;

  setRepeat(Repeat repeat){
    taskModel.setRepeat(repeat);
    notifyListeners();
  }

  setCursorPosition(int cursorPos){
    cursorPosition = cursorPos;
  }

  TaskViewModel(this.taskModel);

  reloadTask()async{
    //await taskModel.;
    notifyListeners();
  }

  setTitle(String text) {
    taskModel.setTitle(text);
  }

  setIndex(index){
    taskModel.setIndex(index);
  }

  void setDate(DateTime date){
    DateTime startOfDay = DateTime(date.year,date.month,date.day);
    int duedate = startOfDay.millisecondsSinceEpoch;
    taskModel.setDueDate(duedate);
    notifyListeners();
  }

  setDone()async{
    if(taskModel.done){
     taskModel.unDone();
    }else{
      await taskModel.setDone();
    }
    notifyListeners();
  }

  Future<void> deleteTask()async{
    await taskModel.delete();
  }

  String durationString(){
    return Utils.formatDuration(taskModel.duration());
  }

  onTapTimer()async{
      if(taskModel.isStrated){
        await taskModel.stop();
      }else{
        await taskModel.start();
      }
      notifyListeners();
  }
  bool isTagSeted(){
    if(selectedTags.length>0){
      return true;
    }
    return false;
  }

  onSkipTap(){
    taskModel.skip();
    notifyListeners();
    //показываем алерт или тост

  }

}