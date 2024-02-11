
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todolog/models/tag.dart';
import 'package:todolog/models/task_model.dart';
import '../DatabaseHelper.dart';

class TagsViewModel with ChangeNotifier {

  List<Tag> tags = [];
  String currentInput = "";
  bool hasTag = false;
  TaskModel taskModel;

  TagsViewModel(this.taskModel){
    init();
  }



  init()async{
    await reloadTags("");
    notifyListeners();
  }

  reloadTags(String filter) async{
    tags = [];
    tags = await DatabaseHelper().getTags(filter,taskModel.task.id!);
    tags.forEach((element) {
      if(taskModel.tags.indexOf(element.title)>=0){
        element.selected = true;
      }
    });
    tags.sort( (a, b) => (a.selected == b.selected ? 0 : (b.selected ? 1 : -1)));
  }

  onTextInput(String text)async{
    currentInput = text;
    await reloadTags(text);
    hasTag = false;
    tags.forEach((element) {
      if(element.title==text){
        hasTag = true;
      }
    });
    notifyListeners();
  }

  addTag()async{
    Tag tag = new Tag(currentInput);
    tag.id = await DatabaseHelper().insertTag(tag);
    taskModel.addTag(tag.title);
    //selectedTags.add(tag.title);
    //await DatabaseHelper().selectTag(tag.id!,taskID);
    currentInput = "";
    //tags.add(tag);
    await reloadTags("");
    notifyListeners();
  }

  _selectTag(Tag tag)async{
    currentInput = "";
    taskModel.addTag(tag.title);
    await reloadTags("");
    notifyListeners();
  }

  _unSelectTag(Tag tag)async{
    taskModel.removeTag(tag.title);
    await reloadTags("");
    notifyListeners();
  }

  onTap (Tag tag)async {
    if(tag.selected){
      await _unSelectTag(tag);
    }else{
      await _selectTag(tag);
    }
  }

}