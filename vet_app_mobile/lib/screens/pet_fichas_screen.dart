import 'package:flutter/material.dart';

import '../models/pet_ficha_model.dart';

class PetFichasScreen extends StatefulWidget {
  const PetFichasScreen({super.key});

  @override
  State<PetFichasScreen> createState() => _PetFichasScreenState();
}

class _PetFichasScreenState extends State<PetFichasScreen> {
  final List<PetFicha> _pets = List.of(petFichas);

  void _addPet() {
    setState(() {
      _pets.add(
        PetFicha(
          name: 'Nuevo animal ${_pets.length + 1}',
          species: 'Perro',
          breed: 'Mestizo',
          age: 1,
          microchip: 'ES-VC-${30000 + _pets.length}',
          description:
              'Ficha de ejemplo para añadir más animales de tu familia.',
          imageUrl: 'https://picsum.photos/seed/pet-new-${_pets.length}/300/220',
          checkups: [
            PetCheckup(
              title: 'Primera revisión',
              date: DateTime(2026, 4, 8),
              notes: 'Chequeo general correcto.',
              completed: true,
            ),
            PetCheckup(
              title: 'Pendiente de control',
              date: DateTime(2026, 7, 8),
              notes: 'Revisión anual programada.',
              completed: false,
            ),
          ],
          vaccinations: [
            PetVaccination(
              name: 'Rabia',
              dueDate: DateTime(2026, 11, 1),
              applied: true,
            ),
            PetVaccination(
              name: 'Polivalente',
              dueDate: DateTime(2026, 9, 1),
              applied: false,
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        title: const Text('Fichas de tus animales', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: _addPet,
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Añadir animal',
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _pets.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final pet = _pets[index];
          return Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          pet.imageUrl,
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pet.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1976D2),
                              ),
                            ),
                            Text('${pet.species} · ${pet.breed}'),
                            Text('Edad: ${pet.age} años'),
                            Text('Microchip: ${pet.microchip}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(pet.description),
                  const SizedBox(height: 12),
                  const Text(
                    'Revisiones',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...pet.checkups.map(
                    (checkup) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        checkup.completed ? Icons.check_circle : Icons.schedule,
                        color: checkup.completed ? Colors.green : Colors.orange,
                      ),
                      title: Text(checkup.title),
                      subtitle: Text(
                        '${checkup.date.day}/${checkup.date.month}/${checkup.date.year} · ${checkup.notes}',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Vacunas',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...pet.vaccinations.map(
                    (vaccination) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        vaccination.applied ? Icons.shield : Icons.warning_amber,
                        color: vaccination.applied ? Colors.green : Colors.red,
                      ),
                      title: Text(vaccination.name),
                      subtitle: Text(
                        vaccination.applied
                            ? 'Aplicada · Próxima dosis ${vaccination.dueDate.day}/${vaccination.dueDate.month}/${vaccination.dueDate.year}'
                            : 'Pendiente · Fecha prevista ${vaccination.dueDate.day}/${vaccination.dueDate.month}/${vaccination.dueDate.year}',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
