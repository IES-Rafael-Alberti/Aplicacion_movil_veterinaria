class AdoptionPet {
  final String name;
  final String species;
  final String breed;
  final int age;
  final String description;
  final String imageUrl;

  AdoptionPet({
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.description,
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
    imageUrl: 'https://placehold.co/120x120?text=Luna',
  ),
  AdoptionPet(
    name: 'Milo',
    species: 'Gato',
    breed: 'Europeo',
    age: 2,
    description: 'Tranquilo, le encanta dormir y los mimos.',
    imageUrl: 'https://placehold.co/120x120?text=Milo',
  ),
  AdoptionPet(
    name: 'Kira',
    species: 'Perro',
    breed: 'Pastor Alemán',
    age: 4,
    description: 'Muy inteligente y protectora.',
    imageUrl: 'https://placehold.co/120x120?text=Kira',
  ),
  AdoptionPet(
    name: 'Nina',
    species: 'Gato',
    breed: 'Siamés',
    age: 1,
    description: 'Curiosa y activa, ideal para familias.',
    imageUrl: 'https://placehold.co/120x120?text=Nina',
  ),
  AdoptionPet(
    name: 'Rocky',
    species: 'Perro',
    breed: 'Bulldog',
    age: 5,
    description: 'Fiel y tranquilo, busca un hogar estable.',
    imageUrl: 'https://placehold.co/120x120?text=Rocky',
  ),
  AdoptionPet(
    name: 'Lola',
    species: 'Conejo',
    breed: 'Enano',
    age: 2,
    description: 'Pequeña, dócil y muy limpia.',
    imageUrl: 'https://placehold.co/120x120?text=Lola',
  ),
  // ...puedes añadir más mascotas aquí
];
