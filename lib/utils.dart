class Utils {

  static DateTime noDate = DateTime(0);

  static DateTime today = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,23,59,59);

  static bool isItToday(DateTime dateTime){
    DateTime today = DateTime.now();
    //DateTime startOfTheDay = DateTime(today.year,today.month,today.day);
    //if(dateTime.millisecondsSinceEpoch == startOfTheDay.millisecondsSinceEpoch){
    if(dateTime.year ==today.year && dateTime.month ==today.month && dateTime.day ==today.day ){
      return true;
    }
    return false;
  }

  static String dateToString(DateTime dateTime){
    String dayOfWeek = "";
    switch(dateTime.weekday){
      case DateTime.monday:
        dayOfWeek = "пн";
      case DateTime.tuesday:
        dayOfWeek = "вт";
      case DateTime.wednesday:
        dayOfWeek = "ср";
      case DateTime.thursday:
        dayOfWeek = "чт";
      case DateTime.friday:
        dayOfWeek = "пт";
      case DateTime.saturday:
        dayOfWeek = "сб";
      case DateTime.sunday:
        dayOfWeek = "вс";
    }
    String month = "";
    switch(dateTime.month){
      case DateTime.january:
        month = "янв";
      case DateTime.february:
        month = "фев";
      case DateTime.march:
        month = "мар";
      case DateTime.april:
        month = "апр";
      case DateTime.may:
        month = "май";
      case DateTime.june:
        month = "июн";
      case DateTime.july:
        month = "июл";
      case DateTime.august:
        month = "авг";
      case DateTime.september:
        month = "сен";
      case DateTime.october:
        month = "окт";
      case DateTime.november:
        month = "ноя";
      case DateTime.december:
        month = "дек";
    }
    return dayOfWeek+", "+dateTime.day.toString()+" "+month+".";
  }

  static String formatDuration(Duration d) {
    var seconds = d.inSeconds;
    final days = seconds~/Duration.secondsPerDay;
    seconds -= days*Duration.secondsPerDay;
    final hours = seconds~/Duration.secondsPerHour;
    seconds -= hours*Duration.secondsPerHour;
    final minutes = seconds~/Duration.secondsPerMinute;
    var minutesStr = minutes.toString();
    if(minutes<10){
      minutesStr = "0"+minutesStr;
    }
    seconds -= minutes*Duration.secondsPerMinute;
    var secondsStr = seconds.toString();
    if(seconds<10){
      secondsStr = "0"+secondsStr;
    }
    final List<String> tokens = [];
    if (days != 0) {
      tokens.add('${days}');
    }
    if (hours != 0){
      tokens.add('${hours}');
    }
    tokens.add(minutesStr);
    tokens.add(secondsStr);
    return tokens.join(':');
  }

  static DateTime endOfDay(DateTime dateTime){
    return DateTime(dateTime.year,dateTime.month,dateTime.day,23,59,59);
  }

  static DateTime startOfDay(DateTime dateTime){
    return DateTime(dateTime.year,dateTime.month,dateTime.day,0,0,0);
  }
}
