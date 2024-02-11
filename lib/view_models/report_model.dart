
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todolog/view_models/period_report_view_model.dart';
import 'package:todolog/view_models/tag_report_view_model.dart';
import 'package:todolog/view_models/task_report_view_model.dart';

import '../DatabaseHelper.dart';
import '../models/Task.dart';
import '../models/period.dart';
import '../utils.dart';

class ReportModel with ChangeNotifier {

  List<Period> periods = [];
  DateTime start =  Utils.startOfDay(DateTime.now()).subtract(Duration(days: 1));
  DateTime end =  Utils.endOfDay(DateTime.now());
  Map<int, Duration> mapDuration = {};
  Map<int, Task> mapTasks = {};
  Map<String,Duration> mapTgs = {};
  List<TaskReportViewModel> tasks = [];
  List<PeriodReportViewModel> periodsVM = [];
  List<TagReportViewModel> tags = [];

  ReportModel(){
    reloadTasks();
  }

  reloadTasks() async{
    periods = await DatabaseHelper().getPeriodsForInterval(start.millisecondsSinceEpoch,end.millisecondsSinceEpoch);

    for(int i = 0; i < periods.length; i++){
      Duration duration = Duration(milliseconds: (periods[i].finished-periods[i].started));
      if(mapDuration.containsKey(periods[i].taskid)){
        mapDuration[periods[i].taskid] = (mapDuration[periods[i].taskid]! + duration)!;
        periodsVM.add(PeriodReportViewModel(mapTasks[periods[i].taskid]!, periods[i]));
      }else{
        mapDuration[periods[i].taskid] = duration;
        Task task = (await DatabaseHelper().getTask(periods[i].taskid))!;
        mapTasks[periods[i].taskid] = task;
        periodsVM.add(PeriodReportViewModel(task, periods[i]));
      }
    }

    mapTasks.forEach((key, value) {
      tasks.add(TaskReportViewModel(value, mapDuration[key]!));
    });

    tasks.forEach((task) {
      task.task.tagsArray.forEach((tagName) {
        if(mapTgs.containsKey(tagName)){
          mapTgs[tagName] = mapTgs[tagName]!+task.duration;
        }else{
          mapTgs[tagName] = task.duration;
        }
      });
    });

    mapTgs.forEach((key, value) {
      tags.add(TagReportViewModel(value, key));
    });

    notifyListeners();
  }



  String get startPeriodString  {
    return start.day.toString()+"."+start.month.toString()+"."+start.year.toString();
  }

  String get endPeriodString  {
    return end.day.toString()+"."+end.month.toString()+"."+end.year.toString();
  }

  setDateTimeRange(DateTimeRange dateTimeRange){
    start = dateTimeRange.start;
    end = dateTimeRange.end;
    reloadTasks();
  }

}