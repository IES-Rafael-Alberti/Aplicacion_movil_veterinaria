import 'package:flutter/material.dart';

import '../models/cart_model.dart';
import '../models/mock_data.dart';
import 'cart_screen.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StoreScreenBody();
  }
}

class _StoreScreenBody extends StatefulWidget {
  const _StoreScreenBody();

  @override
  State<_StoreScreenBody> createState() => _StoreScreenBodyState();
}

class _StoreScreenBodyState extends State<_StoreScreenBody> {
  ProductCategory? selectedCategory;
  AnimalType? selectedAnimalType;
  final CartModel cart = CartModel();

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products
        .where(
          (product) =>
              (selectedCategory == null || product.category == selectedCategory) &&
              (selectedAnimalType == null || product.animalType == selectedAnimalType),
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: Column(
          children: [
            _StoreHeader(
              itemCount: cart.items.fold<int>(0, (sum, item) => sum + item.quantity),
              onCartTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CartScreen(cart: cart)),
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StoreHero(productCount: filteredProducts.length),
                      const SizedBox(height: 24),
                      _FilterCard(
                        selectedCategory: selectedCategory,
                        selectedAnimalType: selectedAnimalType,
                        onCategoryChanged: (category) => setState(() => selectedCategory = category),
                        onAnimalChanged: (animal) => setState(() => selectedAnimalType = animal),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '${filteredProducts.length} productos disponibles',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final crossAxisCount = width >= 1100
                              ? 4
                              : width >= 800
                                  ? 3
                                  : width >= 520
                                      ? 2
                                      : 1;
                          final childAspectRatio = crossAxisCount == 1
                            ? 0.92
                            : crossAxisCount == 2
                              ? 0.66
                              : crossAxisCount == 3
                                ? 0.70
                                : 0.74;

                          if (filteredProducts.isEmpty) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                                ],
                              ),
                              child: const Text('No hay productos para esta selección.'),
                            );
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: childAspectRatio,
                            ),
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, i) {
                              final product = filteredProducts[i];
                              return _ProductCard(
                                product: product,
                                onAdd: () {
                                  setState(() {
                                    cart.addProduct(product);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${product.name} añadido al carrito'),
                                      duration: const Duration(milliseconds: 900),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreHeader extends StatelessWidget {
  final int itemCount;
  final VoidCallback onCartTap;

  const _StoreHeader({required this.itemCount, required this.onCartTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tienda de productos',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('Filtra por especie y categoría para encontrar lo que necesitas.'),
              ],
            ),
            const Spacer(),
            Stack(
              children: [
                IconButton(
                  iconSize: 28,
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: onCartTap,
                ),
                if (itemCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$itemCount',
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreHero extends StatelessWidget {
  final int productCount;

  const _StoreHero({required this.productCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1976D2), Color(0xFF64B5F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Catálogo amplio para todas las especies',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Más de 20 productos por categoría, organizados para perros, gatos, aves, conejos y otras especies.',
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: const [
                    _HeroChip(label: 'Alimento premium'),
                    _HeroChip(label: 'Juguetes'),
                    _HeroChip(label: 'Higiene'),
                    _HeroChip(label: 'Salud'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: Center(
              child: Text(
                '$productCount',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final String label;

  const _HeroChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.white.withValues(alpha: 0.18),
      side: BorderSide.none,
    );
  }
}

class _FilterCard extends StatelessWidget {
  final ProductCategory? selectedCategory;
  final AnimalType? selectedAnimalType;
  final ValueChanged<ProductCategory?> onCategoryChanged;
  final ValueChanged<AnimalType?> onAnimalChanged;

  const _FilterCard({
    required this.selectedCategory,
    required this.selectedAnimalType,
    required this.onCategoryChanged,
    required this.onAnimalChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 700;
          final categoryField = DropdownButtonFormField<ProductCategory?>(
            initialValue: selectedCategory,
            decoration: InputDecoration(
              labelText: 'Categoría',
              filled: true,
              fillColor: const Color(0xFFF8FAFD),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: [
              const DropdownMenuItem<ProductCategory?>(
                value: null,
                child: Text('Todas'),
              ),
              ...categories.map(
                (category) => DropdownMenuItem<ProductCategory?>(
                  value: category,
                  child: Text(category.name),
                ),
              ),
            ],
            onChanged: onCategoryChanged,
          );

          final animalField = DropdownButtonFormField<AnimalType?>(
            initialValue: selectedAnimalType,
            decoration: InputDecoration(
              labelText: 'Especie',
              filled: true,
              fillColor: const Color(0xFFF8FAFD),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: [
              const DropdownMenuItem<AnimalType?>(
                value: null,
                child: Text('Todas'),
              ),
              ...animalTypes.map(
                (animal) => DropdownMenuItem<AnimalType?>(
                  value: animal,
                  child: Text(animal.name),
                ),
              ),
            ],
            onChanged: onAnimalChanged,
          );

          if (wide) {
            return Row(
              children: [
                Expanded(child: categoryField),
                const SizedBox(width: 12),
                Expanded(child: animalField),
              ],
            );
          }

          return Column(
            children: [
              categoryField,
              const SizedBox(height: 12),
              animalField,
            ],
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const _ProductCard({required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onAdd,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: 1.35,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1976D2),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${product.category.name} · ${product.animalType.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 6),
              Text(
                product.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${product.price.toStringAsFixed(2)} €',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  const Spacer(),
                  FilledButton.tonalIcon(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Añadir'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
