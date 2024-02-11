import 'package:flutter/material.dart';
import 'package:todolog/models/period.dart';
import 'package:todolog/models/task_model.dart';
import 'package:todolog/view_models/repeat_view_model.dart';
import '../models/Task.dart';
import '../models/repeat_object.dart';
import '../models/tag.dart';
import '../utils.dart';

class TagReportViewModel with ChangeNotifier {

  Duration duration;
  String tag;

  TagReportViewModel(this.duration, this.tag);

}