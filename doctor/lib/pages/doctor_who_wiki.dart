import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class DoctorWhoWikiApp extends StatelessWidget {
  const DoctorWhoWikiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DoctorWhoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DoctorWhoScreen extends StatefulWidget {
  const DoctorWhoScreen({super.key});

  @override
  State<DoctorWhoScreen> createState() => _DoctorWhoScreenState();
}

class _DoctorWhoScreenState extends State<DoctorWhoScreen> {
  List<dynamic> characterList = [];
  List<dynamic> filteredCharacterList = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCharacters();
  }

  Future<void> loadCharacters() async {
    final jsonString = await rootBundle.loadString('assets/characters.json');
    final data = jsonDecode(jsonString) as List;
    setState(() {
      characterList = data;
      filteredCharacterList = data;
    });
  }

  void filterCharacters(String query) {
    setState(() {
      filteredCharacterList = characterList
          .where((c) =>
              c['name'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: const Text(
          'Doctor Who Wiki',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          // 🔍 Campo de pesquisa
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar Personagem...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: filterCharacters,
            ),
          ),
          // 🔥 Grid de personagens
          Expanded(
            child: filteredCharacterList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: filteredCharacterList.length,
                    itemBuilder: (context, index) {
                      final character = filteredCharacterList[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CharacterDetailScreen(character: character),
                          ),
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: Colors.indigo.shade200,
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  character['imageUrl'],
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  character['name'].toString().toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class CharacterDetailScreen extends StatelessWidget {
  final dynamic character;
  const CharacterDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        title: Text(
          character['name'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🖼️ Imagem
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: character['imageUrl'] != null &&
                            character['imageUrl'] != ''
                        ? Image.network(
                            character['imageUrl'],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.image_not_supported,
                              size: 100,
                              color: Colors.indigo,
                            ),
                          )
                        : const Icon(
                            Icons.image_not_supported,
                            size: 100,
                            color: Colors.indigo,
                          ),
                  ),
                  const SizedBox(height: 16),
                  // ✏️ Nome
                  Text(
                    character['name'],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  // 🧬 Espécie
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.category, color: Colors.indigo),
                      const SizedBox(width: 8),
                      Text(
                        character['species'].isEmpty
                            ? "Desconhecida"
                            : character['species'],
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 📜 Primeira aparição
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.movie, color: Colors.indigo),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          character['first_appearance'].isEmpty
                              ? "Desconhecida"
                              : character['first_appearance'],
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
