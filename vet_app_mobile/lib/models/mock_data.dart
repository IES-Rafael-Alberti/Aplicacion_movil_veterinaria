class AnimalType {
  final String name;
  AnimalType(this.name);
}

class ProductCategory {
  final String name;
  ProductCategory(this.name);
}

class Product {
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final ProductCategory category;
  final AnimalType animalType;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.animalType,
  });
}

final List<AnimalType> animalTypes = [
  AnimalType('Perro'),
  AnimalType('Gato'),
  AnimalType('Ave'),
  AnimalType('Conejo'),
  AnimalType('Hámster'),
  AnimalType('Pez'),
  AnimalType('Tortuga'),
  AnimalType('Hurón'),
  AnimalType('Caballo'),
  AnimalType('Iguana'),
  AnimalType('Cerdo'),
  AnimalType('Cabra'),
  AnimalType('Oveja'),
  AnimalType('Vaca'),
  AnimalType('Loro'),
  AnimalType('Canario'),
  AnimalType('Serpiente'),
  AnimalType('Chinchilla'),
  AnimalType('Erizo'),
  AnimalType('Rata'),
  AnimalType('Ratón'),
  AnimalType('Cuy'),
  AnimalType('Gallina'),
  AnimalType('Pato'),
  AnimalType('Ganso'),
  AnimalType('Paloma'),
  AnimalType('Burro'),
  AnimalType('Zorro'),
  AnimalType('Mapache'),
  AnimalType('Ardilla'),
];

final List<ProductCategory> categories = [
  ProductCategory('Alimento'),
  ProductCategory('Juguete'),
  ProductCategory('Accesorio'),
  ProductCategory('Higiene'),
  ProductCategory('Salud'),
  ProductCategory('Transporte'),
  ProductCategory('Ropa'),
  ProductCategory('Camas'),
  ProductCategory('Bebederos'),
  ProductCategory('Comederos'),
];

final List<Product> products = [
  for (var categoryIndex = 0; categoryIndex < categories.length; categoryIndex++)
    for (var animalIndex = 0; animalIndex < animalTypes.length; animalIndex++)
      Product(
        name: '${categories[categoryIndex].name} ${animalTypes[animalIndex].name} ${categoryIndex + 1}-${animalIndex + 1}',
        description:
            '${categories[categoryIndex].name} para ${animalTypes[animalIndex].name}: producto recomendado para cuidado diario, bienestar y salud.',
        price: double.parse((6.0 + ((categoryIndex * 3 + animalIndex) % 28) * 1.65).toStringAsFixed(2)),
        imageUrl: 'https://picsum.photos/seed/prod-${categoryIndex + 1}-${animalIndex + 1}/300/300',
        category: categories[categoryIndex],
        animalType: animalTypes[animalIndex],
      ),
];
