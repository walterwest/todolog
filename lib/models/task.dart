
import 'package:todolog/utils.dart';

class Task {

  int? id;
  int parentid = 0;
  String title = "";
  int done = Utils.noDate.millisecondsSinceEpoch;
  int created = DateTime.now().millisecondsSinceEpoch;
  int duedate = Utils.noDate.millisecondsSinceEpoch;
  int sortid = 1;
  int started = Utils.noDate.millisecondsSinceEpoch;
  String tags = "";
  List<String> tagsArray = [];

  String? repeatjson;

  Task();

  Task.fromMap(Map map) {
    id = map["id"] as int?;
    title = map["title"] as String;
    done = map["done"];
    created = map["created"] as int;
    duedate = map["duedate"] as int;
    sortid = map["sortid"] as int;
    started = map["started"] as int;
    repeatjson = map["repeatjson"] as String?;
    parentid = map["parentid"] as int;
    tags = map["tags"] as String;
    tagsArray = tags.split(";");
    tagsArray.remove("");
  }

  Map<String, Object?> toMap() {
    tags = tagsArray.join(";");
    var map = <String, Object?>{
      "title": title,
      "done": done,
      "created":created,
      "sortid":sortid,
      "duedate":duedate,
      "started":started,
      "repeatjson":repeatjson,
      "parentid":parentid,
      "tags":tags
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }
}