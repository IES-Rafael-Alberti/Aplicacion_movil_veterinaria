import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopNav(
              onStore: () => Navigator.pushNamed(context, '/store'),
              onAppointment: () => Navigator.pushNamed(context, '/appointment'),
              onAdoption: () => Navigator.pushNamed(context, '/adoption'),
              onOrders: () => Navigator.pushNamed(context, '/orders'),
              onFichas: () => Navigator.pushNamed(context, '/fichas'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroBanner(
                    onShop: () => Navigator.pushNamed(context, '/store'),
                    onAppointment: () => Navigator.pushNamed(context, '/appointment'),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Accesos rápidos',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _ServicesGrid(
                    onAdopt: () => Navigator.pushNamed(context, '/adoption'),
                    onOrders: () => Navigator.pushNamed(context, '/orders'),
                    onFichas: () => Navigator.pushNamed(context, '/fichas'),
                    onStore: () => Navigator.pushNamed(context, '/store'),
                    onAppointment: () => Navigator.pushNamed(context, '/appointment'),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Nuestra Historia',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const _HistoryTimeline(),
                  const SizedBox(height: 28),
                  const Text(
                    'Testimonios',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const _Testimonials(),
                  const SizedBox(height: 48),
                  Center(
                    child: Text(
                      '© ${DateTime.now().year} Clínica Veterinaria — Cuidando vidas',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopNav extends StatelessWidget {
  final VoidCallback onStore;
  final VoidCallback onAppointment;
  final VoidCallback onAdoption;
  final VoidCallback onOrders;
  final VoidCallback onFichas;

  const _TopNav({
    required this.onStore,
    required this.onAppointment,
    required this.onAdoption,
    required this.onOrders,
    required this.onFichas,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 900;
              final navButtons = [
                _NavButton(label: 'Tienda', onTap: onStore),
                _NavButton(label: 'Citas', onTap: onAppointment),
                _NavButton(label: 'Adopciones', onTap: onAdoption),
                _NavButton(label: 'Pedidos', onTap: onOrders),
                _NavButton(label: 'Fichas', onTap: onFichas),
              ];

              return Row(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'https://picsum.photos/seed/logo/64/64',
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Clínica Veterinaria',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (wide)
                    Wrap(
                      spacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        ...navButtons,
                        ElevatedButton(
                          onPressed: onStore,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1976D2),
                          ),
                          child: const Text('Tienda'),
                        ),
                      ],
                    )
                  else
                    PopupMenuButton<int>(
                      icon: const Icon(Icons.menu),
                      onSelected: (value) {
                        switch (value) {
                          case 0:
                            onStore();
                            break;
                          case 1:
                            onAppointment();
                            break;
                          case 2:
                            onAdoption();
                            break;
                          case 3:
                            onOrders();
                            break;
                          case 4:
                            onFichas();
                            break;
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 0, child: Text('Tienda')),
                        PopupMenuItem(value: 1, child: Text('Citas')),
                        PopupMenuItem(value: 2, child: Text('Adopciones')),
                        PopupMenuItem(value: 3, child: Text('Pedidos')),
                        PopupMenuItem(value: 4, child: Text('Fichas')),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NavButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(label, style: const TextStyle(color: Colors.black87)),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  final VoidCallback onShop;
  final VoidCallback onAppointment;

  const _HeroBanner({required this.onShop, required this.onAppointment});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;

        final content = Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cuidamos a tu familia peluda',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Servicios integrales: medicina, cirugía, cuidados preventivos y adopciones responsables.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: onAppointment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                    ),
                    child: const Text('Pedir cita'),
                  ),
                  OutlinedButton(
                    onPressed: onShop,
                    child: const Text('Ver tienda'),
                  ),
                ],
              ),
            ],
          ),
        );

        final image = ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            'https://picsum.photos/seed/clinic/900/700',
            height: wide ? 280 : 190,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        );

        if (wide) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6)),
              ],
            ),
            child: Row(
              children: [
                Expanded(flex: 6, child: content),
                Expanded(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Image.network(
                      'https://picsum.photos/seed/clinic/900/700',
                      height: 280,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            content,
            const SizedBox(height: 12),
            image,
          ],
        );
      },
    );
  }
}

class _ServicesGrid extends StatelessWidget {
  final VoidCallback onAdopt;
  final VoidCallback onOrders;
  final VoidCallback onFichas;
  final VoidCallback onStore;
  final VoidCallback onAppointment;

