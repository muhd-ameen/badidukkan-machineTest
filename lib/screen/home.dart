import 'package:alarm_app/constans/const.dart';
import 'package:alarm_app/controller/notificationController.dart';
import 'package:alarm_app/screen/secondPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _alarmTime;

  @override
  void initState() {
    super.initState();
    _alarmTime = DateTime.now();
    NotificationController.init(initScheduled: true);
    listenNotifications();
  }

  void listenNotifications() => NotificationController.onNotifications.stream
      .listen(onClickedNotification);

  void onClickedNotification(String? payload) => Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SecondPage(payload: payload)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Set Alarm',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                      onTap: () => NotificationController.showNotification(
                            title: "It's Test",
                            body: "Hey! Wake, Times up",
                            payload: 'Alarm Turned Off',
                          ),
                      child: Image.asset('assets/images/alarm_icon.png')),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: 50.0,
                    margin: EdgeInsets.all(10),
                    child: RaisedButton(
                      onLongPress: () => NotificationController.cancelAll(),
                      onPressed: () => addAlarm(),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xffCB356B), Color(0xffBD3F32)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Schedule Alarm",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void addAlarm() async {
    DateTime scheduleAlarmDateTime;
    var selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      final now = DateTime.now();
      var selectedDateTime = DateTime(
          now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
      _alarmTime = selectedDateTime;

      final snackBar = SnackBar(
        content: Text(
          'Alarm Scheduled!',
          style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
      );
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
    if (_alarmTime!.isAfter(DateTime.now()))
      scheduleAlarmDateTime = _alarmTime!;
    else
      scheduleAlarmDateTime = _alarmTime!.add(Duration(days: 1));
    var a = scheduleAlarmDateTime;
    var alarmTime = DateFormat('hh:mm aa').format(a);
    NotificationController.showScheduleNotification(
      title: "It's $alarmTime",
      body: "Hey! Wake, Times up",
      payload: 'Alarm Turned Off',
      scheduledDate: scheduleAlarmDateTime,
    );
  }
}
