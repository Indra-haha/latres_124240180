import 'package:flutter/material.dart';
import '../../models/character_model.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../login_view.dart';
import 'character_detail_view.dart';

class CharacterView extends StatefulWidget {
  const CharacterView({super.key});

  @override
  State<CharacterView> createState() => _CharacterViewState();
}

class _CharacterViewState extends State<CharacterView> {
  late Future<List<Character>> _charactersFuture;
  List<Character> _allCharacters = [];
  List<Character> _filteredCharacters = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedHouse = 'All';

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadCharacters() {
    setState(() {
      _charactersFuture = ApiService.getCharacters().then((characters) {
        _allCharacters = characters;
        _applyFilter();
        return characters;
      });
    });
  }

  void _applyFilter() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filteredCharacters = _allCharacters.where((character) {
        final matchesQuery = character.fullName.toLowerCase().contains(query) ||
            character.nickname.toLowerCase().contains(query) ||
            character.interpretedBy.toLowerCase().contains(query);

        final matchesHouse = _selectedHouse == 'All' ||
            character.hogwartsHouse.toLowerCase() ==
                _selectedHouse.toLowerCase();

        return matchesQuery && matchesHouse;
      }).toList();
    });
  }

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
        return Colors.indigo.shade900;
    }
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F1E33),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFD3A625), width: 1.2),
        ),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Color(0xFFD3A625)),
            SizedBox(width: 8),
            Text('Konfirmasi Logout', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari aplikasi?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD3A625),
              foregroundColor: const Color(0xFF1A1A2E),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      await AuthService.logout();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Berhasil logout'),
            ],
          ),
          backgroundColor: Colors.blueGrey.shade800,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginView()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141324),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.shield, color: Color(0xFFD3A625), size: 22),
            SizedBox(width: 10),
            Text(
              'Daftar Karakter',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1F1E33),
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Section
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            color: const Color(0xFF1A192E),
            child: Column(
              children: [
                // Search Field
                TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (_) => _applyFilter(),
                  decoration: InputDecoration(
                    hintText: 'Cari karakter atau pemeran...',
                    hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFFD3A625)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white54, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              _applyFilter();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFF26253F),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFD3A625)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // House Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      'All',
                      'Gryffindor',
                      'Slytherin',
                      'Ravenclaw',
                      'Hufflepuff',
                    ].map((house) {
                      final isSelected = _selectedHouse == house;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(house),
                          selected: isSelected,
                          selectedColor: const Color(0xFFD3A625),
                          backgroundColor: const Color(0xFF26253F),
                          labelStyle: TextStyle(
                            color: isSelected ? const Color(0xFF141324) : Colors.white70,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: isSelected ? const Color(0xFFD3A625) : Colors.white24,
                            ),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedHouse = house;
                                _applyFilter();
                              });
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Main Character List
          Expanded(
            child: FutureBuilder<List<Character>>(
              future: _charactersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFFD3A625)),
                        SizedBox(height: 16),
                        Text(
                          'Memuat data karakter...',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud_off, size: 64, color: Colors.redAccent),
                          const SizedBox(height: 16),
                          Text(
                            'Gagal memuat data:\n${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD3A625),
                              foregroundColor: const Color(0xFF141324),
                            ),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                            onPressed: _loadCharacters,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (_filteredCharacters.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada karakter yang cocok.',
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: const Color(0xFFD3A625),
                  backgroundColor: const Color(0xFF1F1E33),
                  onRefresh: () async {
                    _loadCharacters();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    itemCount: _filteredCharacters.length,
                    itemBuilder: (context, index) {
                      final character = _filteredCharacters[index];
                      final houseColor = _getHouseColor(character.hogwartsHouse);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: const Color(0xFF1F1E33),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        elevation: 3,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CharacterDetailView(character: character),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                // Character Thumbnail
                                Container(
                                  width: 65,
                                  height: 85,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: houseColor,
                                      width: 2,
                                    ),
                                    color: const Color(0xFF2A2845),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: character.image.isNotEmpty
                                      ? Image.network(
                                          character.image,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                              const Icon(Icons.person, color: Colors.white38),
                                        )
                                      : const Icon(Icons.person, color: Colors.white38),
                                ),
                                const SizedBox(width: 14),

                                // Character Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        character.fullName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (character.nickname.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          '"${character.nickname}"',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontStyle: FontStyle.italic,
                                            color: Color(0xFFD3A625),
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 6),
                                      // House Badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: houseColor.withValues(alpha: 0.3),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                            color: houseColor,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          character.hogwartsHouse.isNotEmpty
                                              ? character.hogwartsHouse
                                              : 'Unknown',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      if (character.interpretedBy.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          'Aktor: ${character.interpretedBy}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white54,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                // Chevron Arrow
                                const Icon(
                                  Icons.chevron_right,
                                  color: Color(0xFFD3A625),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
