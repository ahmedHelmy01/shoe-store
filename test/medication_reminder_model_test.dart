import 'package:flutter_test/flutter_test.dart';
import 'package:erp/modules/webstore/medical_services/data/models/medication_reminder_model.dart';

void main() {
  group('DoseAmount display labels', () {
    test('pill fractions render in Arabic', () {
      expect(const DoseAmount(amount: 0.25, unit: DoseUnit.pill).displayLabel, 'ربع قرص');
      expect(const DoseAmount(amount: 0.5, unit: DoseUnit.pill).displayLabel, 'نصف قرص');
      expect(const DoseAmount(amount: 0.75, unit: DoseUnit.pill).displayLabel, 'ثلاثة أرباع قرص');
      expect(const DoseAmount(amount: 1, unit: DoseUnit.pill).displayLabel, 'قرص واحد');
      expect(const DoseAmount(amount: 1.5, unit: DoseUnit.pill).displayLabel, 'قرص ونص');
      expect(const DoseAmount(amount: 2, unit: DoseUnit.pill).displayLabel, 'قرصان');
      expect(const DoseAmount(amount: 2.5, unit: DoseUnit.pill).displayLabel, 'قرصان ونص');
      expect(const DoseAmount(amount: 3, unit: DoseUnit.pill).displayLabel, '3 أقراص');
      expect(const DoseAmount(amount: 2, unit: DoseUnit.capsule).displayLabel, 'كبسولتان');
    });

    test('plain units render with number', () {
      expect(const DoseAmount(amount: 250, unit: DoseUnit.mg).displayLabel, '250 ملجم');
      expect(const DoseAmount(amount: 0.5, unit: DoseUnit.ml).displayLabel, '0.5 مل');
      expect(const DoseAmount(amount: 3, unit: DoseUnit.drop).displayLabel, '3 نقطة');
    });
  });

  group('Legacy migration', () {
    test('old reminder JSON migrates to weekly schedule', () {
      final migrated = MedicationReminderModel.fromJson({
        'id': 7,
        'medication_name': 'بنادول',
        'dosage': 'نصف قرص بعد الأكل',
        'frequency': 'يومياً',
        'times': ['08:00', '20:00'],
        'start_date': '2026-08-01T10:00:00.000',
        'is_active': true,
      });

      expect(migrated.medicationName, 'بنادول');
      expect(migrated.totalWeeklySlots, 14); // 2 times x 7 days
      expect(migrated.scheduledWeekdays.length, 7);
      final slot = migrated.slotsFor(DateTime.monday).first;
      expect(slot.hour, 8);
      expect(slot.dose.amount, 0.5);
      expect(slot.dose.unit, DoseUnit.pill);
      expect(slot.method, AdministrationMethod.afterMeal);
    });

    test('weekly frequency maps to start weekday only', () {
      final migrated = MedicationReminderModel.fromJson({
        'id': 8,
        'medication_name': 'فيتامين د',
        'dosage': 'قرص واحد',
        'frequency': 'أسبوعياً',
        'times': ['09:00'],
        'start_date': '2026-08-03T10:00:00.000', // Monday
        'is_active': true,
      });
      expect(migrated.scheduledWeekdays, [DateTime.monday]);
      expect(migrated.totalWeeklySlots, 1);
    });
  });

  group('Round-trip', () {
    test('new model serializes and deserializes identically', () {
      final original = MedicationReminderModel(
        id: 42,
        medicationName: 'أدوية الكبد',
        conditionName: 'قصور الكبد',
        startDate: DateTime(2026, 8, 1),
        weeklySchedule: [
          PlanDaySchedule(
            weekday: DateTime.monday,
            slots: const [
              MedicationTimeSlot(
                hour: 8,
                minute: 0,
                dose: DoseAmount(amount: 0.5, unit: DoseUnit.pill),
                method: AdministrationMethod.emptyStomach,
              ),
            ],
          ),
        ],
        logs: const [
          ReminderLog(
            id: 1,
            scheduledTime: null,
            takenAt: null,
            taken: false,
          ),
        ],
      );

      final restored = MedicationReminderModel.fromJson(original.toJson());
      expect(restored.id, 42);
      expect(restored.medicationName, 'أدوية الكبد');
      expect(restored.conditionName, 'قصور الكبد');
      expect(restored.slotsFor(DateTime.monday).single.dose.displayLabel, 'نصف قرص');
      expect(restored.slotsFor(DateTime.monday).single.method, AdministrationMethod.emptyStomach);
    });
  });

  group('Adherence', () {
    test('adherence counts expected doses since start', () {
      final reminder = MedicationReminderModel(
        id: 1,
        medicationName: 'X',
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        weeklySchedule: [
          PlanDaySchedule(
            weekday: DateTime.now().subtract(const Duration(days: 1)).weekday,
            slots: const [
              MedicationTimeSlot(
                hour: 8,
                minute: 0,
                dose: DoseAmount(amount: 1, unit: DoseUnit.pill),
                method: AdministrationMethod.oral,
              ),
            ],
          ),
          PlanDaySchedule(
            weekday: DateTime.now().weekday,
            slots: const [
              MedicationTimeSlot(
                hour: 8,
                minute: 0,
                dose: DoseAmount(amount: 1, unit: DoseUnit.pill),
                method: AdministrationMethod.oral,
              ),
            ],
          ),
        ],
        logs: const [
          ReminderLog(id: 1, scheduledTime: null, takenAt: null, taken: true),
        ],
      );
      // 2 أيام متوقع = جرعتان، متاخد واحدة
      expect(reminder.adherenceRate, closeTo(0.5, 0.001));
    });
  });
}
