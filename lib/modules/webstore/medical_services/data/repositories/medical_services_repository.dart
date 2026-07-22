import 'dart:math';

class ApiResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const ApiResult.success(this.data) : isSuccess = true, error = null;
  const ApiResult.failure(this.error) : isSuccess = false, data = null;

  R when<R>({
    required R Function(T data) success,
    required R Function(String error) failure,
  }) {
    if (isSuccess && data != null) {
      return success(data as T);
    }
    return failure(error ?? 'Unknown error');
  }
}

abstract class IMedicalServicesRepository {
  Future<ApiResult<Map<String, dynamic>>> getHealthProfile();
  Future<ApiResult<Map<String, dynamic>>> updateHealthProfile(Map<String, dynamic> data);
  Future<ApiResult<List<dynamic>>> getHealthMetrics({String? type});
  Future<ApiResult<Map<String, dynamic>>> addHealthMetric(Map<String, dynamic> data);
  Future<ApiResult<Map<String, dynamic>>> analyzeSymptoms(List<String> symptoms, {String? additionalInfo});
  Future<ApiResult<Map<String, dynamic>>> scanImage(String imagePath, String scanType);
  Future<ApiResult<List<dynamic>>> getMedicationReminders();
  Future<ApiResult<Map<String, dynamic>>> createMedicationReminder(Map<String, dynamic> data);
  Future<ApiResult<void>> deleteMedicationReminder(int id);
  Future<ApiResult<void>> markReminderTaken(int id);
  Future<ApiResult<List<dynamic>>> getHealthPredictions();
  Future<ApiResult<Map<String, dynamic>>> getGamificationData();
  Future<ApiResult<List<dynamic>>> getTelemedicineDoctors({String? specialty});
  Future<ApiResult<Map<String, dynamic>>> createTelemedicineSession(int doctorId);
  Future<ApiResult<Map<String, dynamic>>> getDailyActivities();
  Future<ApiResult<Map<String, dynamic>>> updateDailyActivity(String type, double value);
}

class MockMedicalServicesRepository implements IMedicalServicesRepository {
  final _random = Random();

