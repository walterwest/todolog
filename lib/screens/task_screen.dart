import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolog/screens/repeat_screen.dart';
import 'package:todolog/widgets/duedate_widget.dart';
import 'package:todolog/widgets/repeat_task_widget.dart';
import '../view_models/task_view_model.dart';
import '../widgets/tags_widget.dart';
import '../widgets/timer_widget.dart';

enum DueDateItem { today, tomorrow, weekLater, chooseDate }

class TaskScreen extends StatelessWidget {
  TaskViewModel task;
  TaskScreen(this.task);

  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => task),
      ],
      child: Builder(
        builder: (BuildContext context) {
          TaskViewModel taskModel = context.watch<TaskViewModel>();
          TextEditingController _titleController = new TextEditingController();
          _titleController.text = taskModel.title;
          _titleController.selection = TextSelection.fromPosition(
              TextPosition(offset: taskModel.cursorPosition));
          return Scaffold(
              bottomNavigationBar: BottomAppBar(
                //color: Colors.blue,
                child: IconTheme(
                  data: IconThemeData(
                      color: Theme.of(context).colorScheme.primary),
                  child: Row(
                      mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () async {
                          Navigator.pop(context, taskModel);
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete_outline_outlined),
                        onPressed: () async {
                          await taskModel.deleteTask();
                          Navigator.pop(context, taskModel);
                        },
                      ),
                      //const Spacer(),
                      IconButton(
                        //color: Theme.of(context).colorScheme.primary,
                        icon: taskModel!.isStrated
                            ? const Icon(Icons.stop_rounded,size: 40,)
                            : const Icon(Icons.play_circle_outline_rounded,size: 40),
                        onPressed: () async{
                          task.onTapTimer();
                        },
                      ),
                      IconButton(
                        icon:  const Icon(Icons.skip_next_rounded),
                        onPressed: () {
                          task.onSkipTap();
                        },
                      ),
                      IconButton(
                        icon: taskModel.done
                            ? const Icon(Icons.check_box)
                            : const Icon(Icons.check_box_outline_blank),
                        onPressed: () {
                          taskModel.setDone();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              body:
              Column(children: [
              Expanded(child:  ListView(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SizedBox(
                          width: deviceData.size.width - 80,
                          child: TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.multiline,
                            minLines: 1, // <-- SEE HERE
                            maxLines: null, // <-- SEE HERE
                            autofocus: _titleController.text.isEmpty,
                            onChanged: (text) {
                              taskModel.setTitle(text);
                            },
                            onTap: () {
                              taskModel.setCursorPosition(
                                  _titleController.selection.base.offset);
                            },
                          ))),
                  SizedBox(height: 20),
                  DueDateWidget(taskModel),
                  SizedBox(
                    height: 20,
                  ),
                  TagsWidget(taskModel),
                  SizedBox(
                    height: 20,
                  ),
                  RepeatTaskWidget(taskModel.repetObject,()async{
                    final res = await Navigator.push(context, MaterialPageRoute(builder: (context) => RepeatScreen(task.repetObject),),);
                    task.setRepeat(res);}),
                ],
              )),
                TimerWidget(taskModel),
          ],));
        },
      ),
    );
  }
}
