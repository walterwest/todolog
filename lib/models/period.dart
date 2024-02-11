class Period {

  int? id;
  late int taskid ;
  int started = DateTime.now().millisecondsSinceEpoch;
  int finished = 0;

  Period(this.taskid);

  Period.fromMap(Map map) {
    id = map["id"] as int?;
    taskid = map["taskid"] as int;
    started = map["started"];
    finished = map["finished"] as int;
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "taskid": taskid,
      "started": started,
      "finished":finished
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }
}