class AdoptionPet {
  final String name;
  final String species;
  final String breed;
  final int age;
  final String description;
  final String longDescription;
  final bool vaccinated;
  final List<String> vaccinesApplied;
  final List<String> vaccinesPending;
  final String healthStatus;
  final String imageUrl;

  AdoptionPet({
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.description,
    required this.longDescription,
    required this.vaccinated,
    required this.vaccinesApplied,
    required this.vaccinesPending,
    required this.healthStatus,
    required this.imageUrl,
  });
}

final List<AdoptionPet> adoptionPets = [
  AdoptionPet(
    name: 'Luna',
    species: 'Perro',
    breed: 'Labrador',
    age: 3,
    description: 'Cariñosa, juguetona y muy sociable.',
    longDescription:
        'Luna es una compañera tranquila en casa, le encantan los paseos largos y se adapta bien a familias con niños. Busca un hogar donde pueda seguir su rutina de ejercicio y recibir cariño diario.',
    vaccinated: true,
    vaccinesApplied: ['Rabia', 'Polivalente', 'Leptospirosis'],
    vaccinesPending: ['Refuerzo anual de polivalente'],
    healthStatus: 'Revisión reciente sin incidencias. Desparasitada interna y externamente.',
    imageUrl: 'https://picsum.photos/seed/adoption-luna/300/220',
  ),
  AdoptionPet(
    name: 'Milo',
    species: 'Gato',
    breed: 'Europeo',
    age: 2,
    description: 'Tranquilo, le encanta dormir y los mimos.',
    longDescription:
        'Milo es un gato de carácter observador y afectuoso cuando coge confianza. Ideal para hogares tranquilos; disfruta de las ventanas, los rascadores y las sesiones de juego cortas.',
    vaccinated: true,
    vaccinesApplied: ['Trivalente felina', 'Leucemia felina'],
    vaccinesPending: ['Rabia', 'Revisión dental preventiva'],
    healthStatus: 'Peso correcto, sin signos de enfermedad respiratoria.',
    imageUrl: 'https://picsum.photos/seed/adoption-milo/300/220',
  ),
  AdoptionPet(
    name: 'Kira',
    species: 'Perro',
    breed: 'Pastor Alemán',
    age: 4,
    description: 'Muy inteligente y protectora.',
    longDescription:
        'Kira necesita una familia que disfrute de la actividad física y la estimulación mental. Es obediente, aprende rápido y responde bien al refuerzo positivo.',
    vaccinated: false,
    vaccinesApplied: ['Rabia', 'Polivalente'],
    vaccinesPending: ['Leptospirosis', 'Tos de las perreras'],
    healthStatus: 'Pendiente de vacunación completa y control de cadera.',
    imageUrl: 'https://picsum.photos/seed/adoption-kira/300/220',
  ),
  AdoptionPet(
    name: 'Nina',
    species: 'Gato',
    breed: 'Siamés',
    age: 1,
    description: 'Curiosa y activa, ideal para familias.',
    longDescription:
        'Nina es una gatita muy activa y curiosa, perfecta para un hogar donde pueda explorar y jugar. Se lleva bien con otros gatos si la adaptación es gradual.',
    vaccinated: true,
    vaccinesApplied: ['Trivalente felina', 'Rabia'],
    vaccinesPending: ['Leucemia felina', 'Desparasitación externa'],
    healthStatus: 'Correcta de salud general. Analítica reciente normal.',
    imageUrl: 'https://picsum.photos/seed/adoption-nina/300/220',
  ),
  AdoptionPet(
    name: 'Rocky',
    species: 'Perro',
    breed: 'Bulldog',
    age: 5,
    description: 'Fiel y tranquilo, busca un hogar estable.',
    longDescription:
        'Rocky es un perro calmado que disfruta de rutinas predecibles. Requiere paseos suaves y vigilancia de peso para mantener una buena calidad de vida.',
    vaccinated: true,
    vaccinesApplied: ['Rabia', 'Polivalente', 'Leptospirosis'],
    vaccinesPending: ['Control respiratorio', 'Refuerzo anual'],
    healthStatus: 'Sin patologías graves. Control veterinario semestral.',
    imageUrl: 'https://picsum.photos/seed/adoption-rocky/300/220',
  ),
  AdoptionPet(
    name: 'Lola',
    species: 'Conejo',
    breed: 'Enano',
    age: 2,
    description: 'Pequeña, dócil y muy limpia.',
    longDescription:
        'Lola es una coneja muy tranquila que necesita un espacio limpio, heno de calidad y un entorno sin ruidos fuertes. Es perfecta para hogares pacientes y cuidadosos.',
    vaccinated: false,
    vaccinesApplied: ['Mixomatosis'],
    vaccinesPending: ['Enfermedad hemorrágica vírica', 'Revisión dental'],
    healthStatus: 'Revisión digestiva en seguimiento, apetito normal.',
    imageUrl: 'https://picsum.photos/seed/adoption-lola/300/220',
  ),
  AdoptionPet(
    name: 'Bruno',
    species: 'Hurón',
    breed: 'Mestizo',
    age: 2,
    description: 'Curioso, ágil y muy despierto.',
    longDescription:
        'Bruno es un hurón sociable que necesita enriquecimiento ambiental y supervisión al explorar. Ideal para personas con experiencia o ganas de aprender.',
    vaccinated: true,
    vaccinesApplied: ['Rabia', 'Moquillo'],
    vaccinesPending: ['Control anual de peso'],
    healthStatus: 'Muy activo, control veterinario reciente favorable.',
    imageUrl: 'https://picsum.photos/seed/adoption-bruno/300/220',
  ),
  AdoptionPet(
    name: 'Nube',
    species: 'Gato',
    breed: 'Mestizo',
    age: 6,
    description: 'Tranquila, cariñosa y muy limpia.',
    longDescription:
        'Nube busca un entorno calmado donde pueda descansar y recibir mimos. Tiene hábitos de higiene excelentes y convive bien con otros animales tranquilos.',
    vaccinated: true,
    vaccinesApplied: ['Trivalente felina', 'Rabia', 'Leucemia felina'],
    vaccinesPending: ['Revisión geriátrica anual'],
    healthStatus: 'Sana, con control renal a vigilar por edad.',
    imageUrl: 'https://picsum.photos/seed/adoption-nube/300/220',
  ),
];
