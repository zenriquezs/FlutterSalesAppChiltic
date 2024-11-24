import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late DatabaseReference _favoritesRef;
  final TextEditingController _teaNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFavoritesRef();
  }

  void _initializeFavoritesRef() {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final String emailKey = currentUser.email!.replaceAll('.', ','); // Reemplaza '.' por ',' para Firebase
      _favoritesRef = FirebaseDatabase.instance.ref().child("favorites").child(emailKey);
    }
  }

  @override
  void dispose() {
    _teaNameController.dispose();
    super.dispose();
  }

  void _addFavorite(String teaName, String imageUrl) {
    if (teaName.isNotEmpty && imageUrl.isNotEmpty) {
      _favoritesRef.push().set({
        "name": teaName,
        "image": imageUrl, // Agrega la URL de la imagen al favorito
      });
      _teaNameController.clear();
    }
  }

  void _deleteFavorite(String key) {
    _favoritesRef.child(key).remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Favoritos"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _teaNameController,
                    decoration: InputDecoration(
                      labelText: "Agregar té a favoritos",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _addFavorite(
                    _teaNameController.text,
                    'lib/assets/sample_image.png', // Cambiar por la URL o ruta real de la imagen
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Agregar"),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder(
              stream: _favoritesRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.hasData &&
                    snapshot.data!.snapshot.value != null) {
                  final data = Map<String, dynamic>.from(
                      snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
                  final items = data.entries.toList();

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final key = items[index].key;
                      final value = items[index].value as Map<dynamic, dynamic>;
                      final teaName = value['name'] ?? '';
                      final imageUrl = value['image'] ?? ''; // Obtén la URL de la imagen

                      return ListTile(
                        leading: imageUrl.isNotEmpty
                            ? Image.asset(
                                imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.image_not_supported),
                        title: Text(teaName),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteFavorite(key),
                        ),
                      );
                    },
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const Center(
                    child: Text("No tienes favoritos aún"),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
