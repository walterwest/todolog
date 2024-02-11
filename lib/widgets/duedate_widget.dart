import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todolog/view_models/task_view_model.dart';
import '../screens/task_screen.dart';
import '../utils.dart';

class DueDateWidget extends StatelessWidget {
  TaskViewModel taskViewModel;

  DueDateWidget(this.taskViewModel);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<DueDateItem>(
      offset: Offset(1, 50),
      child: !taskViewModel.dueDate.isNotEmpty
          ? ListTile(
              leading: Icon(Icons.calendar_month_outlined),
              title: Text('Задать дату выполнения'),
            )
          : Row(
              children: [
                SizedBox(width: 15),
                Icon(Icons.today_outlined),
                SizedBox(width: 30),
                Expanded(child: Text("Срок: " + taskViewModel.dueDate)),
                IconButton(
                    onPressed: () {
                      taskViewModel.setDate(Utils.noDate);
                    },
                    icon: Icon(Icons.close))
              ],
            ),
      onSelected: (DueDateItem item) {
        switch (item) {
          case DueDateItem.today:
            taskViewModel.setDate(DateTime.now());
          case DueDateItem.tomorrow:
            taskViewModel.setDate(DateTime.now().add(Duration(days: 1)));
          case DueDateItem.weekLater:
            taskViewModel.setDate(DateTime.now().add(Duration(days: 7)));
          case DueDateItem.chooseDate:
            chooseDueDate(context);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<DueDateItem>>[
        const PopupMenuItem<DueDateItem>(
            value: DueDateItem.today,
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined),
                SizedBox(width: 30),
                Text('Сегодня')
              ],
            )),
        const PopupMenuItem<DueDateItem>(
            value: DueDateItem.tomorrow,
            child: Row(
              children: [
                Icon(Icons.today_outlined),
                SizedBox(width: 30),
                Text('Завтра')
              ],
            )),
        const PopupMenuItem<DueDateItem>(
            value: DueDateItem.weekLater,
            child: Row(
              children: [
                Icon(Icons.date_range_outlined),
                SizedBox(width: 30),
                Text('Через неделю')
              ],
            )),
        const PopupMenuItem<DueDateItem>(
            value: DueDateItem.chooseDate,
            child: Row(
              children: [
                Icon(Icons.edit_calendar_outlined),
                SizedBox(width: 30),
                Text('Выбрать дату')
              ],
            )),
      ],
    );
  }

  chooseDueDate(BuildContext context) async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null) {
      taskViewModel.setDate(selected);
    }
  }
}
