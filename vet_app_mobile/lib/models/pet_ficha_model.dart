class PetCheckup {
  final String title;
  final DateTime date;
  final String notes;
  final bool completed;

  const PetCheckup({
    required this.title,
    required this.date,
    required this.notes,
    required this.completed,
  });
}

class PetVaccination {
  final String name;
  final DateTime dueDate;
  final bool applied;

  const PetVaccination({
    required this.name,
    required this.dueDate,
    required this.applied,
  });
}

class PetFicha {
  final String name;
  final String species;
  final String breed;
  final int age;
  final String microchip;
  final String description;
  final String imageUrl;
  final List<PetCheckup> checkups;
  final List<PetVaccination> vaccinations;

  const PetFicha({
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.microchip,
    required this.description,
    required this.imageUrl,
    required this.checkups,
    required this.vaccinations,
  });
}

final List<PetFicha> petFichas = [
  PetFicha(
    name: 'Toby',
    species: 'Perro',
    breed: 'Mestizo mediano',
    age: 4,
    microchip: 'ES-VC-20451',
    description:
        'Perro muy sociable, tranquilo en casa y activo en paseos. Convive bien con niños y otros perros.',
    imageUrl: 'https://picsum.photos/seed/pet-toby/300/220',
    checkups: [
      PetCheckup(
        title: 'Revisión general',
        date: DateTime(2026, 1, 12),
        notes: 'Peso estable, dientes sanos y buena condición corporal.',
        completed: true,
      ),
      PetCheckup(
        title: 'Control dermatológico',
        date: DateTime(2026, 3, 8),
        notes: 'Sin irritaciones; se recomienda continuar con champú suave.',
        completed: true,
      ),
      PetCheckup(
        title: 'Próxima revisión',
        date: DateTime(2026, 6, 15),
        notes: 'Pendiente de analítica anual y control articular.',
        completed: false,
      ),
    ],
    vaccinations: [
      PetVaccination(name: 'Rabia', dueDate: DateTime(2026, 11, 10), applied: true),
      PetVaccination(name: 'Polivalente', dueDate: DateTime(2026, 8, 21), applied: true),
      PetVaccination(name: 'Leptospirosis', dueDate: DateTime(2026, 7, 5), applied: false),
    ],
  ),
  PetFicha(
    name: 'Misha',
    species: 'Gato',
    breed: 'Europeo común',
    age: 2,
    microchip: 'ES-VC-77301',
    description:
        'Gata curiosa y muy cariñosa. Le encanta descansar en sitios altos y jugar con pelotas ligeras.',
    imageUrl: 'https://picsum.photos/seed/pet-misha/300/220',
    checkups: [
      PetCheckup(
        title: 'Vacunación inicial',
        date: DateTime(2025, 11, 2),
        notes: 'Primera pauta completa sin incidencias.',
        completed: true,
      ),
      PetCheckup(
        title: 'Desparasitación interna',
        date: DateTime(2026, 2, 18),
        notes: 'Tratamiento realizado correctamente.',
        completed: true,
      ),
      PetCheckup(
        title: 'Revisión dental',
        date: DateTime(2026, 5, 22),
        notes: 'Pendiente de limpieza dental preventiva.',
        completed: false,
      ),
    ],
    vaccinations: [
      PetVaccination(name: 'Trivalente felina', dueDate: DateTime(2026, 10, 14), applied: true),
      PetVaccination(name: 'Leucemia felina', dueDate: DateTime(2026, 9, 9), applied: true),
      PetVaccination(name: 'Rabia', dueDate: DateTime(2026, 12, 1), applied: false),
    ],
  ),
];
