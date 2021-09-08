import 'package:alarm_app/controller/utils.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationController {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    final largeIconPath = await Utils.downloadFile(
        'https://scontent.fccj2-1.fna.fbcdn.net/v/t1.6435-9/231207989_129677102663826_4063297524183920489_n.png?_nc_cat=109&ccb=1-5&_nc_sid=e3f864&_nc_ohc=hVCer1gghTYAX_VrO8J&_nc_ht=scontent.fccj2-1.fna&oh=cedd8a00215139e9078a8793a8be6245&oe=615FED55',
        'largeIcon');
    final bigPicturePath = await Utils.downloadFile(
        'https://scontent.fccj2-1.fna.fbcdn.net/v/t1.6435-9/231207989_129677102663826_4063297524183920489_n.png?_nc_cat=109&ccb=1-5&_nc_sid=e3f864&_nc_ohc=hVCer1gghTYAX_VrO8J&_nc_ht=scontent.fccj2-1.fna&oh=cedd8a00215139e9078a8793a8be6245&oe=615FED55',
        'bigPicture');
    final styleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      largeIcon: FilePathAndroidBitmap(largeIconPath),
    );

    final sound = 'notes.wav';

    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        'channel description',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound(sound.split('.').first),
        enableVibration: false,
        styleInformation: styleInformation,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);
    final details = await _notification.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      onNotifications.add(details.payload);
    }
    await _notification.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );
    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notification.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );

  static Future showScheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduledDate,
  }) async =>
      _notification.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
  static void cancelAll() => _notification.cancelAll();
}
