import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/creature.dart';

class CreatureStorage {
  static const String _folderName = 'fajr_jadied_creatures';
  static const String _fileName = 'creatures.json';

  static Future<File> _getCreaturesFile() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final Directory appDirectory =
        Directory('${documentsDirectory.path}${Platform.pathSeparator}$_folderName');

    if (!await appDirectory.exists()) {
      await appDirectory.create(recursive: true);
    }

    final File file =
        File('${appDirectory.path}${Platform.pathSeparator}$_fileName');

    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString('[]');
    }

    return file;
  }

  static Future<List<Creature>> loadCreatures() async {
    try {
      final File file = await _getCreaturesFile();
      final String content = await file.readAsString();

      if (content.trim().isEmpty) {
        return [];
      }

      final dynamic decoded = jsonDecode(content);
      if (decoded is! List) {
        return [];
      }

      return decoded
          .whereType<Map>()
          .map((item) => Creature.fromMap(Map<String, dynamic>.from(item)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveCreatures(List<Creature> creatures) async {
    final File file = await _getCreaturesFile();
    final List<Map<String, dynamic>> asMapList =
        creatures.map((creature) => creature.toMap()).toList();

    await file.writeAsString(jsonEncode(asMapList));
  }

  static Future<void> addCreature(Creature creature) async {
    final List<Creature> creatures = await loadCreatures();
    creatures.add(creature);
    await saveCreatures(creatures);
  }

  static Future<void> updateCreature(Creature updatedCreature) async {
    final List<Creature> creatures = await loadCreatures();
    final int index = creatures.indexWhere((c) => c.id == updatedCreature.id);

    if (index == -1) {
      return;
    }

    creatures[index] = updatedCreature;
    await saveCreatures(creatures);
  }

  static Future<void> deleteCreature(int creatureId) async {
    final List<Creature> creatures = await loadCreatures();
    creatures.removeWhere((creature) => creature.id == creatureId);
    await saveCreatures(creatures);
  }
}
