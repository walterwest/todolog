
import 'package:flutter/material.dart';
import 'package:todolog/models/repeat_object.dart';

class RepeatViewModel with ChangeNotifier {
  Repeat repeat;
  String get repetitions => repeat.repetitions.toString();
  //String get repetitionsPerDay => repeat.repetitionsPerDay.toString();

  RepeatType get repeatType => repeat.repeatType;

  RepeatViewModel(this.repeat);

  String firstWord(repeatType) {
    switch (repeatType){
      case RepeatType.weekly:
        return "Каждую";
      case RepeatType.no_repeat:
        return "Не";
      default:
        return "Каждый";
    }
  }

  String secondWord(repeatType) {
    switch (repeatType){
      case RepeatType.no_repeat:
        return "повторять";
      case RepeatType.daily:
        return "день";
      case RepeatType.weekly:
        return "неделю";
      case RepeatType.monthly:
        return "месяц";
      case RepeatType.annually:
        return "год";
      case RepeatType.hourly:
        return "час";
      default:
        return "";
    }
  }

  select(RepeatType repeatType){
    repeat.select(repeatType);
    setRepeatAmount("1");
    notifyListeners();
  }

  setRepeatAmount(String amount){
    int amountNum = int.parse(amount);
    repeat.setRepetitions(amountNum);
  }

  /*setRepeatPerDay(String amount){
    int amountNum = int.parse(amount);
    repeat.setRepetitionsPerDay(amountNum);
  }*/

  onMonTap(){
    repeat.setMon();
    notifyListeners();
  }

  onTueTap(){
    repeat.setTue();
    notifyListeners();
  }

  onWedTap(){
    repeat.setWed();
    notifyListeners();
  }

  onThuTap(){
    repeat.setThu();
    notifyListeners();
  }

  onFriTap(){
    repeat.setFri();
    notifyListeners();
  }

  onSatTap(){
    repeat.setSat();
    notifyListeners();
  }

  onSunTap(){
    repeat.setSun();
    notifyListeners();
  }




}