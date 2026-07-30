import 'package:flutter/material.dart';
import 'package:test_notifications/l10n/app_localizations.dart';
import 'package:test_notifications/service/local_notification.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _titleControl = TextEditingController();
  final _descControl = TextEditingController();
  TimeOfDay? selectedTime;

  MaterialTapTargetSize tapTargetSize = .padded;

  void createNotification() {
    final title = _titleControl.text;
    final description = _descControl.text;

    LocalNotificationService.instance.showNotification(
      title: title, 
      body: description
    );

    _titleControl.clear();
    _descControl.clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleControl.dispose();
    _descControl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: .center,
            spacing: 12,
            children: [
              TextField(
                controller: _titleControl,
                decoration: InputDecoration(
                  labelText: localization.fieldTitle
                ),
              ),
              TextField(
                controller: _descControl,
                decoration: InputDecoration(
                  labelText: localization.fieldDescription
                ),
              ),
              ElevatedButton.icon(
                onPressed: createNotification, 
                label: Text(localization.pushNotification),
                icon: const Icon(Icons.add_alert)
              ),
              ElevatedButton(
                onPressed: () async {
                  final TimeOfDay? time = await showTimePicker(
                    context: context, 
                    initialTime: TimeOfDay.now(),
                    initialEntryMode: .dial,
                    orientation: .portrait,
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: Theme.of(context).copyWith(materialTapTargetSize: .padded),
                        child: Directionality(
                          textDirection: .rtl, 
                          child: MediaQuery(
                            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), 
                            child: child!
                          )
                        ),
                      );
                    }
                  );

                  setState(() {
                    selectedTime = time;
                  });
                }, 
                child: const Text('Open MediaQuery')
              ),
              if(selectedTime != null) 
                Text('Selected Time ${selectedTime!.format(context)}')
            ],
          ),
        ),
      ),
    );
  }
}