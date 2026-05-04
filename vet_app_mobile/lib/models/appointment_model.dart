import '../models/mock_data.dart';

class Appointment {
  final String name;
  final String email;
  final String phone;
  final AnimalType animalType;
  final String reason;
  final DateTime date;
  final String time;

  Appointment({
    required this.name,
    required this.email,
    required this.phone,
    required this.animalType,
    required this.reason,
    required this.date,
    required this.time,
  });
}

class AppointmentHistory {
  static final List<Appointment> _appointments = [];

  static List<Appointment> get appointments => List.unmodifiable(_appointments);

  static void add(Appointment appointment) {
    _appointments.add(appointment);
  }
}
