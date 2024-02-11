
import 'dart:convert';

import 'package:todolog/models/period.dart';
import 'package:todolog/models/repeat_object.dart';
import '../DatabaseHelper.dart';
import '../utils.dart';
import '../models/Task.dart';

class TaskModel{

  Task task;
  //List<String> _tags = [];
  List<String> get tags => task.tagsArray;
  List<Period> periods;
  late Repeat repetObject;
  String get title => task.title;
  String get dueDate =>task.duedate>Utils.noDate.millisecondsSinceEpoch? Utils.dateToString(DateTime.fromMillisecondsSinceEpoch(task.duedate)):"";
  bool get done => DateTime.fromMillisecondsSinceEpoch(task.done).isAfter(Utils.noDate);
  bool get isStrated => task.started > Utils.noDate.millisecondsSinceEpoch;

  TaskModel(this.task,this.periods){
    //_tags = task.tags.split(";");
    //_tags.remove("");
    if(task.repeatjson!=null && task.repeatjson!.isNotEmpty){
      final repeatMap = jsonDecode(task.repeatjson!) as Map<String, dynamic>;
      repetObject = Repeat.fromJson(repeatMap);
    }
    else{
      repetObject = Repeat();
    }
  }

  addTag(String tag){
    task.tagsArray.add(tag);
    //task.tags = _tags.join(";");
    _saveTaskToDb();
  }

  removeTag(String tag){
    task.tagsArray.remove(tag);
    //task.tags = _tags.join(";");
    _saveTaskToDb();
  }

  setRepeat(Repeat repeat){
    repetObject = repeat;
    task.repeatjson = repetObject.getJson();
    _saveTaskToDb();
    return task;
  }

  _loadPeriods()async{
    if(task.id!=null){
      periods = [];
      periods = await DatabaseHelper().getPeriods(task.id!);
    }
  }

  Future<void> _saveTaskToDb()async{
    if(task.id!=null){
      await DatabaseHelper().update(task);
    }else{
      task.id = await DatabaseHelper().insert(task);
    }
  }

  void setTitle(text) {
    task.title = text;
    _saveTaskToDb();
  }

  Future<void> setIndex(index) async{
    if(isStrated){
      task.sortid = 0;
    }
    else{
      task.sortid = index;
    }
    await _saveTaskToDb();
  }

  void setDueDate(int date){
    task.duedate = date;
    _saveTaskToDb();
  }

  setDone()async{
    if(isStrated){
      await stop();
    }
    if(task.duedate<=Utils.today.millisecondsSinceEpoch){
      task.done = DateTime.now().millisecondsSinceEpoch;//Utils.today.millisecondsSinceEpoch;
      await _saveTaskToDb();
      if(repetObject.isRepeatable()){
        Task? childTask = await DatabaseHelper().getChildTask(task.id!);
        if(childTask!=null){
          //обновить срок у задачи?
        }else{
          Task childTask = Task();
          childTask.title = task.title;
          childTask.duedate = repetObject.getNextDueDate();
          childTask.repeatjson = repetObject.getJson();
          childTask.parentid = task.id!;
          childTask.tags = task.tags;
          childTask.tagsArray = task.tagsArray;
          childTask.id = await DatabaseHelper().insert(childTask);
        }
      }
    }else{
      // показать алерт с переносом задачи на сегодня
    }
  }

  skip()async{
    if(isStrated){
      await stop();
    }
    task.duedate = repetObject.getNextDueDate();
    task.repeatjson = repetObject.getJson();
    await _saveTaskToDb();
  }

  unDone() {
    task.done = Utils.noDate.millisecondsSinceEpoch;
    _saveTaskToDb();
  }

  Future<void> delete()async{
    await DatabaseHelper().deleteTask(task.id!);
  }

  start() async{
    await DatabaseHelper().stopRuningTask();
    task.started = DateTime.now().millisecondsSinceEpoch;
    task.sortid = 0;
    await _saveTaskToDb();
  }

  stop() async{
    await DatabaseHelper().addPeriodForTask(task);
    task.started = Utils.noDate.millisecondsSinceEpoch;
    await _saveTaskToDb();
    await _loadPeriods();
  }

  Duration  duration(){
    int durationMls = 0;
    periods.forEach((period) {
      durationMls += period.finished-period.started;
    });
    if(isStrated){
      durationMls += DateTime.now().millisecondsSinceEpoch-task.started;
    }
    return Duration(milliseconds: durationMls);
  }

}