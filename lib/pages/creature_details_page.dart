import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/creature.dart';
import '../services/creature_storage.dart';

class CreatureDetailsPage extends StatefulWidget {
  const CreatureDetailsPage({super.key, required this.creature});

  final Creature creature;

  @override
  State<CreatureDetailsPage> createState() => _CreatureDetailsPageState();
}

class _CreatureDetailsPageState extends State<CreatureDetailsPage> {
  Creature get creature => widget.creature;

  Future<void> copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم نسخ النص بنجاح'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> pickImage() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
    );

    if (result == null || result.files.single.path == null) {
      return;
    }

    final String selectedPath = result.files.single.path!;

    setState(() {
      creature.images.add(selectedPath);
    });

    await CreatureStorage.updateCreature(creature);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تمت إضافة الصورة بنجاح'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _persistChanges() async {
    await CreatureStorage.updateCreature(creature);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ التعديل بنجاح'),
        duration: Duration(seconds: 1),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final String pageTitle =
        creature.name.trim().isNotEmpty ? creature.name : 'تفاصيل المخلوق';

    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الصور',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      onPressed: pickImage,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: const Text('إضافة صورة'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (creature.images.isEmpty)
                    const Text('ما من صور الآن')
                  else
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: creature.images
                          .map(
                            (path) => GestureDetector(
                              onDoubleTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        FullScreenImagePage(imagePath: path),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(path),
                                  width: 220,
                                  height: 220,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Container(
                                    width: 220,
                                    height: 220,
                                    color: Colors.grey.shade900,
                                    alignment: Alignment.center,
                                    child: const Text('تعذر عرض الصورة'),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _ReadOnlyField(label: 'المعرّف', value: '${creature.id}'),
                  _EditableCreatureField(
                    label: 'الاسم',
                    value: creature.name,
                    onSave: (newValue) async {
                      creature.name = newValue;
                      await _persistChanges();
                    },
                  ),
                  _ReadOnlyField(
                    label: 'الكائنات المدموجة',
                    value: creature.animalsDescription,
                  ),
                  _EditableCreatureField(
                    label: 'المنشأ',
                    value: creature.origin,
                    onSave: (newValue) async {
                      creature.origin = newValue;
                      await _persistChanges();
                    },
                  ),
                  _EditableCreatureField(
                    label: 'الشخصية',
                    value: creature.personality,
                    onSave: (newValue) async {
                      creature.personality = newValue;
                      await _persistChanges();
                    },
                  ),
                  _EditableCreatureField(
                    label: 'الحجم',
                    value: '${creature.size}',
                    keyboardType: TextInputType.number,
                    onSave: (newValue) async {
                      final int? parsed = int.tryParse(newValue.trim());
                      if (parsed == null) {
                        return;
                      }
                      creature.size = parsed;
                      await _persistChanges();
                    },
                  ),
                  _ReadOnlyField(
                    label: 'عدد الرؤوس',
                    value: '${creature.headNumber}',
                  ),
                  _ReadOnlyField(
                    label: 'عدد العيون',
                    value: '${creature.eyeNumber}',
                  ),
                  _EditableCreatureField(
                    label: 'القامة',
                    value: creature.posture,
                    onSave: (newValue) async {
                      creature.posture = newValue;
                      await _persistChanges();
                    },
                  ),
                  _EditableCreatureField(
                    label: 'السرعة',
                    value: '${creature.speed}',
                    keyboardType: TextInputType.number,
                    onSave: (newValue) async {
                      final int? parsed = int.tryParse(newValue.trim());
                      if (parsed == null) {
                        return;
                      }
                      creature.speed = parsed;
                      await _persistChanges();
                    },
                  ),
                  _EditableCreatureField(
                    label: 'الهجوم',
                    value: '${creature.attackPower}',
                    keyboardType: TextInputType.number,
                    onSave: (newValue) async {
                      final int? parsed = int.tryParse(newValue.trim());
                      if (parsed == null) {
                        return;
                      }
                      creature.attackPower = parsed;
                      await _persistChanges();
                    },
                  ),
                  _EditableCreatureField(
                    label: 'الدفاع',
                    value: '${creature.defensePower}',
                    keyboardType: TextInputType.number,
                    onSave: (newValue) async {
                      final int? parsed = int.tryParse(newValue.trim());
                      if (parsed == null) {
                        return;
                      }
                      creature.defensePower = parsed;
                      await _persistChanges();
                    },
                  ),
                  _EditableCreatureField(
                    label: 'متانة الجسم',
                    value: '${creature.bodyHardness}',
                    keyboardType: TextInputType.number,
                    onSave: (newValue) async {
                      final int? parsed = int.tryParse(newValue.trim());
                      if (parsed == null) {
                        return;
                      }
                      creature.bodyHardness = parsed;
                      await _persistChanges();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'نصوص الذكاء الاصطناعي',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => copyText(creature.prePrompt),
                    child: const Text('نسخ ما قبل البرومبت'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => copyText(creature.prompt),
                    child: const Text('نسخ برومبت الصورة'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => copyText(creature.afterBuild),
                    child: const Text('نسخ ما بعد إنشاء الصورة'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  const FullScreenImagePage({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('عرض الصورة'),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 5,
          child: Image.file(File(imagePath)),
        ),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(label),
      subtitle: Text(value.isEmpty ? '-' : value),
    );
  }
}

class _EditableCreatureField extends StatefulWidget {
  const _EditableCreatureField({
    required this.label,
    required this.value,
    required this.onSave,
    this.keyboardType = TextInputType.text,
  });

  final String label;
  final String value;
  final TextInputType keyboardType;
  final Future<void> Function(String newValue) onSave;

  @override
  State<_EditableCreatureField> createState() => _EditableCreatureFieldState();
}

class _EditableCreatureFieldState extends State<_EditableCreatureField> {
  late TextEditingController _controller;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(covariant _EditableCreatureField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && oldWidget.value != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving) return;
    _isSaving = true;

    final String newValue = _controller.text;
    await widget.onSave(newValue);

    if (!mounted) return;
    setState(() {
      _isEditing = false;
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isEditing) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onDoubleTap: () {
          setState(() {
            _isEditing = true;
            _controller.selection = TextSelection(
              baseOffset: 0,
              extentOffset: _controller.text.length,
            );
          });
        },
        child: ListTile(
          dense: true,
          title: Text(widget.label),
          subtitle: Text(widget.value.isEmpty ? '-' : widget.value),
          trailing: const Icon(Icons.edit, size: 16),
        ),
      );
    }

    return ListTile(
      dense: true,
      title: Text(widget.label),
      subtitle: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus && _isEditing) {
            _save();
          }
        },
        child: TextField(
          controller: _controller,
          keyboardType: widget.keyboardType,
          autofocus: true,
          onSubmitted: (_) => _save(),
          decoration: InputDecoration(
            isDense: true,
            suffixIcon: IconButton(
              onPressed: _save,
              icon: const Icon(Icons.check),
            ),
          ),
        ),
      ),
    );
  }
}