  const _ServicesGrid({
    required this.onAdopt,
    required this.onOrders,
    required this.onFichas,
    required this.onStore,
    required this.onAppointment,
  });

  @override
  Widget build(BuildContext context) {
    final cards = [
      _ServiceCard(
        icon: Icons.local_hospital,
        title: 'Citas',
        subtitle: 'Pide una consulta veterinaria en segundos',
        actionLabel: 'Abrir',
        onAction: onAppointment,
      ),
      _ServiceCard(
        icon: Icons.pets,
        title: 'Adopciones',
        subtitle: 'Conoce mascotas con vacunas y estado sanitario',
        actionLabel: 'Ver',
        onAction: onAdopt,
      ),
      _ServiceCard(
        icon: Icons.receipt_long,
        title: 'Tus pedidos',
        subtitle: 'Consulta compras, tickets y seguimiento',
        actionLabel: 'Abrir',
        onAction: onOrders,
      ),
      _ServiceCard(
        icon: Icons.badge,
        title: 'Fichas',
        subtitle: 'Revisiones, vacunas y control de tus animales',
        actionLabel: 'Ver',
        onAction: onFichas,
      ),
      _ServiceCard(
        icon: Icons.shop,
        title: 'Tienda',
        subtitle: 'Más de 20 productos por categoría y especie',
        actionLabel: 'Ir',
        onAction: onStore,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width >= 1100) {
          return Row(
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 12),
              Expanded(child: cards[1]),
              const SizedBox(width: 12),
              Expanded(child: cards[2]),
              const SizedBox(width: 12),
              Expanded(child: cards[3]),
              const SizedBox(width: 12),
              Expanded(child: cards[4]),
            ],
          );
        }

        if (width >= 700) {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(width: (width - 12) / 2, child: cards[0]),
              SizedBox(width: (width - 12) / 2, child: cards[1]),
              SizedBox(width: (width - 12) / 2, child: cards[2]),
              SizedBox(width: (width - 12) / 2, child: cards[3]),
              SizedBox(width: width, child: cards[4]),
            ],
          );
        }

        return Column(
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              cards[i],
              if (i != cards.length - 1) const SizedBox(height: 12),
            ],
          ],
        );
      },
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 36, color: const Color(0xFF1976D2)),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 8),
          if (actionLabel != null && onAction != null)
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ),
        ],
      ),
    );
  }
}

class _HistoryTimeline extends StatelessWidget {
  const _HistoryTimeline();

  @override
  Widget build(BuildContext context) {
    const events = [
      {'year': '2003', 'title': 'Fundación', 'text': 'Nace la clínica con una misión centrada en el cuidado integral.'},
      {'year': '2008', 'title': 'Primer quirófano', 'text': 'Inauguramos nuestro primer quirófano equipado.'},
      {'year': '2013', 'title': 'Programa de adopciones', 'text': 'Iniciamos el programa de adopciones responsable.'},
      {'year': '2018', 'title': 'Expansión', 'text': 'Abrimos una segunda sede y ampliamos servicios.'},
      {'year': '2022', 'title': 'Telemedicina', 'text': 'Lanzamos consultas virtuales para seguimiento.'},
      {'year': '2024', 'title': 'Tienda digital', 'text': 'Integramos catálogo, pedidos y fichas de animales.'},
    ];

    return Column(
      children: [
        for (final event in events) ...[
          _TimelineItem(
            year: event['year']!,
            title: event['title']!,
            text: event['text']!,
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String year;
  final String title;
  final String text;

  const _TimelineItem({
    required this.year,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                color: Color(0xFF1976D2),
                shape: BoxShape.circle,
              ),
            ),
            Container(width: 2, height: 78, color: Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  year,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(text, style: const TextStyle(color: Colors.black87)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Testimonials extends StatelessWidget {
  const _Testimonials();

  @override
  Widget build(BuildContext context) {
    const items = [
      {'name': 'María', 'text': 'Gracias por cuidar a mi perro como a uno más de la familia.'},
      {'name': 'Javier', 'text': 'Profesionales y amables; muy recomendados.'},
      {'name': 'Lucía', 'text': 'El servicio de adopciones cambió mi vida.'},
    ];

    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item['text']!, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 12),
                Text(
                  '- ${item['name']!}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
