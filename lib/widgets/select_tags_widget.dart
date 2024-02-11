import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolog/models/task_model.dart';
import 'package:todolog/widgets/tag_list_tile.dart';

import '../view_models/tags_view_model.dart';

class SelectTagsWidget extends StatelessWidget {
  TaskModel taskModel;

  SelectTagsWidget(this.taskModel);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TagsViewModel(taskModel)),
      ],
      child: Builder(
        builder: (BuildContext context) {
          ScrollController _scrollController = ScrollController();

          TagsViewModel tagsModel = context.watch<TagsViewModel>();
          TextEditingController _titleController = TextEditingController();
          _titleController.text = tagsModel.currentInput;
          _titleController.selection = TextSelection.fromPosition(
              TextPosition(offset: _titleController.text.length));
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        "Метки",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close_rounded))
                    ],
                  ),
                ),
                //SizedBox( height: 10),
                Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Создать или найти метку',
                      ),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 1,
                      autofocus: true,
                      onChanged: (text) {
                        tagsModel.onTextInput(text);
                      },
                    )),
                Divider(),
                newTagTile(tagsModel),
                Expanded(
                    child: ListView.builder(
                     controller: _scrollController,
                  itemCount: tagsModel.tags.length,
                  itemBuilder: (context, index) {
                    return TagListTile(tagsModel.tags[index].title,
                        tagsModel.tags[index].selected, (p0) async{
                      await tagsModel.onTap(tagsModel.tags[index]);
                      _scrollController.jumpTo(10);
                    }
                        //Text(tagsModel.tags[index].title),
                        );
                  },
                ))
              ],
            ),
          );
        },
      ),
    );
  }

  Widget newTagTile(TagsViewModel tagsModel) {
    return (tagsModel.currentInput.length > 0 && !tagsModel.hasTag)
        ? TagListTile('Добавить "' + tagsModel.currentInput + '"', false, (p0) {
            tagsModel.addTag();
          })
        : SizedBox();
  }
}
