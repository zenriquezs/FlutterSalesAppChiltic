import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeaShopScreen extends StatelessWidget {
  const TeaShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Tropicales',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscas algo en especial',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return TeaCard(
                  discount: '-20%',
                  price: 12.50,
                  originalPrice: 15.50,
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TeaCard extends StatefulWidget {
  final String discount;
  final double price;
  final double originalPrice;
  final int index;

  const TeaCard({
    super.key,
    required this.discount,
    required this.price,
    required this.originalPrice,
    required this.index,
  });

  @override
  _TeaCardState createState() => _TeaCardState();
}

class _TeaCardState extends State<TeaCard> {
  final DatabaseReference _favoritesRef =
      FirebaseDatabase.instance.ref().child("favorites");
  bool isFavorite = false;

  final List<String> images = [
    'lib/assets/Coco_Limón.png',
    'lib/assets/Té de Guayaba y Fresa.png',
    'lib/assets/Té de Hibisco y Frutas Tropicales.png',
    'lib/assets/Té de Mango y Maracuyá.png',
    'lib/assets/Té de Papaya y Jengibre.png',
    'lib/assets/Té de Piña Colada.png',
    'lib/assets/Té de Piña y Menta.png',
    'lib/assets/Té de Plátano y Canela.png',
  ];

  final List<String> teaNames = [
    'Coco Limón',
    'Guayaba y Fresa',
    'Hibisco y Frutas Tropicales',
    'Mango y Maracuyá',
    'Papaya y Jengibre',
    'Piña Colada',
    'Piña y Menta',
    'Plátano y Canela',
  ];

  void _addToFavorites() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final String emailKey = currentUser.email!.replaceAll('.', ','); 

      _favoritesRef.child(emailKey).push().set({
        "name": teaNames[widget.index % teaNames.length],
        "price": widget.price,
        "image": images[widget.index % images.length],
      }).then((_) {
        setState(() {
          isFavorite = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "${teaNames[widget.index % teaNames.length]} añadido a favoritos"),
          ),
        );
      }).catchError((error) {
        print("Error al agregar a favoritos: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error al añadir a favoritos"),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, inicia sesión para agregar a favoritos"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: AssetImage(
                        images[widget.index % images.length],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teaNames[widget.index % teaNames.length],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '\$${widget.price}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '\$${widget.originalPrice}',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: _addToFavorites,
            ),
          ),
        ],
      ),
    );
  }
}