  Future<ApiResult<T>> _mockDelay<T>(T data, {int ms = 800}) async {
    await Future.delayed(Duration(milliseconds: ms + _random.nextInt(400)));
    return ApiResult.success(data);
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getHealthProfile() async {
    return _mockDelay({
      'age': 28,
      'gender': 'male',
      'weight': 78.5,
      'height': 175,
      'blood_type': 'O+',
      'allergies': ['بنسلين', 'غبار'],
      'chronic_diseases': [],
      'metrics': [],
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> updateHealthProfile(Map<String, dynamic> data) async {
    return _mockDelay({...data, 'updated_at': DateTime.now().toIso8601String()});
  }

  @override
  Future<ApiResult<List<dynamic>>> getHealthMetrics({String? type}) async {
    final now = DateTime.now();
    return _mockDelay([
      {
        'id': 1,
        'type': 'blood_pressure',
        'label': 'ضغط الدم',
        'value': 120.0,
        'unit': '/80 mmHg',
        'recorded_at': now.subtract(const Duration(hours: 2)).toIso8601String(),
        'status': 'normal',
      },
      {
        'id': 2,
        'type': 'blood_sugar',
        'label': 'سكر الدم',
        'value': 95.0,
        'unit': 'mg/dL',
        'recorded_at': now.subtract(const Duration(hours: 5)).toIso8601String(),
        'status': 'normal',
      },
      {
        'id': 3,
        'type': 'heart_rate',
        'label': 'نبضات القلب',
        'value': 72.0,
        'unit': 'ب/د',
        'recorded_at': now.subtract(const Duration(hours: 8)).toIso8601String(),
        'status': 'normal',
      },
      {
        'id': 4,
        'type': 'temperature',
        'label': 'درجة الحرارة',
        'value': 36.8,
        'unit': '°C',
        'recorded_at': now.subtract(const Duration(days: 1)).toIso8601String(),
        'status': 'normal',
      },
      {
        'id': 5,
        'type': 'spo2',
        'label': 'ت_saturation الأكسجين',
        'value': 98.0,
        'unit': '%',
        'recorded_at': now.subtract(const Duration(days: 1, hours: 3)).toIso8601String(),
        'status': 'normal',
      },
    ]);
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> addHealthMetric(Map<String, dynamic> data) async {
    return _mockDelay({
      ...data,
      'id': _random.nextInt(1000) + 100,
      'recorded_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> analyzeSymptoms(
    List<String> symptoms, {
    String? additionalInfo,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final analysis = _getSymptomAnalysis(symptoms);
    return ApiResult.success(analysis);
  }

  Map<String, dynamic> _getSymptomAnalysis(List<String> symptoms) {
    final s = symptoms.map((e) => e.toLowerCase()).toList();

    if (s.any((e) => e.contains('صداع'))) {
      return {
        'diagnosis': 'صداع توتري',
        'severity': 'moderate',
        'description':
            'بناءً على الأعراض المذكورة، يبدو أنك تعاني من صداع توتري. هذا النوع من الصداع شائع ويحدث بسبب التوتر أو الإجهاد أو قلة النوم.',
        'recommended_actions': [
          'خذ راحة في مكان هادئ ومظلم',
          'اشرب مية كفاية',
          'استخدم مسكن ألم خفيف مثل باراسيتامول',
          'حاول تقليل التوتر',
        ],
        'suggested_medicines': ['باراسيتامول', 'إيبوبروفين', '.SpringBootTest'],
        'needs_doctor': false,
      };
    }

    if (s.any((e) => e.contains('حمى') || e.contains('حرارة'))) {
      return {
        'diagnosis': 'حمى خفيفة',
        'severity': 'mild',
        'description':
            'يبدو أنك تعاني من حمى خفيفة. ممكن تكون بسبب برودة أو التهاب بسيط. لازم تراقب حرارتك.',
        'recommended_actions': [
          'اشرب سوائل كفاية',
          'خدي مسكن خفيف',
          'ارتاح في البيت',
          'قاس حرارتك كل 4 ساعات',
        ],
        'suggested_medicines': ['باراسيتامول', 'إيبوبروفين'],
        'needs_doctor': false,
      };
    }

    if (s.any((e) => e.contains('معدة') || e.contains('بطن'))) {
      return {
        'diagnosis': 'اضطراب في المعدة',
        'severity': 'mild',
        'description':
            'يبدو أنك تعاني من اضطراب في المعدة. ممكن يكون بسبب أكل غير مناسب أو توتر.',
        'recommended_actions': [
          'اشرب شاي أملج أو نعناع',
          'تجنب الأكل الثقيل والدهني',
          'اشرب مية على مراحل',
          'اشرب مسكن ألم المعدة',
        ],
        'suggested_medicines': ['جيفيسكون', 'إيبوبروفين (مع أكل)'],
        'needs_doctor': false,
      };
    }

    return {
      'diagnosis': 'تحاليل أولية',
      'severity': 'low',
      'description':
          'بناءً على الأعراض "${symptoms.join(' و')}"، أنصحك بمراقبة حالتك لبضاعة أيام. لو الأعراض استمرت أو ازدادت، راجع دكتور.',
      'recommended_actions': [
        'اشرب مية كفاية',
        'اخد راحة كفاية',
        'تابع حالتك يومياً',
        'لو الوضع اسوء راجع دكتور',
      ],
      'suggested_medicines': [],
      'needs_doctor': false,
    };
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> scanImage(String imagePath, String scanType) async {
    await Future.delayed(const Duration(seconds: 3));

    final results = {
      'scan_type': scanType,
      'overall_status': 'normal',
      'scanned_at': DateTime.now().toIso8601String(),
      'metrics': {
        if (scanType == 'hand') ...{
          'blood_oxygen': {
            'name': 'نسبة الأكسجين',
            'value': 97.5,
            'unit': '%',
            'status': 'normal',
            'description': 'نسبة ممتازة',
          },
          'skin_temperature': {
            'name': 'درجة حرارة الجلد',
            'value': 33.2,
            'unit': '°C',
            'status': 'normal',
            'description': 'ضمن الطبيعي',
          },
          'pulse_rate': {
            'name': 'معدل النبض',
            'value': 72.0,
            'unit': 'ب/د',
            'status': 'normal',
            'description': 'معدل طبيعي',
          },
        },
        if (scanType == 'tongue') ...{
          'hydration': {
            'name': 'مستوى الترطيب',
            'value': 85.0,
            'unit': '%',
            'status': 'normal',
            'description': 'ترطيب جيد',
          },
          'circulation': {
            'name': 'الدورة الدموية',
            'value': 78.0,
            'unit': '%',
            'status': 'normal',
            'description': 'جيدة',
          },
          'digestion_health': {
            'name': 'صحة الهضم',
            'value': 82.0,
            'unit': '%',
            'status': 'normal',
            'description': 'جيدة',
          },
        },
        if (scanType == 'eye') ...{
          'eye_strain': {
            'name': 'إرهاق العيون',
            'value': 45.0,
            'unit': '%',
            'status': 'warning',
            'description': 'إرهاق خفيف - قلل من الشاشات',
          },
          'visual_acuity': {
            'name': 'حدة البصر',
            'value': 90.0,
            'unit': '%',
            'status': 'normal',
            'description': 'ممتاز',
          },
        },
        if (scanType == 'skin' || scanType == 'general') ...{
          'skin_hydration': {
            'name': 'ترطيب البشرة',
            'value': 72.0,
            'unit': '%',
            'status': 'normal',
            'description': 'ترطيب جيد',
          },
          'uv_damage': {
            'name': 'أضرار الأشعة فوق البنفسجية',
            'value': 15.0,
            'unit': '%',
            'status': 'normal',
            'description': 'أضرار بسيطة',
          },
          'elasticity': {
            'name': 'مرونة الجلد',
            'value': 88.0,
            'unit': '%',
            'status': 'normal',
            'description': 'ممتاز',
          },
        },
      },
      'recommendations': [
        'اشرب 8 كوبايات مية يومياً',
        'قلل من الأكل المعلب والمحفوظ',
        'تمارين خفيفة 30 دقيقة يومياً',
        'نوم كفاية 7-8 ساعات',
        'اشرب فيتامين سي يومياً',
      ],
    };

    return ApiResult.success(results);
  }

  @override
  Future<ApiResult<List<dynamic>>> getMedicationReminders() async {
    final now = DateTime.now();
    return _mockDelay([
      {
        'id': 1,
        'medication_name': 'فيتامين د',
        'dosage': 'قرص واحد (5000 IU)',
        'frequency': 'يومياً',
        'times': ['08:00'],
        'start_date': now.subtract(const Duration(days: 30)).toIso8601String(),
        'is_active': true,
        'notes': 'اشربه مع أكل',
        'logs': [
          {'id': 1, 'scheduled_time': now.subtract(const Duration(hours: 3)).toIso8601String(), 'taken': true, 'taken_at': now.subtract(const Duration(hours: 2, minutes: 50)).toIso8601String()},
          {'id': 2, 'scheduled_time': now.subtract(const Duration(days: 1, hours: 3)).toIso8601String(), 'taken': true, 'taken_at': now.subtract(const Duration(days: 1, hours: 2, minutes: 45)).toIso8601String()},
          {'id': 3, 'scheduled_time': now.subtract(const Duration(days: 2, hours: 3)).toIso8601String(), 'taken': true, 'taken_at': now.subtract(const Duration(days: 2, hours: 3, minutes: 10)).toIso8601String()},
        ],
      },
      {
        'id': 2,
        'medication_name': 'أوميغا 3',
        'dosage': 'كبسولة واحدة',
        'frequency': 'يومياً',
        'times': ['09:00', '21:00'],
        'start_date': now.subtract(const Duration(days: 15)).toIso8601String(),
        'is_active': true,
        'notes': '',
        'logs': [
          {'id': 4, 'scheduled_time': now.subtract(const Duration(hours: 4)).toIso8601String(), 'taken': true, 'taken_at': now.subtract(const Duration(hours: 3, minutes: 55)).toIso8601String()},
          {'id': 5, 'scheduled_time': now.subtract(const Duration(days: 1, hours: 4)).toIso8601String(), 'taken': true, 'taken_at': now.subtract(const Duration(days: 1, hours: 3, minutes: 30)).toIso8601String()},
        ],
      },
      {
        'id': 3,
        'medication_name': 'مagnesium',
        'dosage': 'قرص واحد',
        'frequency': 'يومياً',
        'times': ['22:00'],
        'start_date': now.subtract(const Duration(days: 7)).toIso8601String(),
        'is_active': true,
        'notes': 'اشربه قبل النوم',
        'logs': [
          {'id': 6, 'scheduled_time': now.subtract(const Duration(days: 1, hours: 6)).toIso8601String(), 'taken': true, 'taken_at': now.subtract(const Duration(days: 1, hours: 5, minutes: 50)).toIso8601String()},
          {'id': 7, 'scheduled_time': now.subtract(const Duration(days: 2, hours: 6)).toIso8601String(), 'taken': false},
        ],
      },
    ]);
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> createMedicationReminder(Map<String, dynamic> data) async {
    return _mockDelay({
      ...data,
      'id': _random.nextInt(1000) + 100,
      'logs': [],
    });
  }

  @override
  Future<ApiResult<void>> deleteMedicationReminder(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const ApiResult.success(null);
  }

  @override
  Future<ApiResult<void>> markReminderTaken(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const ApiResult.success(null);
  }

  @override
  Future<ApiResult<List<dynamic>>> getHealthPredictions() async {
    return _mockDelay([
      {
        'title': 'إصابة محتملة بالقولون',
        'description':
            'بناءً على سجل تناولك للأدوية والعادات الغذائية، يوجد احتمال بسيط لإصابة بالقولون العصبي خلال 6 شهور قادمة.',
        'probability': 0.35,
        'timeframe': 'خلال 6 شهور',
        'prevention_tips': [
          'اشرب مية كفاية يومياً',
          'قلل من الكافيين',
          'زود الأكل الاليافي',
        ],
      },
      {
        'title': 'نقص فيتامين د',
        'description':
            'أنت بتاخد فيتامين د بانتظام بس محتاج تراجع مستواك بعد 3 شهور.',
        'probability': 0.2,
        'timeframe': 'خلال 3 شهور',
        'prevention_tips': [
          'استمر على فيتامين د',
          'اخد شمس خفيفة 15 دقيقة يومياً',
        ],
      },
      {
        'title': 'تحسن عام في الصحة',
        'description':
            'عاداتك الصحية الأخيرة بتحسن صحتك بشكل ملحوظ. استمر!',
        'probability': 0.0,
        'timeframe': 'الآن',
        'prevention_tips': [
          'استمر على التمارين',
          'حافظ على النوم المنتظم',
          'اشرب مية كفاية',
        ],
      },
    ]);
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getGamificationData() async {
    return _mockDelay({
      'total_points': 1250,
      'level': 5,
      'title': 'محارب صحي',
      'streak': 12,
      'achievements': [
        {'id': '1', 'title': 'أول خطوة', 'description': 'سجل أول تذكير', 'icon': '🎯', 'is_unlocked': true, 'unlocked_at': DateTime.now().subtract(const Duration(days: 30)).toIso8601String()},
        {'id': '2', 'title': 'سلسلة 7 أيام', 'description': '7 أيام متتالية', 'icon': '🔥', 'is_unlocked': true, 'unlocked_at': DateTime.now().subtract(const Duration(days: 7)).toIso8601String()},
        {'id': '3', 'title': 'مسح صحي', 'description': 'أول مسح صحي', 'icon': '📸', 'is_unlocked': true, 'unlocked_at': DateTime.now().subtract(const Duration(days: 5)).toIso8601String()},
        {'id': '4', 'title': 'محارب 30 يوم', 'description': '30 يوم متتالي', 'icon': '🏆', 'is_unlocked': false},
        {'id': '5', 'title': 'خبير صحي', 'description': 'اكمل 10 تحديات', 'icon': '🧠', 'is_unlocked': false},
        {'id': '6', 'title': 'نجم الأدوية', 'description': 'التزام تام 14 يوم', 'icon': '💊', 'is_unlocked': false},
      ],
      'challenges': [
        {
          'id': 'c1',
          'title': 'شرب 8 كوبايات مية يومياً',
          'description': 'اشرب 8 كوبايات مية كل يوم لمدة أسبوع',
          'target_days': 7,
          'completed_days': 5,
          'reward_points': 100,
        },
        {
          'id': 'c2',
          'title': 'مشي 30 دقيقة يومياً',
          'description': 'امشي 30 دقيقة كل يوم لمدة أسبوع',
          'target_days': 7,
          'completed_days': 3,
          'reward_points': 150,
        },
        {
          'id': 'c3',
          'title': 'نوم مبكر 5 أيام',
          'description': 'نام قبل 11PM لمدة 5 أيام',
          'target_days': 5,
          'completed_days': 2,
          'reward_points': 75,
        },
      ],
    });
  }

  @override
 Future<ApiResult<List<dynamic>>> getTelemedicineDoctors({String? specialty}) async {
    final allDoctors = [
      {
        'id': 1,
        'name': 'د. أحمد محمد',
        'specialty': 'باطنية',
        'avatar': null,
        'rating': 4.8,
        'is_available': true,
        'consultation_fee': 150.0,
      },
      {
        'id': 2,
        'name': 'د. سارة علي',
        'specialty': 'جلدية',
        'avatar': null,
        'rating': 4.9,
        'is_available': true,
        'consultation_fee': 200.0,
      },
      {
        'id': 3,
        'name': 'd. محمد حسن',
        'specialty': 'عامة',
        'avatar': null,
        'rating': 4.6,
        'is_available': false,
        'consultation_fee': 100.0,
      },
      {
        'id': 4,
        'name': 'د. فاطمة أحمد',
        'specialty': 'أسنان',
        'avatar': null,
        'rating': 4.7,
        'is_available': true,
        'consultation_fee': 120.0,
      },
      {
        'id': 5,
        'name': 'د. خالد سعيد',
        'specialty': 'عيون',
        'avatar': null,
        'rating': 4.5,
        'is_available': false,
        'consultation_fee': 180.0,
      },
      {
        'id': 6,
        'name': 'د. نورا سامي',
        'specialty': 'باطنية',
        'avatar': null,
        'rating': 4.8,
        'is_available': true,
        'consultation_fee': 160.0,
      },
    ];

    if (specialty != null) {
      return _mockDelay(
        allDoctors.where((d) => d['specialty'] == specialty).toList(),
      );
    }

    return _mockDelay(allDoctors);
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> createTelemedicineSession(int doctorId) async {
    return _mockDelay({
      'session_id': _random.nextInt(10000),
      'doctor_id': doctorId,
      'status': 'pending',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getDailyActivities() async {
    return _mockDelay({
      'steps': {'current': 6500, 'target': 10000, 'unit': 'خطوة'},
      'water': {'current': 5, 'target': 8, 'unit': 'كوباية'},
      'sleep': {'current': 7.5, 'target': 8, 'unit': 'ساعة'},
      'calories': {'current': 1850, 'target': 2200, 'unit': 'سعرة'},
    });
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> updateDailyActivity(String type, double value) async {
    return _mockDelay({
      'type': type,
      'value': value,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }
}
