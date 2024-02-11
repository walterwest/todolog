import 'package:flutter/material.dart';
import 'package:todolog/models/period.dart';
import 'package:todolog/models/task_model.dart';
import 'package:todolog/view_models/repeat_view_model.dart';
import '../models/Task.dart';
import '../models/repeat_object.dart';
import '../models/tag.dart';
import '../utils.dart';

class PeriodReportViewModel with ChangeNotifier {

  Task task;
  Period period;

  PeriodReportViewModel(this.task, this.period);

}