import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolog/view_models/task_view_model.dart';
import 'package:todolog/screens/task_screen.dart';
import '../DatabaseHelper.dart';
import '../models/Task.dart';
import '../models/task_model.dart';
import '../view_models/app_model.dart';
import '../widgets/app_drawer.dart';
import '../widgets/tasks_list_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      AppModel appModel = context.watch<AppModel>();
      return Scaffold(
        drawer: MyDrawer(),
        /*appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Center(
              child: TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () async {
              DateTime? selected = await showDatePicker(
                context: context,
                initialDate: appModel.currentDate,
                firstDate: DateTime(2010),
                lastDate: DateTime(2025),
                /*  builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Colors.amberAccent, // <-- SEE HERE
                      onPrimary: Colors.redAccent, // <-- SEE HERE
                      onSurface: Colors.blueAccent, // <-- SEE HERE
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        primary: Colors.red, // button text color
                      ),
                    ),
                  ),
                  child: child!,
                );
              },*/
              );
              if (selected != null) {
                appModel.setCurrentDate(selected);
              }
            },
            child: Text(appModel.currentDateString),
          )),
          leading: IconButton(
            icon: Icon(appModel.showCompletedTask
                ? Icons.beenhere
                : Icons.beenhere_outlined),
            onPressed: () {
              appModel.onTapLeading();
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          ],
        ),*/
        body: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
                child: Row(
                  children: [
                    TextButton(
                        onPressed: () async {
                          DateTime? selected = await showDatePicker(
                            context: context,
                            initialDate: appModel.currentDate,
                            firstDate: DateTime(2010),
                            lastDate: DateTime(2025),
                          );
                          if (selected != null) {
                            appModel.setCurrentDate(selected);
                          }
                        },
                        child: Text(
                          "Задачи " + appModel.currentDateString,
                          style: TextStyle(fontSize: 30),
                        )),
                    Expanded(child:Text("")),
                    IconButton(
                      icon: Icon(appModel.showCompletedTask
                          ? Icons.beenhere
                          : Icons.beenhere_outlined),
                      onPressed: () {
                        appModel.onTapLeading();
                      },
                    )
                  ],
                )),
            Expanded(
                // wrap in Expanded
                child: TasksListWidget(appModel))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Task task = Task();
            task.id = await DatabaseHelper().insert(task);
            TaskModel taskModel = TaskModel(task, []);
            taskModel.setDueDate(appModel.currentDate.millisecondsSinceEpoch);
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskScreen(TaskViewModel(taskModel)),
              ),
            );
            appModel.reloadTasks();
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
  }
}
