import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FloralProductsScreen extends StatelessWidget {
  const FloralProductsScreen({super.key});

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
          'Florales',
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
                return FloralCard(
                  discount: '-10%',
                  price: 8.50,
                  originalPrice: 10.00,
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

class FloralCard extends StatefulWidget {
  final String discount;
  final double price;
  final double originalPrice;
  final int index;

  const FloralCard({
    super.key,
    required this.discount,
    required this.price,
    required this.originalPrice,
    required this.index,
  });

  @override
  _FloralCardState createState() => _FloralCardState();
}

class _FloralCardState extends State<FloralCard> {
  final DatabaseReference _favoritesRef =
      FirebaseDatabase.instance.ref().child("favorites");

  bool isFavorite = false; 

  final List<String> images = [
    'lib/assets/TeFloral-1.png',
    'lib/assets/TeFloral-2.png',
    'lib/assets/TeFloral-3.png',
    'lib/assets/TeFloral-4.png',
    'lib/assets/TeFloral-5.png',
    'lib/assets/TeFloral-1.png',
  ];

  void _addToFavorites() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final String emailKey = currentUser.email!.replaceAll('.', ','); 

      _favoritesRef.child(emailKey).push().set({
        "name": "Producto Floral ${widget.index + 1}",
        "price": widget.price,
        "image": images[widget.index % images.length],
      }).then((_) {
        setState(() {
          isFavorite = true; 
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Producto Floral ${widget.index + 1} añadido a favoritos"),
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
                      'Producto Floral ${widget.index + 1}',
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
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                widget.discount,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
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
