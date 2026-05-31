import 'dart:math';

import 'package:monester/data/animals.dart';
import 'package:monester/data/body.dart';
import 'package:monester/data/insects.dart';
import 'package:monester/data/origen.dart';
import 'package:monester/data/personality.dart';

class Creature {
  final int id;

  String name;

  /// مثال:
  /// {
  ///   "كلب": 30,
  ///   "أفعى": 40,
  ///   "صرصور": 30,
  /// }
  final Map<String, int> animals;

  String origin;
  String personality;
  int size;
  int headNumber;
  int eyeNumber;
  String posture;
  List<String> images;

  int speed;
  int attackPower;
  int defensePower;
  int bodyHardness;

  Creature({
    required this.id,
    this.name = '',
    required this.animals,
    required this.origin,
    required this.personality,
    required this.size,
    required this.headNumber,
    required this.eyeNumber,
    required this.posture,
    List<String>? images,
    this.speed = 0,
    this.attackPower = 0,
    this.defensePower = 0,
    this.bodyHardness = 0,
  }) : images = images ?? <String>[];

  factory Creature.fromMap(Map<String, dynamic> map) {
    return Creature(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      animals: Map<String, int>.from(map['animals'] ?? {}),
      origin: map['origin'] ?? '',
      personality: map['personality'] ?? '',
      size: map['size'] ?? 0,
      headNumber: map['headNumber'] ?? 0,
      eyeNumber: map['eyeNumber'] ?? 0,
      posture: map['posture'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      speed: map['speed'] ?? 0,
      attackPower: map['attackPower'] ?? 0,
      defensePower: map['defensePower'] ?? 0,
      bodyHardness: map['bodyHardness'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'animals': animals,
      'origin': origin,
      'personality': personality,
      'size': size,
      'headNumber': headNumber,
      'eyeNumber': eyeNumber,
      'posture': posture,
      'images': images,
      'speed': speed,
      'attackPower': attackPower,
      'defensePower': defensePower,
      'bodyHardness': bodyHardness,
    };
  }

  static Creature buildNewCreature() {
    final random = Random();

    /// 50% يختار مخلوقين، و50% يختار ثلاثة مخلوقات
    final int creaturesCount = random.nextBool() ? 2 : 3;

    /// دمج قائمة الحيوانات وقائمة الحشرات
    final List<String> allCreatures = [
      ...allAnimals,
      ...insects,
    ]..shuffle(random);

    /// اختيار أول عنصرين أو ثلاثة بعد الخلط
    final List<String> selectedCreatures =
        allCreatures.take(creaturesCount).toList();

    /// إنشاء نسب عشوائية مجموعها 100
    final Map<String, int> animalsWithPercentages =
        _generateRandomPercentages(selectedCreatures, random);

    /// خلط القوائم ثم اختيار أول عنصر
    final List<String> shuffledOrigins = [...creatureOrigins]..shuffle(random);
    final List<String> shuffledPersonalities = [...creaturePersonalityTraits]
      ..shuffle(random);
    final List<int> shuffledSizes = [...sizes]..shuffle(random);
    final List<int> shuffledHeadNumbers = [...headNumbers]..shuffle(random);
    final List<int> shuffledEyeNumbers = [...eyeNumbers]..shuffle(random);
    final List<String> shuffledPostures = [...creaturePostures]
      ..shuffle(random);

    return Creature(
      id: DateTime.now().millisecondsSinceEpoch, // ID فريد بناءً على الوقت الحالي
      name: '',
      animals: animalsWithPercentages,
      origin: shuffledOrigins.first,
      personality: shuffledPersonalities.first,
      size: shuffledSizes.first,
      headNumber: shuffledHeadNumbers.first,
      eyeNumber: shuffledEyeNumbers.first,
      posture: shuffledPostures.first,

      /// القيم المبدئية، سيتم تعديلها لاحقًا
      speed: 0,
      attackPower: 0,
      defensePower: 0,
      bodyHardness: 0,
    );
  }

  static Map<String, int> _generateRandomPercentages(
    List<String> selectedCreatures,
    Random random,
  ) {
    if (selectedCreatures.length == 2) {
      final int firstPercentage = random.nextInt(81) + 10;
      final int secondPercentage = 100 - firstPercentage;

      return {
        selectedCreatures[0]: firstPercentage,
        selectedCreatures[1]: secondPercentage,
      };
    }

    if (selectedCreatures.length == 3) {
      final int firstPercentage = random.nextInt(61) + 10;
      final int secondPercentage = random.nextInt(91 - firstPercentage) + 5;
      final int thirdPercentage = 100 - firstPercentage - secondPercentage;

      return {
        selectedCreatures[0]: firstPercentage,
        selectedCreatures[1]: secondPercentage,
        selectedCreatures[2]: thirdPercentage,
      };
    }

    throw Exception('عدد المخلوقات المختارة يجب أن يكون 2 أو 3 فقط');
  }

String get animalsDescription {
  return animals.entries
      .map((entry) => '${entry.value}% ${entry.key}')
      .join('، ');
}

String get animalsNamesOnly {
  return animals.keys.join('، ');
}

String get prePrompt {
  return '''
أريد منك أولاً أن تراجع وتفهم جيداً الصفات البصرية والتشريحية للكائنات التالية:

$animalsNamesOnly

المطلوب الآن ليس إنشاء صورة، وليس كتابة برومبت نهائي، وليس تخيّل مخلوق جديد مباشرة.

المطلوب فقط:
- اجمع معلومات بصرية وتشريحية عن كل كائن من هذه الكائنات.
- راجع شكل الجسم، الرأس، العيون، الفم، الأطراف، الجلد أو الفرو أو الحراشف أو الغطاء الخارجي.
- انتبه لطريقة الوقوف والحركة والبنية العامة لكل كائن.
- راجع الصور والمراجع البصرية المتاحة لهذه الكائنات إن أمكن.
- افهم كيف يمكن أن تظهر صفات كل كائن بصرياً عند دمجه مع كائنات أخرى.

بعد ذلك توقّف، ولا تنشئ صورة الآن.
فقط استعد للمرحلة التالية، حيث سأرسل لك برومبت تصميم مخلوق خيالي واقعي مدمج من هذه الكائنات.
''';
}

String get prompt {
  return '''
أنشئ صورة واقعية جداً لمخلوق خيالي مدمج من الكائنات التالية بالنسب الآتية:

$animalsDescription

بيانات المخلوق:
- المنشأ أو الطبيعة المادية: $origin.
- الشخصية والطابع النفسي: $personality.
- الحجم التقريبي: $size سنتيمتر.
- عدد الرؤوس: $headNumber.
- عدد العيون: $eyeNumber.
- القامة وطريقة الوقوف: $posture.

المطلوب:
صمّم مخلوقاً خيالياً يبدو واقعياً قدر الإمكان، كأنه كائن حي حقيقي يمكن أن يوجد في عالم واقعي أو في فيلم سينمائي واقعي.

يجب أن يظهر تأثير كل كائن من الكائنات المدموجة حسب نسبته تقريباً، بحيث تكون النسبة الأعلى أكثر وضوحاً في شكل الجسم والبنية العامة، والنسب الأقل تظهر كتفاصيل مساعدة في الجلد، الأطراف، الرأس، العيون، الفم، الذيل، الحراشف، الفرو، الأجنحة، القرون، المخالب، أو أي عناصر مناسبة.

اجعل المنشأ "$origin" ظاهراً في خامة الجسد أو لونه أو تأثيره العام، لكن دون أن يطغى على هوية الكائنات الأصلية.

اجعل الشخصية "$personality" واضحة في تعابير الوجه، وضعية الجسد، نظرة العينين، وطريقة الحضور العام للمخلوق.

يجب أن تكون النتيجة:
- واقعية جداً.
- متناسقة تشريحياً وبصرياً.
- غير كرتونية.
- غير طفولية.
- غير عشوائية.
- غير مشوّهة.
- مناسبة لعالم خيالي مشوّق في فيديو درامي عائلي.
- فيها تفاصيل كافية تجعل المخلوق مميزاً وقابلاً للتذكر.

اجعل المخلوق في لقطة كاملة للجسم، واضحاً من الرأس إلى القدمين أو نهاية الجسد، مع إضاءة سينمائية واقعية، وخلفية بسيطة لا تسرق الانتباه من المخلوق.

حاول قدر الإمكان الالتزام بجميع التعليمات والصفات المذكورة في هذا البرومبت، لكن إذا وجدت أن الالتزام الحرفي بنسبة 100% سيجعل النتيجة مشوّهة أو غير متناسقة أو عشوائية بصرياً، فالأولوية تكون لإنتاج مخلوق واقعي، متناسق، مقنع، ومتوازن بصرياً. عدّل التفاصيل الثانوية عند الحاجة للحفاظ على الانسجام العام، بشرط ألّا تُلغي الفكرة الأساسية للمخلوق ولا نسب الدمج الرئيسية.
''';
}
String get afterBuild {
  return '''
بناءً على الصورة التي تم إنشاؤها لهذا المخلوق، وبناءً على بياناته الأصلية التالية:

الكائنات المدموجة:
$animalsDescription

المنشأ أو الطبيعة المادية: $origin
الشخصية والطابع النفسي: $personality
الحجم التقريبي: $size سنتيمتر
عدد الرؤوس: $headNumber
عدد العيون: $eyeNumber
القامة وطريقة الوقوف: $posture

أريد منك الآن أن تحلل الصورة والمعلومات السابقة، ثم تفعل ثلاثة أمور:

أولاً:
اقترح اسماً مناسباً لهذا المخلوق بناءً على شكله، والحيوانات المدموجة فيه، ومنشئه، وشخصيته.

يمكن أن يكون الاسم:
- باللغة العربية
- أو باللغة الإنجليزية
- أو اسمًا مركبًا خياليًا مناسبًا

المهم أن يكون الاسم جذاباً، سهل التذكر، ومناسباً لهوية المخلوق.

أعطني الاسم بهذا الشكل:

الاسم المقترح: ...

ثانياً:
اقترح البيئة أو الموطن المناسب الذي يمكن أن يعيش فيه هذا المخلوق أو يظهر فيه بشكل منطقي.

اختر بيئة مناسبة بناءً على:
- الحيوانات المدموجة فيه
- منشئه أو طبيعته المادية
- حجمه
- طريقة وقوفه وحركته
- شخصيته وشكله العام

يمكن أن تكون البيئة مثلاً:
غابة كثيفة، كهف صخري، صحراء، مستنقع، جبل، مدينة مهجورة، منطقة جليدية، نهر، بحر، أرض بركانية، مختبر مهجور، أطلال قديمة، أو أي بيئة أخرى مناسبة.

أعطني البيئة بهذا الشكل:

البيئة المناسبة: ...

ثم أضف شرحاً قصيراً جداً يوضح لماذا هذه البيئة مناسبة له.

ثالثاً:
قدّر قدرات هذا المخلوق من 100.

أعطني النتيجة بهذا الشكل فقط:

السرعة: رقم من 0 إلى 100
القوة الهجومية: رقم من 0 إلى 100
القوة الدفاعية: رقم من 0 إلى 100
متانة الجسم: رقم من 0 إلى 100

ثم أضف شرحاً قصيراً جداً لكل قيمة، يوضح لماذا أعطيت هذا التقييم بناءً على شكل المخلوق وبنيته ومكوناته.

لا تبالغ في الأرقام.
اجعل التقييم منطقياً ومتوازناً.
لا تجعل كل القيم عالية إلا إذا كان شكل المخلوق يبرر ذلك فعلاً.
''';
}

  @override
  String toString() {
    return '''
Creature(
  id: $id,
  name: $name,
  animals: $animals,
  origin: $origin,
  personality: $personality,
  size: $size cm,
  headNumber: $headNumber,
  eyeNumber: $eyeNumber,
  posture: $posture,
  images: $images,
  speed: $speed,
  attackPower: $attackPower,
  defensePower: $defensePower,
  bodyHardness: $bodyHardness
)
''';
  }
}