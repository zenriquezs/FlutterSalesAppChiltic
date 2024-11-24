import 'dart:async';
import 'package:flutter/material.dart';
import 'tropical_products.dart';
import 'spicy_products.dart';
import 'citrus_products.dart';
import 'floral_products.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Text(
          'Categorías',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              categorySection(
                context,
                title: 'Tropicales',
                images: [
                  'lib/assets/Coco_Limón.png',
                  'lib/assets/Té de Guayaba y Fresa.png',
                  'lib/assets/Té de Hibisco y Frutas Tropicales.png',
                  'lib/assets/Té de Mango y Maracuyá.png',
                  'lib/assets/Té de Papaya y Jengibre.png',
                ],
                onViewMore: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TeaShopScreen()),
                  );
                },
              ),
              categorySection(
                context,
                title: 'Especias',
                images: [
                  'lib/assets/TeEspecies-2.png',
                  'lib/assets/TeEspecies-3.png',
                  'lib/assets/TeEspecies-4.png',
                  'lib/assets/TeEspecies-5.png',
                  'lib/assets/TeEspecies-1.png',
                ],
                onViewMore: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SpicyProductsScreen()),
                  );
                },
              ),
              categorySection(
                context,
                title: 'Cítricos',
                images: [
                  'lib/assets/TeCitricos-1.png',
                  'lib/assets/TeCitricos-2.png',
                  'lib/assets/TeCitricos-3.png',
                  'lib/assets/TeCitricos-4.png',
                  'lib/assets/TeCitricos-5.png',
                ],
                onViewMore: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CitrusProductsScreen()),
                  );
                },
              ),
              categorySection(
                context,
                title: 'Florales',
                images: [
                  'lib/assets/TeFloral-1.png',
                  'lib/assets/TeFloral-2.png',
                  'lib/assets/TeFloral-3.png',
                  'lib/assets/TeFloral-4.png',
                  'lib/assets/TeFloral-5.png',
                ],
                onViewMore: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FloralProductsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),      
    );
  }

  Widget categorySection(
    BuildContext context, {
    required String title,
    required List<String> images,
    required VoidCallback onViewMore,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: onViewMore,
              child: const Text(
                'Ver más',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Carousel(images: images),
        const SizedBox(height: 16),
      ],
    );
  }
}

class Carousel extends StatefulWidget {
  final List<String> images;

  const Carousel({super.key, required this.images});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.images.length * 1,
      viewportFraction: 0.75,
    );

    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      _currentIndex++;
      if (mounted) {
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final imageIndex = index % widget.images.length;
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 1.0;
              if (_pageController.position.haveDimensions) {
                value = _pageController.page! - index;
                value = (1 - (value.abs() * 0.2)).clamp(0.8, 1.0);
              }

              return Center(
                child: SizedBox(
                  height: Curves.easeInOut.transform(value) * 130,
                  width: Curves.easeInOut.transform(value) * 280,
                  child: child,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(widget.images[imageIndex]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
