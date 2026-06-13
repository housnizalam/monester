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

مهم جداً في هذه الصورة الأولى:
اجعل المخلوق في وضعية مواجهة مباشرة للكاميرا.
يجب أن يكون المخلوق ينظر باتجاه الكاميرا مباشرة.
يجب أن تكون الكاميرا أمام المخلوق مباشرة، أي لقطة front view واضحة وليست جانبية ولا مائلة.
اجعل زاوية التصوير من الأمام بحيث تظهر هوية المخلوق وملامحه الأساسية بوضوح.

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

String get creatureVideoIdentityDescription {
  return '''
هذا المخلوق طبيعته المادية: $origin.
شخصيته: $personality.
حجمه التقريبي: $size سنتيمتر.
عدد الرؤوس: $headNumber.
عدد العيون: $eyeNumber.
قامته وطريقة وقوفه: $posture.
''';
}
String buildVideoPrompt(String actionDescription) {
  return '''
استخدم الصورة المرجعية لهذا المخلوق كأساس كامل للفيديو.

مهم جداً:
- حافظ بدقة على نفس شكل المخلوق الموجود في الصورة.
- لا تغيّر هويته البصرية.
- لا تغيّر عدد الرؤوس أو عدد العيون.
- لا تغيّر الألوان أو النِّسب أو البنية العامة.
- حافظ على نفس ملامح الوجه، ونفس التفاصيل الأساسية، ونفس الإحساس البصري العام.
- اجعل الحركة واقعية، متناسقة، وسينمائية.
- تجنّب التشوهات وتغيّر الشكل بين الإطارات.
- اجعل الحركة واضحة ونظيفة ومقنعة بصرياً.
- لا تضف شخصيات جديدة.
- لا تغيّر نوع المخلوق.
- اجعل الفيديو يبدو وكأن هذا المخلوق حي فعلاً ويتحرك بشكل طبيعي.

مهم جداً بخصوص الخلفية:
- اجعل الخلفية دائماً خضراء بالكامل Green Screen.
- يجب أن تكون الخلفية لوناً أخضر صافياً ومسطحاً قدر الإمكان.
- لا تضف أي بيئة أو مشهد أو جبال أو غابة أو أرضية معقدة أو عناصر خلفية.
- الهدف أن أتمكن من إزالة الخلفية بسهولة لاحقاً في برامج المونتاج.
- اجعل المخلوق واضحاً ومعزولاً أمام الخلفية الخضراء.
- تجنّب الظلال القوية أو الألوان الخضراء على جسم المخلوق قدر الإمكان حتى لا تصعّب عملية القص.

بيانات المخلوق:
$creatureVideoIdentityDescription

المشهد المطلوب:
$actionDescription
''';
}
String get videoRunTowardCamera {
  return buildVideoPrompt(
    'يظهر المخلوق من بعيد ثم يركض بسرعة باتجاه الكاميرا بشكل مباشر. '
    'تكون حركته قوية وواضحة، وكلما اقترب من الكاميرا يصبح أكثر حضوراً وتهديداً. '
    'اجعل الجري واقعياً ومتناسقاً، مع اهتزاز خفيف طبيعي في الجسد أثناء الركض.'
  );
}

String get videoCautiousWalkAndObserve {
  return buildVideoPrompt(
    'يمشي المخلوق ببطء وحذر، ثم ينظر إلى جانبه، ثم ينظر إلى الجهة الأخرى، '
    'ثم يوجّه نظره نحو الكاميرا وكأنه يحاول فهم ما الذي أمامه أو التعرّف عليه، '
    'ثم يتابع المشي بخطوات حذرة ومدروسة.'
  );
}

String get videoRoarInFrontOfCamera {
  return buildVideoPrompt(
    'يقف المخلوق أمام الكاميرا في وضعية ثابتة ومهيبة، ثم يفتح فمه أو يغيّر تعابيره '
    'ويزمجر بغضب شديد، مع إظهار انفعال واضح في الجسد والرأس والعينين. '
    'اجعل الزمجرة قوية ومخيفة لكن متناسقة بصرياً.'
  );
}

