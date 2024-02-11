import 'dart:async';

import 'package:flutter/material.dart';
import '../models/repeat_object.dart';
import '../view_models/app_model.dart';
import '../view_models/task_view_model.dart';
import '../screens/task_screen.dart';
import 'list_timer_widget.dart';

class TaskListItemWidget extends StatelessWidget {
  int index;
  AppModel appModel;
  TaskViewModel? taskViewModel;
  List<Widget> tags = [];

  TaskListItemWidget({super.key, required this.index, required this.appModel}) {
    taskViewModel = TaskViewModel(appModel.taskModels[index]);
    tags = buildTagsChips(taskViewModel!);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 10, bottom: 15, right: 10),
        child: Container(
            decoration: BoxDecoration(
                color: taskViewModel!.isStrated
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Colors.transparent,
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer, //Colors.transparent,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: SizedBox(
                height: 70,
                child: Row(
                  children: [
                    IconButton(
                      color: Theme.of(context).colorScheme.primary,
                      icon: taskViewModel!.done
                          ? const Icon(Icons.check_box)
                          : const Icon(Icons.check_box_outline_blank),
                      onPressed: () {
                        taskViewModel!.setDone();
                        appModel.updateView();
                        Timer(Duration(milliseconds: 500), () {
                          appModel.reloadTasks();
                        });
                      },
                    ),
                    Expanded(
                        child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onHorizontalDragEnd:(value){
                              if((value as DragEndDetails).velocity.pixelsPerSecond.distance>200){
                                print((value as DragEndDetails).velocity.pixelsPerSecond.distance.toString());
                                //skip the task
                                appModel.onSwipeTask(index);
                              }
                            },
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskScreen(
                                      TaskViewModel(appModel.taskModels[index])),
                                ),
                              );
                              appModel.updateView();
                              appModel.reloadTasks();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(taskViewModel!.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 16)),
                                Row(
                                  children: [
                                    ListTimerWidget(taskViewModel!),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    taskViewModel!.selectedTags.length > 0
                                        ? Row(children: [
                                      Icon(
                                        Icons.tag,
                                        size: 18,
                                      ), Text(
                                        taskViewModel!.selectedTags[0],
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],)
                                        : Text(""),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    taskViewModel!.repeatType==RepeatType.no_repeat?Text(""):Icon(
                                      Icons.repeat,
                                      size: 18,
                                    ),
                                    //taskModel!.repetObject.repetitionsPerDay>1?Text(taskModel!.repetObject.repetitionsPerDayDone.toString()+"/"+taskModel!.repetObject.repetitionsPerDay.toString()):Text(""),
                                  ],
                                )
                              ],
                            ))),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          color: Theme.of(context).colorScheme.primary,
                          icon: taskViewModel!.isStrated
                              ? const Icon(Icons.stop_rounded)
                              : const Icon(Icons.play_circle_outline_rounded),
                          onPressed: () async {
                            appModel.onStartTask(index);
                          },
                        )
                      ],
                    )
                  ],
                ))));
  }

  List<Widget> buildTagsChips(TaskViewModel taskViewModel) {
    List<Widget> tags = [];
    if (taskViewModel.isStrated) {
      tags.add(Padding(
          padding: EdgeInsets.only(left: 10),
          child: ListTimerWidget(taskViewModel!)));
    }
    tags.add(Expanded(child: Text("")));
    if (taskViewModel.selectedTags.length > 0) {
      if (taskViewModel.selectedTags.length > 1) {
        tags.add(Icon(Icons.more_horiz_outlined));
      }
      tags.add(Chip(
          labelPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          label: Text(
            taskViewModel.selectedTags[0],
            style: TextStyle(fontSize: 10),
          )));

      tags.add(SizedBox(width: 10));
    }
    return tags;
  }
}
