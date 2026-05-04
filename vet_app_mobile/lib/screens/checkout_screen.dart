import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class CheckoutScreen extends StatelessWidget {
  final CartModel cart;
  const CheckoutScreen({required this.cart, super.key});

  final _formKey = GlobalKey<FormState>();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final postalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        title: const Text('Confirmar pedido', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Dirección de envío', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Dirección'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Introduce la dirección';
                  if (v.trim().length < 5) return 'La dirección es demasiado corta';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'Ciudad'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Introduce la ciudad';
                  if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ ]{2,}$').hasMatch(v.trim())) return 'Introduce un nombre de ciudad válido';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: postalController,
                decoration: const InputDecoration(labelText: 'Código postal'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Introduce el código postal';
                  if (!RegExp(r'^[0-9]{5}$').hasMatch(v.trim())) return 'El código postal debe tener 5 dígitos';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text('Resumen del pedido', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, i) {
                    final item = cart.items[i];
                    return ListTile(
                      leading: Image.network(item.product.imageUrl, width: 40, height: 40, fit: BoxFit.cover),
                      title: Text(item.product.name),
                      subtitle: Text('Cantidad: ${item.quantity}'),
                      trailing: Text('${(item.product.price * item.quantity).toStringAsFixed(2)} €'),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('${cart.total.toStringAsFixed(2)} €', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1976D2))),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('¡Pedido realizado!'),
                          content: TicketWidget(
                            address: addressController.text,
                            city: cityController.text,
                            postal: postalController.text,
                            cart: cart,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                cart.clear();
                              },
                              child: const Text('Aceptar'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Confirmar pedido', style: TextStyle(fontSize: 17, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TicketWidget extends StatelessWidget {
  final String address;
  final String city;
  final String postal;
  final CartModel cart;
  const TicketWidget({required this.address, required this.city, required this.postal, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('¡Tu pedido ha sido confirmado y está en proceso de envío!'),
        const SizedBox(height: 12),
        Text('Dirección de envío:', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('$address, $city, $postal'),
        const SizedBox(height: 12),
        const Text('Productos:', style: TextStyle(fontWeight: FontWeight.bold)),
        ...cart.items.map((item) => Text('${item.product.name} x${item.quantity} - ${(item.product.price * item.quantity).toStringAsFixed(2)} €')),
        const SizedBox(height: 8),
        Text('Total: ${cart.total.toStringAsFixed(2)} €', style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
