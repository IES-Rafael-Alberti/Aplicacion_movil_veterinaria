import 'package:flutter/material.dart';
import '../models/appointment_model.dart';

class AppointmentHistoryScreen extends StatelessWidget {
  const AppointmentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointments = AppointmentHistory.appointments.reversed.toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        title: const Text(
          'Historial de citas',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: appointments.isEmpty
          ? const Center(child: Text('No tienes citas registradas.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: appointments.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (context, i) {
                final a = appointments[i];
                return ListTile(
                  leading: const Icon(
                    Icons.calendar_today,
                    color: Color(0xFF1976D2),
                  ),
                  title: Text(
                    '${a.date.day}/${a.date.month}/${a.date.year} - ${a.time}',
                  ),
                  subtitle: Text('${a.animalType.name} | ${a.reason}'),
                  trailing: Text(a.name),
                );
              },
            ),
    );
  }
}
