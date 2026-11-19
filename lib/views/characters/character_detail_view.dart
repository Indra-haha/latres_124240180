import 'package:flutter/material.dart';
import '../../models/character_model.dart';

class CharacterDetailView extends StatelessWidget {
  final Character character;

  const CharacterDetailView({super.key, required this.character});

  Color _getHouseColor(String house) {
    switch (house.toLowerCase()) {
      case 'gryffindor':
        return const Color(0xFF740001);
      case 'slytherin':
        return const Color(0xFF1A472A);
      case 'ravenclaw':
        return const Color(0xFF0E1A40);
      case 'hufflepuff':
        return const Color(0xFFD49E00);
      default:
        return Colors.indigo.shade800;
    }
  }

  Color _getHouseAccent(String house) {
    switch (house.toLowerCase()) {
      case 'gryffindor':
        return const Color(0xFFD3A625);
      case 'slytherin':
        return const Color(0xFFAAAAAA);
      case 'ravenclaw':
        return const Color(0xFF946B2D);
      case 'hufflepuff':
        return const Color(0xFF222222);
      default:
        return Colors.amberAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final houseColor = _getHouseColor(character.hogwartsHouse);
    final houseAccent = _getHouseAccent(character.hogwartsHouse);

    return Scaffold(
      backgroundColor: const Color(0xFF141324),
      appBar: AppBar(
        title: Text(
          character.fullName.isNotEmpty ? character.fullName : 'Detail Karakter',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: houseColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Character Image Header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [houseColor, const Color(0xFF141324)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Container(
                  height: 220,
                  width: 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: houseAccent, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.6),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: character.image.isNotEmpty
                      ? Image.network(
                          character.image,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: const Color(0xFF23223A),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFFD3A625),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFF23223A),
                              child: const Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.white54,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: const Color(0xFF23223A),
                          child: const Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.white54,
                          ),
                        ),
                ),
              ),
            ),

            // Main Info Container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Full Name & Nickname Header
                  Center(
                    child: Column(
                      children: [
                        Text(
                          character.fullName.isNotEmpty ? character.fullName : '-',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (character.nickname.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            '"${character.nickname}"',
                            style: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFFD3A625),
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        // House Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: houseColor.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: houseAccent, width: 1.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.shield, color: houseAccent, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                character.hogwartsHouse.isNotEmpty
                                    ? character.hogwartsHouse
                                    : 'Unknown House',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    'Informasi Lengkap',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD3A625),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Divider(color: Colors.white24, height: 20),

                  // Property 1: Index
                  _buildPropertyCard(
                    icon: Icons.tag,
                    label: 'Index ID',
                    value: character.index.toString(),
                  ),

                  // Property 2: Full Name
                  _buildPropertyCard(
                    icon: Icons.badge,
                    label: 'Nama Lengkap',
                    value: character.fullName.isNotEmpty ? character.fullName : '-',
                  ),

                  // Property 3: Nickname
                  _buildPropertyCard(
                    icon: Icons.person_pin,
                    label: 'Nama Panggilan (Nickname)',
                    value: character.nickname.isNotEmpty ? character.nickname : '-',
                  ),

                  // Property 4: Hogwarts House
                  _buildPropertyCard(
                    icon: Icons.home,
                    label: 'Asrama Hogwarts',
                    value: character.hogwartsHouse.isNotEmpty ? character.hogwartsHouse : '-',
                  ),

                  // Property 5: Interpreted By / Actor
                  _buildPropertyCard(
                    icon: Icons.movie_creation,
                    label: 'Pemeran (Interpreted By)',
                    value: character.interpretedBy.isNotEmpty ? character.interpretedBy : '-',
                  ),

                  // Property 6: Birthdate
                  _buildPropertyCard(
                    icon: Icons.cake,
                    label: 'Tanggal Lahir',
                    value: character.birthdate.isNotEmpty ? character.birthdate : '-',
                  ),

                  // Property 7: Children
                  _buildChildrenCard(character.children),

                  // Property 8: Image URL
                  _buildPropertyCard(
                    icon: Icons.link,
                    label: 'URL Gambar',
                    value: character.image.isNotEmpty ? character.image : '-',
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1E33),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFD3A625).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFFD3A625), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildrenCard(List<String> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1E33),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFD3A625).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.family_restroom, color: Color(0xFFD3A625), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Anak (Children)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 6),
                if (children.isEmpty)
                  const Text(
                    'Tidak ada data anak',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white54,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                else
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: children.map((child) {
                      return Chip(
                        label: Text(
                          child,
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        backgroundColor: const Color(0xFF2A2845),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                        ),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
