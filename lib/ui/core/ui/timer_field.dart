import 'package:flutter/material.dart';
import 'package:test_notifications/service/local_notification.dart';
import 'package:test_notifications/ui/core/ui/bottom_border.dart';


class TimerField extends StatefulWidget {
  const TimerField({
    super.key, 
    required this.onSave, 
    required this.onChangedState 
  });

  final Function(TimeOfDay?) onSave;
  final Function(bool) onChangedState;

  @override
  State<TimerField> createState() => _TimerFieldState();
}

class _TimerFieldState extends State<TimerField> {
  TimeOfDay? iSelectedTime;
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    final themeColorScheme = Theme.of(context).colorScheme;

    LocalNotificationService.instance.requestAndroidPermission();

    return Column(
      children: [
        Padding(
          padding: const .symmetric(vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Schedule',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Checkbox(
                value: isActive, 
                onChanged: (value) {
                  setState(() {
                    isActive = value!;
                    widget.onChangedState.call(isActive);
                  });
                }
              ),
            ],
          ),
        ),
        AbsorbPointer(
          absorbing: !isActive,
          child: Opacity(
            opacity: isActive ? 1 : .35,
            child: Container(
              padding: const .symmetric(vertical: 4, horizontal: 3),
              decoration: BottomBorder(isActive && iSelectedTime != null ? themeColorScheme.primary : themeColorScheme.onSurface).copyWith(
                color: themeColorScheme.surfaceContainerHighest
              ),
              child: TextButton.icon(
                onPressed: () async {
                  await showTimePicker(
                    context: context, 
                    initialTime: TimeOfDay.now(),
                    initialEntryMode: .dial,
                    orientation: .portrait,
                    builder: (BuildContext context, Widget? child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), 
                        child: child!
                      );
                    }
                  ).then((value) => {
                    setState(() {
                      iSelectedTime = value;
                      widget.onSave.call(value);
                    })
                  });
                }, 
                label: SizedBox(
                  width: .infinity,
                  child: Text(
                    iSelectedTime?.format(context) ?? 'Timer', 
                    style: TextStyle(
                      color: themeColorScheme.onSurfaceVariant.withValues(alpha: .9),
                      letterSpacing: 1.2
                    )
                  ),
                ),
                iconAlignment: .end,
                icon: Icon(Icons.alarm_add)
              ),
            ),
          ),
        ),
      ],
    );
  }
}