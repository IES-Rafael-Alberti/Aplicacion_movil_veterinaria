import 'package:flutter/material.dart';
import 'screens/adoption_screen.dart';
import 'screens/appointment_screen.dart';
import 'screens/home_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/pet_fichas_screen.dart';
import 'screens/store_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vet App Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1976D2)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/store': (context) => StoreScreen(),
        '/appointment': (context) => AppointmentScreen(),
        '/adoption': (context) => AdoptionScreen(),
        '/orders': (context) => const OrdersScreen(),
        '/fichas': (context) => const PetFichasScreen(),
      },
    );
  }
}
