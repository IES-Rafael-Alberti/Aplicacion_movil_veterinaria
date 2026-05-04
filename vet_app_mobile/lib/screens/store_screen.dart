
import 'package:flutter/material.dart';
import '../models/mock_data.dart';
import '../models/cart_model.dart';
import 'cart_screen.dart';

class StoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _StoreScreenBody();
  }
}

class _StoreScreenBody extends StatefulWidget {
  @override
  State<_StoreScreenBody> createState() => _StoreScreenBodyState();
}

class _StoreScreenBodyState extends State<_StoreScreenBody> {
  ProductCategory? selectedCategory;
  AnimalType? selectedAnimalType;
  final CartModel cart = CartModel();

  @override
  void initState() {
    super.initState();
    selectedCategory = categories.first;
    selectedAnimalType = animalTypes.first;
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((p) =>
      (selectedCategory == null || p.category == selectedCategory) &&
      (selectedAnimalType == null || p.animalType == selectedAnimalType)
    ).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        title: const Text('Tienda de productos', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartScreen(cart: cart)),
                  );
                },
              ),
              if (cart.items.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cart.items.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<ProductCategory>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Categoría',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: categories.map((cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(cat.name),
                    )).toList(),
                    onChanged: (cat) => setState(() => selectedCategory = cat),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<AnimalType>(
                    value: selectedAnimalType,
                    decoration: InputDecoration(
                      labelText: 'Tipo de animal',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: animalTypes.map((a) => DropdownMenuItem(
                      value: a,
                      child: Text(a.name),
                    )).toList(),
                    onChanged: (a) => setState(() => selectedAnimalType = a),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredProducts.isEmpty
                  ? Center(child: Text('No hay productos para esta selección.'))
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, i) {
                        final p = filteredProducts[i];
                        return _ProductCard(
                          product: p,
                          onAdd: () {
                            setState(() {
                              cart.addProduct(p);
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
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
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.imageUrl,
                  height: 80,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1976D2)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                product.category.name + ' - ' + product.animalType.name,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                product.description,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${product.price.toStringAsFixed(2)} €',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1976D2)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart, color: Color(0xFF1976D2)),
                    onPressed: onAdd,
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
}