String get videoAttackCharge {
  return buildVideoPrompt(
    'يأخذ المخلوق وضعية عدائية واضحة، ثم يندفع فجأة للهجوم نحو الأمام '
    'كما لو أنه يهاجم خصماً قريباً. اجعل الحركة سريعة وعنيفة ومقنعة، '
    'مع إبراز القوة الجسدية والاندفاع.'
  );
}

String get videoPlayfulLaugh {
  return buildVideoPrompt(
    'يظهر المخلوق في مزاج مرح، يضحك أو يبدي تعبيرات مرحة، '
    'ويتحرك بخفة ويلعب بطريقة لطيفة وممتعة، مع حركات جسدية بسيطة تدل على المرح والبهجة.'
  );
}

String get videoSlowApproach {
  return buildVideoPrompt(
    'يبدأ المخلوق بعيداً قليلاً ثم يقترب ببطء شديد نحو الكاميرا، '
    'مع نظرات مركزة وثابتة، وكأنه يراقب شيئاً مهمّاً أو يقترب بحذر من هدف مجهول.'
  );
}

String get videoWalkAcrossScene {
  return buildVideoPrompt(
    'يمشي المخلوق من أحد جانبي المشهد إلى الجانب الآخر بشكل واضح ومتوازن، '
    'بحركة طبيعية تُظهر كامل جسمه وطريقة مشيه وتوازن قامته.'
  );
}

String get videoLookAroundAlert {
  return buildVideoPrompt(
    'يبقى المخلوق في مكانه تقريباً لكنه يكون في حالة تأهّب، '
    'يحرك رأسه وعينيه وينظر حوله بانتباه واضح، كأنه سمع صوتاً أو شعر بوجود شيء حوله.'
  );
}

String get videoSniffAndSearch {
  return buildVideoPrompt(
    'يتقدم المخلوق بخطوات بطيئة، ثم يتوقف وينخفض قليلاً أو يقرّب رأسه من الأرض أو من الجو حوله، '
    'وكأنه يشمّ أو يبحث عن أثر شيء ما، ثم يرفع رأسه ويتابع البحث.'
  );
}

String get videoCircleAndInspect {
  return buildVideoPrompt(
    'يتحرك المخلوق بحذر في نصف دائرة أو دائرة صغيرة، '
    'وينظر باستمرار نحو الكاميرا أو نحو هدف أمامه، وكأنه يدرس الموقف قبل اتخاذ قرار.'
  );
}

String get videoDefensiveStance {
  return buildVideoPrompt(
    'يقف المخلوق في وضعية دفاعية واضحة، يشد جسمه ويستعد للمواجهة، '
    'ويبدو حذراً ومتيقظاً، كأنه يتوقع هجوماً ويدافع عن نفسه أو عن منطقته.'
  );
}

String get videoJumpAttack {
  return buildVideoPrompt(
    'يتراجع المخلوق قليلاً ثم يقفز فجأة إلى الأمام أو إلى الأعلى '
    'في حركة هجومية سريعة، وكأنه يحاول الانقضاض على خصم أمامه.'
  );
}

String get videoScratchAndBite {
  return buildVideoPrompt(
    'يقوم المخلوق بحركة قتال مباشرة، يحاول فيها الضرب أو الخدش أو العض '
    'بحسب بنيته وشكله، مع إبراز عدوانية واضحة وحركة قتال قصيرة ومكثفة.'
  );
}

String get videoHeavyStomp {
  return buildVideoPrompt(
    'يرفع المخلوق جسمه أو أحد أطرافه ثم يضرب الأرض أو يدوس بقوة، '
    'في حركة ثقيلة وقوية توحي بالهيبة والسيطرة والغضب.'
  );
}

