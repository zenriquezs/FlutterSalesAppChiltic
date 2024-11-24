import 'package:flutter/material.dart';

List<BottomNavigationBarItem> getBottomNavigationBarItems() {
  return const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Inicio',
      backgroundColor: Colors.green,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.category),
      label: 'Categorías',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Favoritos',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Perfil',
    ),
  ];
}
