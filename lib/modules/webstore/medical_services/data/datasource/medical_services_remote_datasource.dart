import 'package:erp/core/network/network_service.dart';

class MedicalServicesRemoteDataSource {
  final NetworkService _networkService;

  MedicalServicesRemoteDataSource(this._networkService);

  Future<dynamic> getHealthProfile() {
    return _networkService.get('/api/store/medical/health-profile');
  }

  Future<dynamic> updateHealthProfile(Map<String, dynamic> data) {
    return _networkService.post('/api/store/medical/health-profile', body: data);
  }

  Future<dynamic> getHealthMetrics({String? type}) {
    return _networkService.get(
      '/api/store/medical/metrics',
      query: type != null ? {'type': type} : null,
    );
  }

  Future<dynamic> addHealthMetric(Map<String, dynamic> data) {
    return _networkService.post('/api/store/medical/metrics', body: data);
  }

  Future<dynamic> analyzeSymptoms(List<String> symptoms, {String? additionalInfo}) {
    return _networkService.post(
      '/api/store/medical/analyze-symptoms',
      body: {
        'symptoms': symptoms,
        if (additionalInfo != null) 'additional_info': additionalInfo,
      },
    );
  }

  Future<dynamic> scanImage(String imagePath, String scanType) {
    return _networkService.post(
      '/api/store/medical/ai-scan',
      body: {
        'image': imagePath,
        'scan_type': scanType,
      },
    );
  }

  Future<dynamic> getMedicationReminders() {
    return _networkService.get('/api/store/medical/reminders');
  }

  Future<dynamic> createMedicationReminder(Map<String, dynamic> data) {
    return _networkService.post('/api/store/medical/reminders', body: data);
  }

  Future<dynamic> updateMedicationReminder(int id, Map<String, dynamic> data) {
    return _networkService.put('/api/store/medical/reminders/$id', body: data);
  }

  Future<dynamic> deleteMedicationReminder(int id) {
    return _networkService.delete('/api/store/medical/reminders/$id');
  }

  Future<dynamic> markReminderTaken(int id) {
    return _networkService.post('/api/store/medical/reminders/$id/taken');
  }

  Future<dynamic> getHealthPredictions() {
    return _networkService.get('/api/store/medical/predictions');
  }

  Future<dynamic> getGamificationData() {
    return _networkService.get('/api/store/medical/gamification');
  }

  Future<dynamic> claimAchievement(String achievementId) {
    return _networkService.post('/api/store/medical/gamification/claim/$achievementId');
  }

  Future<dynamic> getTelemedicineDoctors({String? specialty}) {
    return _networkService.get(
      '/api/store/medical/telemedicine/doctors',
      query: specialty != null ? {'specialty': specialty} : null,
    );
  }

  Future<dynamic> createTelemedicineSession(int doctorId) {
    return _networkService.post(
      '/api/store/medical/telemedicine/sessions',
      body: {'doctor_id': doctorId},
    );
  }

  Future<dynamic> getMedicalServicesPage() {
    return _networkService.get('/api/store/medical/services');
  }
}