String get videoTailWhip {
  return buildVideoPrompt(
    'إذا كان للمخلوق ذيل أو ما يشبه الذيل، يقوم بحركة التفاف سريعة '
    'ويضرب أو يلوّح بذيله بعنف في حركة قتالية واضحة. '
    'وإذا لم يكن له ذيل واضح، فاجعل الحركة البديلة منسجمة مع تصميمه.'
  );
}

String get videoVictoryPose {
  return buildVideoPrompt(
    'يقف المخلوق بعد الانتصار أو بعد إنهاء المواجهة في وضعية فخر وسيطرة، '
    'يرفع رأسه ويبدو واثقاً من نفسه، مع تعبيرات توحي بالقوة والتفوّق.'
  );
}

String get videoWoundedRetreat {
  return buildVideoPrompt(
    'يظهر المخلوق وكأنه أُصيب أو تعب من القتال، '
    'فيتراجع إلى الخلف أو يبتعد بخطوات حذرة ومتوترة، مع إظهار أثر التعب أو الألم دون مبالغة.'
  );
}

String get videoSleepingWakeUp {
  return buildVideoPrompt(
    'يبدأ المخلوق في حالة سكون أو نوم أو شبه نوم، '
    'ثم يستيقظ تدريجياً، يفتح عينيه، يحرّك رأسه وجسده ببطء، '
    'ثم يقف أو يصبح في حالة انتباه.'
  );
}

String get videoIdleBreathing {
  return buildVideoPrompt(
    'يبقى المخلوق واقفاً أو جالساً في مكانه دون حركة كبيرة، '
    'لكن تظهر عليه حركات التنفس الطبيعية، وحركات خفيفة في الرأس أو العينين أو الأطراف، '
    'ليبدو حياً وواقعياً في لقطة هادئة.'
  );
}

String get videoCuriousCloseLook {
  return buildVideoPrompt(
    'يقترب المخلوق قليلاً من الكاميرا، ثم يميل رأسه أو يغيّر زاوية نظره '
    'بطريقة فضولية، كأنه يحاول فهم الكاميرا أو فحص شيء غريب أمامه.'
  );
}

String get videoThreatenCamera {
  return buildVideoPrompt(
    'يقف المخلوق أمام الكاميرا في وضعية تهديد مباشرة، '
    'ينظر إليها بحدة، يقترب قليلاً، ويُظهر عدائية واضحة كأنه يحذّر أو يتحدّى من أمامه.'
  );
}

String get videoRunPastCamera {
  return buildVideoPrompt(
    'يركض المخلوق بسرعة ويمر بجانب الكاميرا أو أمامها بشكل سريع، '
    'مع حركة قوية وواضحة تُظهر سرعته ورشاقته.'
  );
}

String get videoClimbAndPerch {
  return buildVideoPrompt(
    'يتسلق المخلوق شيئاً مناسباً لبنيته، أو يرتفع إلى موضع أعلى، '
    'ثم يتوقف في وضعية مراقبة أو ترقّب. '
    'إذا لم يكن التسلق مناسباً لتصميمه، فاستبدله بحركة صعود منطقية تناسبه.'
  );
}

String get videoEmergingFromDarkness {
  return buildVideoPrompt(
    'يبدأ المخلوق شبه مخفي أو بعيداً أو في منطقة أغمق قليلاً، '
    'ثم يخرج تدريجياً إلى الوضوح، كاشفاً عن ملامحه شيئاً فشيئاً بطريقة سينمائية مشوّقة.'
  );
}

String get videoAngryWalk {
  return buildVideoPrompt(
    'يمشي المخلوق بخطوات غاضبة وثقيلة، مع لغة جسد عدائية واضحة، '
    'وكأنه متوتر أو مستفَز ويستعد للدخول في صدام.'
  );
}

String get videoHappyBounce {
  return buildVideoPrompt(
    'يتحرك المخلوق بطاقة مرحة، مع قفزات صغيرة أو حركات خفيفة سعيدة، '
    'ويبدو مستمتعاً بالمشهد من حوله بطريقة ودودة ومسلية.'
  );
}

