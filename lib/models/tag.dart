class Tag {

  int? id;
  late String title;
  int lastused = DateTime.now().millisecondsSinceEpoch;
  bool selected = false;

  Tag(this.title);

  Tag.fromMap(Map map) {
    id = map["id"] as int?;
    title = map["title"] as String;
    lastused = map["lastused"];
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "title": title,
      "lastused":lastused,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }
}