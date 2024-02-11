import 'package:flutter/material.dart';
import 'package:todolog/widgets/select_tags_widget.dart';
import '../view_models/task_view_model.dart';

class TagsWidget extends StatelessWidget {
  TaskViewModel taskModel;

  TagsWidget(this.taskModel);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        addTags(context);
      },
      child: Row(
        children: [
          SizedBox(
            width: 15,
          ),
          Icon(Icons.tag_outlined),
          SizedBox(
            width: 30,
          ),
          Expanded(
              child: taskModel.selectedTags.length > 0
                  ? Wrap(
                      spacing: 2.0, // gap between adjacent chips
                      runSpacing: 1.0, // gap between lines
                      children: buildTagsChips(),
                    )
                  : Text("Добавить метку "))
        ],
      ),
    );
  }

  void addTags(context) async {
    final res = await showModalBottomSheet<void>(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(5.0),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return SelectTagsWidget(taskModel.taskModel);
        });
    taskModel.reloadTask();
  }

  List<Widget> buildTagsChips() {
    List<Widget> tags = [];
    taskModel.selectedTags.forEach((element) {
      tags.add(Chip(label: Text(element)));
    });
    return tags;
  }
}
