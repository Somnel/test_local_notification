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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Column(
            crossAxisAlignment: .stretch,
            spacing: 16,
            children: [
              DecoratedBox(
                decoration: BottomBorder(colorScheme.outline),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Criar Notificações', 
                    style: theme.textTheme.headlineMedium?.copyWith(color: colorScheme.onSurface) 
                          ?? TextStyle(fontSize: 26)
                  ),
                ),
              ),
              SizedBox(height: 16),
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
              Padding(
                padding: const .only(top: 16),
                child: Text(
                  'Schedule',
                  style: theme.textTheme.titleMedium ?? const TextStyle(),
                ),
              ),
              Container(
                padding: .symmetric(vertical: 4, horizontal: 3),
                decoration: BottomBorder(selectedTime != null ? colorScheme.primary : colorScheme.onSurface).copyWith(
                  color: colorScheme.surfaceContainerHighest,
                ),
                child: TextButton.icon(
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
                  label: SizedBox(
                    width: .infinity,
                    child: Text(
                      selectedTime?.format(context) ?? 'Timer', 
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: .9),
                        letterSpacing: 1.2
                      )
                    ),
                  ),
                  iconAlignment: .end,
                  icon: Icon(Icons.alarm_add)
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: (){},
        child: Icon(Icons.add_alert),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  BoxDecoration BottomBorder(Color borderColor) {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 1,
          color: borderColor
        )
      )
    );
  }
}

class TimerField extends StatefulWidget {
  const TimerField({super.key});

  @override
  State<TimerField> createState() => _TimerFieldState();
}

class _TimerFieldState extends State<TimerField> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}