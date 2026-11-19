import 'package:flutter_test/flutter_test.dart';
import 'package:latres_124240180/models/character_model.dart';
import 'package:latres_124240180/models/spell_model.dart';
import 'package:latres_124240180/services/auth_service.dart';

void main() {
  group('AuthService Tests', () {
    test('Valid credentials should pass', () {
      expect(AuthService.validateCredentials('admin', 'admin'), isTrue);
      expect(AuthService.validateCredentials('124240180', '124240180'), isTrue);
      expect(AuthService.validateCredentials('124240180', 'admin'), isTrue);
      expect(AuthService.validateCredentials('potter', 'gryffindor'), isTrue);
    });

    test('Invalid credentials should fail', () {
      expect(AuthService.validateCredentials('admin', 'wrongpass'), isFalse);
      expect(AuthService.validateCredentials('nonexistent', '123'), isFalse);
      expect(AuthService.validateCredentials('', ''), isFalse);
    });
  });

  group('Model Serialization Tests', () {
    test('Character.fromJson & toJson', () {
      final json = {
        'index': 1,
        'fullName': 'Hermione Granger',
        'nickname': 'Hermione',
        'hogwartsHouse': 'Gryffindor',
        'interpretedBy': 'Emma Watson',
        'children': ['Rose Granger-Weasley', 'Hugo Granger-Weasley'],
        'image': 'https://example.com/hermione.png',
        'birthdate': 'Sep 19, 1979',
      };

      final character = Character.fromJson(json);
      expect(character.fullName, 'Hermione Granger');
      expect(character.nickname, 'Hermione');
      expect(character.hogwartsHouse, 'Gryffindor');
      expect(character.interpretedBy, 'Emma Watson');
      expect(character.children.length, 2);
      expect(character.image, 'https://example.com/hermione.png');
      expect(character.birthdate, 'Sep 19, 1979');

      final serialized = character.toJson();
      expect(serialized['fullName'], 'Hermione Granger');
      expect(serialized['children'], ['Rose Granger-Weasley', 'Hugo Granger-Weasley']);
    });

    test('Spell.fromJson & toJson', () {
      final json = {
        'index': 0,
        'spell': 'Accio',
        'use': 'Summoning charm',
      };

      final spell = Spell.fromJson(json);
      expect(spell.index, 0);
      expect(spell.spell, 'Accio');
      expect(spell.use, 'Summoning charm');

      final serialized = spell.toJson();
      expect(serialized['spell'], 'Accio');
      expect(serialized['use'], 'Summoning charm');
    });
  });
}