String get videoSearchForEnemy {
  return buildVideoPrompt(
    'يتحرك المخلوق في المكان وهو يبحث عن خصم أو هدف، '
    'ينظر بعيداً، يتوقف، يلتفت بسرعة، ثم يواصل البحث بحذر وترقّب.'
  );
}

String get videoPrepareToPounce {
  return buildVideoPrompt(
    'يخفض المخلوق جسمه قليلاً أو يتخذ وضعية استعداد، '
    'ثم يشد عضلاته وكأنه على وشك الانقضاض في أي لحظة، '
    'لكن دون تنفيذ القفزة مباشرة إلا في آخر لحظة قصيرة.'
  );
}

String get videoBattleReadyPose {
  return buildVideoPrompt(
    'يقف المخلوق في وضعية استعداد للمعركة، '
    'يثبت جسده، يوجه نظره بحدة، ويبدو جاهزاً تماماً للقتال، '
    'مع حركة بسيطة في الرأس أو الأطراف تؤكد حالة التأهب.'
  );
}

String get videoTurnBackThenLook {
  return buildVideoPrompt(
    'يكون المخلوق مواجهاً بعيداً عن الكاميرا أو بزاوية جانبية، '
    'ثم يتوقف، ويلتفت ببطء لينظر نحو الكاميرا بنظرة قوية أو فضولية.'
  );
}

String get videoWalkThenSuddenRoar {
  return buildVideoPrompt(
    'يمشي المخلوق بهدوء لعدة خطوات، ثم يتوقف فجأة، '
    'ويرفع رأسه أو يفتح فمه ويطلق زمجرة أو هديراً مفاجئاً أمام الكاميرا.'
  );
}

String get videoAttackThenRetreat {
  return buildVideoPrompt(
    'ينفذ المخلوق هجوماً سريعاً وخاطفاً إلى الأمام، '
    'ثم يتراجع خطوة أو خطوتين إلى الخلف، '
    'ويبقى في وضعية حذرة مستعداً لهجوم جديد.'
  );
}

String get videoFriendlyGreeting {
  return buildVideoPrompt(
    'يظهر المخلوق بشكل ودود، يقترب قليلاً من الكاميرا أو من الهدف أمامه، '
    'ويقوم بحركة لطيفة أو مرحة توحي بالتحية أو التعارف، دون أي عدوانية.'
  );
}

String get videoConfusedReaction {
  return buildVideoPrompt(
    'يظهر على المخلوق الارتباك أو الحيرة، '
    'فيتوقف، ينظر يميناً ويساراً، يميل رأسه، ويبدو غير متأكد مما يجري حوله.'
  );
}

String get videoProudShowcase {
  return buildVideoPrompt(
    'اعرض المخلوق كما لو أنه يُقدِّم نفسه أمام الكاميرا، '
    'يقف بثقة، ثم يتحرك ببطء ليُظهر تفاصيل جسمه وهيبته وشكله الكامل بطريقة سينمائية جميلة.'
  );
}

String get videoFastChase {
  return buildVideoPrompt(
    'يبدو المخلوق وكأنه يطارد هدفاً أمامه بسرعة عالية، '
    'فيجري بقوة وتركيز، مع شعور واضح بالمطاردة والإصرار.'
  );
}

String get videoGuardingArea {
  return buildVideoPrompt(
    'يتصرف المخلوق كحارس لمنطقة خاصة به، '
    'يتحرك خطوات قليلة، يتوقف، يراقب، ثم يثبت في مكانه بنظرة حازمة وحضور قوي.'
  );
}

String get videoShowTeethAndWarn {
  return buildVideoPrompt(
    'يقف المخلوق أمام الكاميرا أو أمام خصم قريب، '
    'ويُظهر علامات تحذير واضحة مثل كشف الأسنان أو تضييق العينين أو شد الجسد، '
    'في مشهد تهديدي قصير قبل أي هجوم.'
  );
}

