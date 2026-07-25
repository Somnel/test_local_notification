import 'package:flutter/material.dart';
import 'package:test_notifications/service/local_notification.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _titleControl = TextEditingController();
  final _descControl = TextEditingController();

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
  Widget build(BuildContext context) {
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Título'
                ),
              ),
              TextField(
                controller: _descControl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Descrição'
                ),
              ),
              ElevatedButton.icon(
                onPressed: createNotification, 
                label: const Text("Criar notificação"),
                icon: const Icon(Icons.add_alert)
              ),
            ],
          ),
        ),
      ),
    );
  }
}