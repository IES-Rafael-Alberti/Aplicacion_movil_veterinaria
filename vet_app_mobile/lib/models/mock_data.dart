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

final List<Product> products = List.generate(100, (i) {
  final animal = animalTypes[i % animalTypes.length];
  final category = categories[i % categories.length];
  return Product(
    name: 'Producto ${i + 1}',
    description: 'Descripción del producto ${i + 1} para ${animal.name}',
    price: 5.0 + (i % 20) * 2.5,
    imageUrl: 'https://placehold.co/120x120?text=Prod${i + 1}',
    category: category,
    animalType: animal,
  );
});
