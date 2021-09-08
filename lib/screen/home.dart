import 'package:alarm_app/controller/notificationController.dart';
import 'package:alarm_app/screen/secondPage.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    NotificationController.init();
    listenNotifications();
  }

  void listenNotifications() => NotificationController.onNotifications.stream
      .listen(onClickedNotification);

  void onClickedNotification(String? payload) => Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SecondPage(payload: payload)));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Local Notification',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      NotificationController.showNotification(
                        title: 'Hai Ameen',
                        body: 'Hey! its a notification',
                        payload: 'sarah.abs',
                      );
                    },
                    child: Text('Simple notification'),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      NotificationController.showScheduleNotification(
                        title: 'Hai shaheen',
                        body: 'Hey! its a notification',
                        payload: 'sarah.abs',
                        scheduledDate:
                            DateTime.now().add(Duration(seconds: 5)),
                      );
                      final snackBar = SnackBar(
                        content: Text(
                          'Scheduled in 5 Seconds',
                          style: TextStyle(fontSize: 24),
                        ),
                        backgroundColor: Colors.green,
                      );
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    },
                    child: Text('Scheduled notification'),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Remove notification'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
