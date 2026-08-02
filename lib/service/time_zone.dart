import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimeZoneService {
  static final TimeZoneService _instance = TimeZoneService._();

  TimeZoneService._();
  static TimeZoneService get instance => _instance;

  Future<void> init() async {
    tz.initializeTimeZones();

    final timezone = await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(
      tz.getLocation(timezone.identifier)
    );
  }
}