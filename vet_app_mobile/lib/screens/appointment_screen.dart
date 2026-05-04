import 'package:flutter/material.dart';
import '../models/mock_data.dart';
import '../models/appointment_model.dart';
import 'appointment_history_screen.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AppointmentForm();
  }
}

class _AppointmentForm extends StatefulWidget {
  @override
  State<_AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<_AppointmentForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final reasonController = TextEditingController();
  AnimalType? selectedAnimalType;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedAnimalType = animalTypes.first;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (!context.mounted || date == null) {
      return;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (!context.mounted || time == null) {
      return;
    }

    setState(() {
      selectedDate = date;
      selectedTime = time;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        title: const Text(
          'Pedir cita veterinaria',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Historial de citas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AppointmentHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Solicita tu cita',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                  ),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Introduce tu nombre'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Introduce tu email';
                    }
                    if (!RegExp(
                      r'^[\w-.]+@[\w-]+\.[a-zA-Z]{2,}$',
                    ).hasMatch(v.trim())) {
                      return 'Introduce un email válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Introduce tu teléfono';
                    }
                    if (!RegExp(r'^[0-9]{9,15}$').hasMatch(v.trim())) {
                      return 'Introduce un teléfono válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<AnimalType>(
                  initialValue: selectedAnimalType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de animal',
                  ),
                  items: animalTypes
                      .map(
                        (a) => DropdownMenuItem(value: a, child: Text(a.name)),
                      )
                      .toList(),
                  onChanged: (a) => setState(() => selectedAnimalType = a),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Motivo de la cita',
                  ),
                  maxLines: 2,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Describe el motivo de la cita'
                      : null,
                ),
                const SizedBox(height: 10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Fecha y hora'),
                  subtitle: Text(
                    selectedDate == null || selectedTime == null
                        ? 'Selecciona fecha y hora'
                        : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} - ${selectedTime!.format(context)}',
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                    ),
                    onPressed: () => _pickDateTime(context),
                    child: const Text(
                      'Elegir',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          selectedDate != null &&
                          selectedTime != null) {
                        final appointment = Appointment(
                          name: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                          animalType: selectedAnimalType!,
                          reason: reasonController.text,
                          date: selectedDate!,
                          time: selectedTime!.format(context),
                        );
                        AppointmentHistory.add(appointment);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Cita solicitada'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nombre: ${appointment.name}'),
                                Text('Email: ${appointment.email}'),
                                Text('Teléfono: ${appointment.phone}'),
                                Text('Animal: ${appointment.animalType.name}'),
                                Text('Motivo: ${appointment.reason}'),
                                Text(
                                  'Fecha: ${appointment.date.day}/${appointment.date.month}/${appointment.date.year}',
                                ),
                                Text('Hora: ${appointment.time}'),
                                const SizedBox(height: 16),
                                const Divider(),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.email, color: Color(0xFF1976D2)),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Se ha enviado un email de confirmación a tu correo.',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Solicitar cita',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
