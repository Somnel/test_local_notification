import 'package:flutter/material.dart';
import 'package:test_notifications/l10n/app_localizations.dart';
import 'package:test_notifications/service/local_notification.dart';
import 'package:test_notifications/ui/core/ui/timer_field.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>(); 
  // fields
  String? title;
  String? description; 
  TimeOfDay? timer;
  bool isTimerActiver = false;
   
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: .end,
        spacing: 16,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: localization.fieldTitle
            ),
            onSaved: (value) => title = value,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: localization.fieldDescription
            ),
            onSaved: (value) => description = value,
          ),
          TimerField(
            onSave: (timer) {
              this.timer = timer;
            },
            onChangedState: (state) {
              isTimerActiver = state;
            }
          ),
          SizedBox(height: 100),
          FilledButton.icon(
            onPressed: () {
              final type = pushNotification();

              if(type != null) {
                String message = '';

                if(type == NotificationType.scheduled) {
                  message = 'Mensagem agendada para ${timer!.format(context)}';
                } else if(type == NotificationType.scheduledTimerBefore) {
                  message = 'O horário deve ser depois do atual';
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              }
            }, 
            label: const Text('Criar Notificação'),
            icon: Icon(Icons.add_alert),
          )
        ],
      ),
    );
  }

  NotificationType? pushNotification() {
    if(_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      TimeOfDay? iTimer;
      
      if(isTimerActiver && timer?.hour != null && timer?.minute != null) {
        final now = DateTime.now();

        final newDate = DateTime(
          now.year,
          now.month,
          now.day,
          timer!.hour,
          timer!.minute
        );

        iTimer = TimeOfDay.fromDateTime(newDate);

        if(newDate.isBefore(now)) {
          return NotificationType.scheduledTimerBefore;
        }
      }

      

      return LocalNotificationService.instance.show(data: 
        NotificationData(
          title: title,
          body: description,
          timer: iTimer
        )
      );
    }

    return null;
  }

  @override
  void dispose() {
    if(_formKey.currentState != null) {
      _formKey.currentState!.dispose();
    }
    super.dispose();
  }
}


