import 'dart:io';

import 'package:flutter/material.dart';

import 'models/creature.dart';
import 'pages/creature_details_page.dart';
import 'services/creature_storage.dart';

void main() {
  runApp(const CreaturePromptApp());
}

class CreaturePromptApp extends StatelessWidget {
  const CreaturePromptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'منشئ مخلوقات فجر جديد',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Creature? currentCreature;
  List<Creature> savedCreatures = [];

  @override
  void initState() {
    super.initState();
    loadSavedCreatures();
  }

  Future<void> loadSavedCreatures() async {
    final creatures = await CreatureStorage.loadCreatures();

    if (!mounted) return;

    setState(() {
      savedCreatures = creatures;
    });
  }

  String getCreatureDisplayName(Creature creature) {
    if (creature.name.trim().isNotEmpty) {
      return creature.name;
    }

    return 'مخلوق #${creature.id}';
  }

  Widget creatureThumbnail(Creature creature) {
    const double size = 54;

    Widget placeholder(IconData icon) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.25),
          ),
        ),
        child: Icon(
          icon,
          color: Colors.grey.shade500,
        ),
      );
    }

    if (creature.images.isEmpty) {
      return placeholder(Icons.image_not_supported_outlined);
    }

    final String imagePath = creature.images.first;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(
        File(imagePath),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return placeholder(Icons.broken_image_outlined);
        },
      ),
    );
  }

  String creatureStatsText(Creature creature) {
    return 'السرعة: ${creature.speed} | الهجوم: ${creature.attackPower} | الدفاع: ${creature.defensePower} | المتانة: ${creature.bodyHardness}';
  }

  Future<void> createCreature() async {
    final newCreature = Creature.buildNewCreature();

    await CreatureStorage.addCreature(newCreature);

    setState(() {
      currentCreature = newCreature;
    });

    await loadSavedCreatures();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إنشاء وحفظ المخلوق بنجاح'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> deleteCreature(Creature creature) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('حذف المخلوق'),
          content: const Text(
            'هل أنت متأكد أنك تريد حذف هذا المخلوق نهائيًا؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    await CreatureStorage.deleteCreature(creature.id);

    if (!mounted) return;

    setState(() {
      if (currentCreature?.id == creature.id) {
        currentCreature = null;
      }
    });

    await loadSavedCreatures();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حذف المخلوق بنجاح'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final creature = currentCreature;

    return Scaffold(
      appBar: AppBar(
        title: const Text('منشئ مخلوقات فجر جديد'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: createCreature,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('إنشاء مخلوق'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                ),

                const SizedBox(height: 24),

                if (creature == null)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'اضغط على Create Creature لإنشاء مخلوق جديد',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'معرّف المخلوق: ${creature.id}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text('الحيوانات والنسب: ${creature.animals}'),
                                  Text('المنشأ: ${creature.origin}'),
                                  Text('الشخصية: ${creature.personality}'),
                                  Text('الحجم: ${creature.size} سم'),
                                  Text('عدد الرؤوس: ${creature.headNumber}'),
                                  Text('عدد العيون: ${creature.eyeNumber}'),
                                  Text('القامة: ${creature.posture}'),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                const Text(
                  'المخلوقات المحفوظة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  height: 220,
                  child: Card(
                    child: savedCreatures.isEmpty
                        ? const Center(
                            child: Text('لا توجد مخلوقات محفوظة بعد'),
                          )
                        : ListView.separated(
                            itemCount: savedCreatures.length,
                            separatorBuilder: (_, _) => const Divider(
                              height: 1,
                            ),
                            itemBuilder: (context, index) {
                              final creatureItem = savedCreatures[index];

                              return ListTile(
                                leading: creatureThumbnail(creatureItem),
                                title: Text(
                                  getCreatureDisplayName(creatureItem),
                                ),
                                subtitle: Text(creatureStatsText(creatureItem)),
                                trailing: IconButton(
                                  onPressed: () => deleteCreature(creatureItem),
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  tooltip: 'حذف',
                                ),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CreatureDetailsPage(
                                        creature: creatureItem,
                                      ),
                                    ),
                                  );

                                  await loadSavedCreatures();
                                },
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}