String get videoLaughThenRunAway {
  return buildVideoPrompt(
    'يظهر المخلوق في حالة مرحة، يضحك أو يبدي تعبيراً مضحكاً، '
    'ثم يلتفت ويركض مبتعداً بخفة وكأنّه يلهو أو يتهرب بعد مزاح.'
  );
}

String get videoEntranceHeroic {
  return buildVideoPrompt(
    'يدخل المخلوق إلى المشهد بطريقة بطولية وواثقة، '
    'يتقدم إلى الأمام بثبات وهيبة، وكأنه ظهور أول مهم لشخصية قوية في القصة.'
  );
}

String get videoMiniFightLoop {
  return buildVideoPrompt(
    'أنشئ مشهداً قصيراً يشبه لقطة قتال صغيرة: '
    'المخلوق يستعد، يهاجم بحركة واحدة أو حركتين، ثم يعود إلى وضعية التأهب. '
    'اجعلها لقطة حركية قصيرة ومناسبة للتكرار أو الاستخدام كمشهد سريع.'
  );
}

Map<String, String> get videoPrompts {
  return {
    'يركض باتجاه الكاميرا': videoRunTowardCamera,
    'يمشي بحذر ويتفقد المكان': videoCautiousWalkAndObserve,
    'يقف ويزمجر أمام الكاميرا': videoRoarInFrontOfCamera,
    'يهجم باتجاه الأمام': videoAttackCharge,
    'يضحك ويلعب': videoPlayfulLaugh,
    'يقترب ببطء': videoSlowApproach,
    'يمشي من جانب إلى آخر': videoWalkAcrossScene,
    'يتلفت بانتباه': videoLookAroundAlert,
    'يشم ويبحث عن أثر': videoSniffAndSearch,
    'يدور ويفحص المكان': videoCircleAndInspect,
    'وضعية دفاعية': videoDefensiveStance,
    'قفزة هجومية': videoJumpAttack,
    'خدش وعض': videoScratchAndBite,
    'دوسة قوية': videoHeavyStomp,
    'ضربة بالذيل': videoTailWhip,
    'وقفة انتصار': videoVictoryPose,
    'يتراجع وهو مصاب': videoWoundedRetreat,
    'نائم ثم يستيقظ': videoSleepingWakeUp,
    'وقوف وتنفس طبيعي': videoIdleBreathing,
    'نظرة فضولية قريبة': videoCuriousCloseLook,
    'تهديد مباشر للكاميرا': videoThreatenCamera,
    'يركض بجانب الكاميرا': videoRunPastCamera,
    'يتسلق ويراقب': videoClimbAndPerch,
    'يخرج من الظلام': videoEmergingFromDarkness,
    'مشي غاضب': videoAngryWalk,
    'قفزات سعيدة': videoHappyBounce,
    'يبحث عن عدو': videoSearchForEnemy,
    'يستعد للانقضاض': videoPrepareToPounce,
    'جاهز للمعركة': videoBattleReadyPose,
    'يلتفت نحو الكاميرا': videoTurnBackThenLook,
    'يمشي ثم يزمجر فجأة': videoWalkThenSuddenRoar,
    'يهجم ثم يتراجع': videoAttackThenRetreat,
    'تحية ودودة': videoFriendlyGreeting,
    'ردة فعل مرتبكة': videoConfusedReaction,
    'استعراض شكل المخلوق': videoProudShowcase,
    'مطاردة سريعة': videoFastChase,
    'يحرس منطقته': videoGuardingArea,
    'يكشف أسنانه ويحذر': videoShowTeethAndWarn,
    'يضحك ثم يهرب': videoLaughThenRunAway,
    'دخول بطولي': videoEntranceHeroic,
    'لقطة قتال قصيرة': videoMiniFightLoop,
  };
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