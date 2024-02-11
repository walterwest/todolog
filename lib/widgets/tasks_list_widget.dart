import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:todolog/widgets/task_list_item_widget.dart';
import '../view_models/app_model.dart';

class TasksListWidget extends StatelessWidget {
  AppModel appModel;

  TasksListWidget(this.appModel);

  @override
  Widget build(BuildContext context) {
    List<DragAndDropList> contents = [];
    List<DragAndDropItem> todayElements = [];
    appModel.taskModels.asMap().forEach((index, element) {
      todayElements.add(DragAndDropItem(child: TaskListItemWidget(key: UniqueKey(),index:index,appModel:appModel )));
    });
    contents.add(DragAndDropList(canDrag: false, children: todayElements));
    return DragAndDropLists(

      children: contents,
      onItemReorder: appModel.onItemReorder,
      onListReorder: (int oldListIndex, int newListIndex) {},
    );
  }
}
