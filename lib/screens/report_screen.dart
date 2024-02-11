import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/report_model.dart';
import '../widgets/app_drawer.dart';

enum ReportType { period,tag,day }

class Reportscreen extends StatelessWidget{
  ReportType reportType = ReportType.period;

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
        providers: [
        ChangeNotifierProvider(create: (_) => ReportModel()),
    ],
    child:Builder(builder: (BuildContext context) {
      ReportModel reportModel = context.watch<ReportModel>();
      return DefaultTabController(
          initialIndex: 1,
          length: 3,
          child:Scaffold(
        drawer: MyDrawer(),
        body: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 50, 10, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "Журнал ",
                      style: TextStyle(fontSize: 30),
                    ),
                Row(
                  children: [
                    TextButton(
                        onPressed: ()async {
                          DateTimeRange? selected = await showDateRangePicker(
                            context: context,
                           initialDateRange: DateTimeRange(start:reportModel.start,end:reportModel.end),
                            firstDate: DateTime.now().subtract(Duration(days: 360)), //хранить в sp
                            currentDate: DateTime.now(),
                            lastDate: DateTime.now(),
                              saveText:"Ок"
                          );
                          reportModel.setDateTimeRange(selected!);
                        },
                        child:
                          Text(
                            reportModel.startPeriodString ,
                           // style: TextStyle(fontSize: 30),
                          )
                        ),
                    Text(
                      "-" ,
                      // style: TextStyle(fontSize: 30),
                    ),
                    TextButton(
                        onPressed: () {

                        },
                        child:
                            Text(
                              reportModel.endPeriodString ,
                              // style: TextStyle(fontSize: 30),
                            )
                          )]),

                    Expanded(child: Text("")),
                    IconButton(
                      icon: Icon(Icons.filter_list_outlined),
                      onPressed: () {
                      },
                    )
                  ],
                )),
            SizedBox(height: 30,),
            TabBar(
              tabs: <Widget>[
                Tab(
                    text:"Время"
                  //icon: Icon(Icons.timer_outlined),
                ),
                Tab(
                    text:"Теги"
                  // icon: Icon(Icons.tag),
                ),
                Tab(
                    text:"Задачи"
                  //icon: Icon(Icons.task_alt_rounded),
                ),
              ],
            ),
            Expanded(child:
            TabBarView(
              children: <Widget>[
                Center(
                  child: Text("It's cloudy here"),
                ),
                Center(
                  child: Text("It's rainy here"),
                ),
                Center(
                  child: Text("It's sunny here"),
                ),
              ],
            )),
          ],
        ),

      ));
    }));
  }


}
