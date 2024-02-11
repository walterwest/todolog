import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todolog/models/period.dart';
import 'package:todolog/utils.dart';
import 'models/Task.dart';
import 'models/tag.dart';
import 'models/task_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  final String tableTodo = 'todos';
  final String tableTags = 'tags';
  final String tablePeriods = 'periods';
  static Database? _db ;

  Future<Database> get db async {
    if (_db != null) {
      return _db!!;
    }
    _db = await initDb();
    return _db!!;
  }

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todolog.db');
    var ourDb = await openDatabase(path, version: 8, onCreate: _onCreate,onUpgrade:_onUpgrade);
    return ourDb;
  }

  DatabaseHelper.internal();

  void _onCreate(Database db, int version) async {
    var batch = db.batch();
    _createTableTaskV8(batch);
    _createTableTagV3(batch);
    _createTablePeriodsV3(batch);
    await batch.commit();
  }

  void _onUpgrade (Database db, int oldVersion, int newVersion) async {
    var batch = db.batch();
    if (oldVersion == 7) {
       _updateTableTaskV7toV8(batch);
     }
    await batch.commit();
  }

  void _createTableTaskV8(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS $tableTodo');
    batch.execute('''
            create table $tableTodo ( 
            id integer primary key autoincrement, 
            title text not null,
            done integer not null,
            tags text not null,
            created integer not null,
            sortid integer not null,
            started integer not null,
            duedate integer not null,
            repeatjson text,
            parentid integer not null)
          ''');
  }

  void _updateTableTaskV7toV8(Batch batch) {
    batch.execute('ALTER TABLE $tableTodo ADD tags text not null DEFAULT ""');
  }

  void _createTableTagV3(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS $tableTags');
    batch.execute('''
            create table $tableTags ( 
            id integer primary key autoincrement, 
            title text not null,
            lastused integer not null
            )''');
  }

  void _createTablePeriodsV3(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS $tablePeriods');
    batch.execute('''
            create table $tablePeriods ( 
            id integer primary key autoincrement, 
            taskid integer not null,
            started integer not null,
            finished integer not null
         )''');
  }

  Future<Task?> getTask(int id) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableTodo,
        columns: ['*'],
        where: 'id = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first);
    }
    return null;
  }

  Future<int?> insert(Task todo) async {
    var dbClient = await db;
    var todoMap = todo.toMap();
    todo.id = await dbClient.insert(tableTodo, todoMap);
    return todo.id;
  }

  Future<int?> insertTag(Tag tag) async {
    var dbClient = await db;
    tag.id = await dbClient.insert(tableTags, tag.toMap());
    return tag.id;
  }

  Future<Task?> getChildTask(int parentid) async {
    String query = 'SELECT * FROM '+tableTodo+' where parentid ='+parentid.toString()+' ORDER BY done ASC, sortid ASC';
    var dbClient = await db;
    List<Map> list =  await dbClient.rawQuery( query );
    if (list.isNotEmpty) {
      return Task.fromMap(list.first);
    }
    return null;
  }

  Future<Tag?> getTag(int id) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableTags,
        columns: ['id','title','lastused'],
        where: 'id = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Tag.fromMap(maps.first);
    }
    return null;
  }

  Future<List<TaskModel>> getTasks(DateTime dateTime, bool showCompleted) async {
    await deleteEmptyTask();
    String where = '';
    if(Utils.isItToday(dateTime)){
      where = '(duedate ==' + Utils.noDate.millisecondsSinceEpoch.toString() + ' AND done ==' + Utils.noDate.millisecondsSinceEpoch.toString() + ') '
          'OR (done ==' + Utils.noDate.millisecondsSinceEpoch.toString() + ' AND duedate <=' + Utils.endOfDay(dateTime).millisecondsSinceEpoch.toString() + ')';
      if(showCompleted) {
        where = where +' OR (done >=' + Utils.startOfDay(dateTime).millisecondsSinceEpoch.toString() + ' AND done <=' + Utils.endOfDay(dateTime).millisecondsSinceEpoch.toString() + ' ) ';
      }
    }else if(dateTime.isBefore(Utils.today)){//past
      where = '(done >=' + Utils.startOfDay(dateTime).millisecondsSinceEpoch.toString() + ' AND done <=' + Utils.endOfDay(dateTime).millisecondsSinceEpoch.toString() + ' ) ';
    }else{//future
      where = '(duedate >=' + Utils.startOfDay(dateTime).millisecondsSinceEpoch.toString() + ' AND duedate <=' + Utils.endOfDay(dateTime).millisecondsSinceEpoch.toString() + ' ) ';
    }
    String query = 'SELECT * FROM '+tableTodo+' where '+where+' ORDER BY done ASC, sortid ASC';
    var dbClient = await db;
    List<Map> list =  await dbClient.rawQuery( query );
    List<TaskModel> tasks = [];
    for(Map map in list) {
    //list.forEach((Map map)async{
      Task task = Task.fromMap(map);
      //List<Tag> selectedTags = [];
      //selectedTags = await DatabaseHelper().getSelectedTags(task.id!);
      List<Period> periods = [];
      periods = await DatabaseHelper().getPeriods(task.id!);
      TaskModel taskModel = TaskModel(task, periods);
      tasks.add(taskModel);
    }
    return tasks;
  }

  Future<int> deleteTask(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableTodo, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteEmptyTask() async {
    var dbClient = await db;
    return await dbClient.delete(tableTodo, where: 'title = ?', whereArgs: [""]);
  }

  Future<int> update(Task todo) async {
    var dbClient = await db;
    return await dbClient.update(tableTodo, todo.toMap(), where: 'id = ?', whereArgs: [todo.id!]);
  }

  Future<List<Tag>> getTags(String startWith, int taskID) async {
    String where = '';
    if(startWith.isNotEmpty){
      where = ' where (title LIKE "'+startWith+'%" )';
    }else{
      where = '';
    }
    String query = 'SELECT * FROM '+tableTags+where+' ORDER BY lastused DESC';
    var dbClient = await db;
    List<Map> list =  await dbClient.rawQuery( query );
    List<Tag> tags = [];
    list.forEach((Map map){
      Tag tag = Tag.fromMap(map);
      tags.add(tag);
    });
   // tags = await markSelectedTags(taskID,tags);
    return tags;
  }

  Future<List<Period>> getPeriods(int taskId) async {
    List<Period> periods = [];
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tablePeriods, columns: ['id', 'taskid','started','finished'], where: 'taskid = ?', whereArgs: [taskId],orderBy: "id DESC",);
    maps.forEach((Map map)async{
      Period period = Period.fromMap(map);
      periods.add(period);
    });
    return periods;
  }

  Future<List<Period>> getPeriodsForInterval(int start, int end) async {
    List<Period> periods = [];
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tablePeriods, columns: ['id', 'taskid','started','finished'], where: 'finished >= ? AND finished <= ?', whereArgs: [start,end],orderBy: "id DESC",);
    maps.forEach((Map map)async{
      Period period = Period.fromMap(map);
      periods.add(period);
    });
    return periods;
  }

  Future<int?> insertPeriod(int taskId, int started, int finished) async {
    var dbClient = await db;
    Period period = new Period(taskId);
    period.started = started;
    period.finished = finished;
    int id = await dbClient.insert(tablePeriods, period.toMap());
    return id;
  }

  Future<int> updatePeriod(Period period) async {
    var dbClient = await db;
    return await dbClient.update(tablePeriods, period.toMap(), where: 'id = ?', whereArgs: [period.id!]);
  }

  Future stopRuningTask() async {
    String query = 'SELECT * FROM '+tableTodo+' where started >0';
    var dbClient = await db;
    List<Map> list =  await dbClient.rawQuery( query );
    if (list.isNotEmpty) {
      Task task =  Task.fromMap(list.first);
      await addPeriodForTask(task);
      task.started = Utils.noDate.millisecondsSinceEpoch;
      await DatabaseHelper().update(task);
    }
  }

  Future addPeriodForTask(Task task) async {
    await DatabaseHelper().insertPeriod(task.id!,task.started,DateTime.now().millisecondsSinceEpoch);
  }
}