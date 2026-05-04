
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        title: const Text('Clínica Veterinaria', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenido a nuestra clínica',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Somos una clínica veterinaria dedicada al bienestar animal desde hace más de 20 años. Nuestro equipo profesional cuida de tus mascotas como si fueran parte de nuestra familia.',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text(
                '¿Qué deseas hacer hoy?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1976D2),
                ),
              ),
              const SizedBox(height: 24),
              _HomeMenuButton(
                text: 'Tienda de productos',
                icon: Icons.storefront,
                onTap: () => Navigator.pushNamed(context, '/store'),
              ),
              const SizedBox(height: 16),
              _HomeMenuButton(
                text: 'Pedir cita veterinaria',
                icon: Icons.calendar_today,
                onTap: () => Navigator.pushNamed(context, '/appointment'),
              ),
              const SizedBox(height: 16),
              _HomeMenuButton(
                text: 'Adoptar un animal',
                icon: Icons.pets,
                onTap: () => Navigator.pushNamed(context, '/adoption'),
              ),
              const SizedBox(height: 16),
              _HomeMenuButton(
                text: 'Historial de adopciones',
                icon: Icons.history,
                onTap: () => Navigator.pushNamed(context, '/adoption', arguments: {'showHistory': true}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeMenuButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _HomeMenuButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
          child: Row(
            children: [
              Icon(icon, color: Color(0xFF1976D2), size: 28),
              const SizedBox(width: 18),
              Text(
                text,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
}
