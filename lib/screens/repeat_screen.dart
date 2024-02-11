import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todolog/view_models/repeat_view_model.dart';
import 'package:todolog/widgets/complete_checkBox.dart';
import '../models/repeat_object.dart';

enum DueDateItem { today, tomorrow, weekLater, chooseDate }

class RepeatScreen extends StatelessWidget {
  Repeat repet;
  RepeatScreen(this.repet);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RepeatViewModel(repet)),
      ],
      child: Builder(
        builder: (BuildContext context) {
          RepeatViewModel repeatViewModel = context.watch<RepeatViewModel>();

          return Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xFFf9f9f9),
                title: Text("Повторять"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_outlined),
                  onPressed: () {
                    Navigator.pop(context, repeatViewModel.repeat);
                  },
                ),
              ),
              body: ListView(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  buildRepeatRowWidget(
                      RepeatType.no_repeat, repeatViewModel, context),
                  Divider(),

                  buildRepeatRowWidget(
                      RepeatType.daily, repeatViewModel, context),
                  Divider(),
                  buildRepeatRowWidget(
                      RepeatType.weekly, repeatViewModel, context),
                  Divider(),
                  buildRepeatRowWidget(
                      RepeatType.monthly, repeatViewModel, context),
                  Divider(),
                  buildRepeatRowWidget(
                      RepeatType.annually, repeatViewModel, context),
                ],
              ));
        },
      ),
    );
  }

  Widget buildRepeatRowWidget(RepeatType buildedRT, RepeatViewModel repeatViewModel, BuildContext context) {
    if (repeatViewModel.repeatType == buildedRT) {
      var selectedBtnStyle = ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(30))));
      var btnstyle = ButtonStyle();
      return Column(
        children: [
          Row(
            children: [
              CompleteCheckBox(true, (val) {}),
              Text(repeatViewModel.firstWord(buildedRT)),
              buildedRT == RepeatType.no_repeat
                  ? SizedBox()
                  : buildNumberTextField(repeatViewModel.repetitions, repeatViewModel,(text){
                repeatViewModel.setRepeatAmount(text);
              }),
              Text(repeatViewModel.secondWord(buildedRT))
            ],
          ),

          repeatViewModel.repeatType == RepeatType.weekly
              ? FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(children: [
                    TextButton(
                        style: repeatViewModel.repeat.isMon
                            ? selectedBtnStyle
                            : btnstyle,
                        onPressed: () {
                          repeatViewModel.onMonTap();
                        },
                        child: Text("ПН")),
                    TextButton(
                        style: repeatViewModel.repeat.isTue
                            ? selectedBtnStyle
                            : btnstyle,
                        onPressed: () {
                          repeatViewModel.onTueTap();
                        },
                        child: Text("ВТ")),
                    TextButton(
                        style: repeatViewModel.repeat.isWed
                            ? selectedBtnStyle
                            : btnstyle,
                        onPressed: () {
                          repeatViewModel.onWedTap();
                        },
                        child: Text("СР")),
                    TextButton(
                        style: repeatViewModel.repeat.isThu
                            ? selectedBtnStyle
                            : btnstyle,
                        onPressed: () {
                          repeatViewModel.onThuTap();
                        },
                        child: Text("ЧТ")),
                    TextButton(
                        style: repeatViewModel.repeat.isFri
                            ? selectedBtnStyle
                            : btnstyle,
                        onPressed: () {
                          repeatViewModel.onFriTap();
                        },
                        child: Text("ПТ")),
                    TextButton(
                        style: repeatViewModel.repeat.isSat
                            ? selectedBtnStyle
                            : btnstyle,
                        onPressed: () {
                          repeatViewModel.onSatTap();
                        },
                        child: Text("СБ")),
                    TextButton(
                        style: repeatViewModel.repeat.isSun
                            ? selectedBtnStyle
                            : btnstyle,
                        onPressed: () {
                          repeatViewModel.onSunTap();
                        },
                        child: Text("ВС"))
                  ]))
              : SizedBox(),

        /*  repeatViewModel.repeatType != RepeatType.no_repeat
              ? Row(
    children: [
      Text("Повторений в день"),
        buildNumberTextField(repeatViewModel.repetitionsPerDay, repeatViewModel,(text){
          repeatViewModel.setRepeatPerDay(text);
        }),
    ],
    )
              : SizedBox(),*/
        ],
      );
    } else {
      return Row(
        children: [
          CompleteCheckBox(false, (val) {
            repeatViewModel.select(buildedRT);
          }),
          Text((repeatViewModel.firstWord(buildedRT) +
              " " +
              repeatViewModel.secondWord(buildedRT)))
        ],
      );
    }
  }

  Widget buildNumberTextField(String repeattimes, RepeatViewModel repeatViewModel, onchanged ) {
    TextEditingController _titleController = new TextEditingController();
    _titleController.text = repeattimes;
    return SizedBox(
      width: 30,
      child: TextField(
        decoration: InputDecoration(
          counterText: "",
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 3,
        textAlignVertical: TextAlignVertical.center,
        controller: _titleController,
        onChanged: onchanged,
      ),
    );
  }


}
