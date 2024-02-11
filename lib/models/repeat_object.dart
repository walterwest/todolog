import 'dart:convert';

import 'package:todolog/utils.dart';

enum RepeatType { no_repeat, daily, weekly, monthly,  annually, hourly }

class Repeat {
  int periodicity=0;
  int repetitions=1;
  //int repetitionsPerDay=1;
  //int repetitionsPerDayDone=0;
  bool isMon = false;
  bool isTue = false;
  bool isWed = false;
  bool isThu = false;
  bool isFri = false;
  bool isSat = false;
  bool isSun = false;

  Repeat();

  Repeat.fromJson(Map<String, dynamic> json) {
    periodicity=json['periodicity'] as int;
    repetitions=json['repetitions'] as int;
    isMon = json['isMon'] as bool;
    isTue = json['isTue'] as bool;
    isWed = json['isWed'] as bool;
    isThu = json['isThu'] as bool;
    isFri = json['isFri'] as bool;
    isSat = json['isSat'] as bool;
    isSun = json['isSun'] as bool;
    /*
    try{
      repetitionsPerDay=json['repetitionsPerDay'] as int;
    }catch(e){
      repetitionsPerDay=1;
    }
    try{
    repetitionsPerDayDone=json['repetitionsPerDayDone'] as int; }
    catch(e){
      repetitionsPerDayDone = 0;
    }*/
  }

  Map<String, dynamic> toJson() => {
    'periodicity':periodicity,
    'repetitions':repetitions,
    'isMon':isMon,
    'isTue':isTue,
    'isWed':isWed,
    'isThu':isThu,
    'isFri':isFri,
    'isSat':isSat,
    'isSun':isSun,
   // 'repetitionsPerDay':repetitionsPerDay,
   // 'repetitionsPerDayDone':repetitionsPerDayDone
  };

  RepeatType get repeatType {
    switch (periodicity){
      case 0:
        return RepeatType.no_repeat;
      case 1:
        return RepeatType.daily;
      case 2:
        return RepeatType.weekly;
      case 3:
        return RepeatType.monthly;
      case 4:
        return RepeatType.annually;
      case 5:
        return RepeatType.hourly;
      default:
        return RepeatType.no_repeat;
    }
  }

  bool isRepeatable(){
    if(repeatType == RepeatType.no_repeat){
      return false;
    }
    return true;
  }

  select(RepeatType repeatType){
    periodicity = repeatType.index;
    repetitions = 1;
    isMon = false;
    isTue = false;
    isWed = false;
    isThu = false;
    isFri = false;
    isSat = false;
    isSun = false;
  }

  int getNextDueDate( ){
    DateTime nowDT = DateTime.now();
    //repetitionsPerDayDone = repetitionsPerDayDone + 1;
    /*if(repetitionsPerDay>1 && repetitionsPerDayDone<repetitionsPerDay && !skip){
      return nowDT.millisecondsSinceEpoch;
    }else{*/
      //repetitionsPerDayDone = 0;
    switch (repeatType){
      case RepeatType.hourly:
        Duration duration = Duration(hours: repetitions);
        nowDT=nowDT.add(duration);
        return nowDT.millisecondsSinceEpoch;
      case RepeatType.daily:
          Duration duration = Duration(days: repetitions);
          nowDT=nowDT.add(duration);
          return nowDT.millisecondsSinceEpoch;
      case RepeatType.weekly:
        int nextDW = getNextDayOfWeek(nowDT.weekday);
        if(nextDW>0){
          Duration duration = Duration(days: (nextDW-nowDT.weekday));
          nowDT=nowDT.add(duration);
          return nowDT.millisecondsSinceEpoch;
        }
        else{
          Duration duration = Duration(days: (nowDT.weekday-DateTime.monday));
          nowDT=nowDT.add(Duration(days: 6));
          nowDT=nowDT.subtract (duration);
          nowDT=nowDT.add(Duration(days: getDayOfNextWeek()));
          return nowDT.millisecondsSinceEpoch;
        }
      case RepeatType.monthly:
        return nowDT.add(Duration(days: 30)).millisecondsSinceEpoch;
      case RepeatType.annually:
        return DateTime((nowDT.year+1),nowDT.month,nowDT.day).millisecondsSinceEpoch;
      default:
        Duration duration = Duration(days: 1);
        nowDT=nowDT.add(duration);
        return nowDT.millisecondsSinceEpoch;
    }
    //}
  }

  int getNextDayOfWeek(int currentDay){
    if(isMon && 1>currentDay){
      return 1;
    }
    if(isTue && 2>currentDay){
      return 2;
    }
    if(isWed && 3>currentDay){
      return 3;
    }
    if(isThu && 4>currentDay){
      return 4;
    }
    if(isFri && 5>currentDay){
      return 5;
    }
    if(isSat && 6>currentDay){
      return 6;
    }
    if(isSun && 7>currentDay){
      return 7;
    }
    return 0;
  }

  int getDayOfNextWeek(){
    if(isMon ){
      return 1;
    }
    if(isTue ){
      return 2;
    }
    if(isWed  ){
      return 3;
    }
    if(isThu){
      return 4;
    }
    if(isFri ){
      return 5;
    }
    if(isSat ){
      return 6;
    }
    if(isSun ){
      return 7;
    }
    return 1;
  }

  setRepetitions(int amount){
    repetitions = amount;
  }

  /*setRepetitionsPerDay(int amount){
    repetitionsPerDay = amount;
  }*/

  String getJson(){
    String json =  jsonEncode(this);
    return json;
  }

  String get repeatString {
    switch (repeatType){
      case RepeatType.no_repeat:
        return "Не повторять";
      case RepeatType.daily:
        return "Каждый "+repetitions.toString()+" день";
      case RepeatType.weekly:
        String str = "Каждую "+repetitions.toString()+" неделю";
        String breakets = "";
        if(isMon){
          breakets = "ПН ";
        }
        if(isTue){
          breakets = breakets + "ВТ ";
        }
        if(isWed){
          breakets = breakets + "СР ";
        }
        if(isThu){
          breakets = breakets + "ЧТ ";
        }
        if(isFri){
          breakets = breakets + "ПТ ";
        }
        if(isSat){
          breakets = breakets + "СБ ";
        }
        if(isSun){
          breakets = breakets + "ВС ";
        }
        if(breakets.isNotEmpty){
          breakets = " ( "+breakets+")";
        }
        return str+breakets;
      case RepeatType.monthly:
        return "Каждый "+repetitions.toString()+" месяц";
      case RepeatType.annually:
        return "Каждый "+repetitions.toString()+" год";
      default:
        return "Не повторять";
    }
  }

  setMon(){
    isMon = !isMon;
  }

  setTue(){
    isTue = !isTue;
  }

  setWed(){
    isWed = !isWed;
  }

  setThu(){
    isThu = !isThu;
  }

  setFri(){
    isFri = !isFri;
  }

  setSat(){
    isSat = !isSat;
  }

  setSun(){
    isSun = !isSun;
  }
}