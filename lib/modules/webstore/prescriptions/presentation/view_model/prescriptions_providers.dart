import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart' show XFile;
import 'package:erp/core/providers/core_providers.dart';
import 'package:erp/modules/webstore/prescriptions/data/datasource/prescriptions_remote_datasource.dart';
import 'package:erp/modules/webstore/prescriptions/data/repositories/prescriptions_repository.dart';
import 'package:erp/modules/webstore/prescriptions/data/models/prescription_model.dart';

// ─── Data Layer Providers ──────────────────────────────────────────

final prescriptionsRemoteDataSourceProvider = Provider<PrescriptionsRemoteDataSource>((ref) {
  return PrescriptionsRemoteDataSource(ref.watch(networkServiceProvider));
});

final prescriptionsRepositoryProvider = Provider<IPrescriptionsRepository>((ref) {
  return PrescriptionsRepository(ref.watch(prescriptionsRemoteDataSourceProvider));
});

// ─── Prescription List State Notifier ──────────────────────────────────

class PrescriptionsState {
  final AsyncValue<List<PrescriptionModel>> prescriptions;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  PrescriptionsState({
    required this.prescriptions,
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  PrescriptionsState copyWith({
    AsyncValue<List<PrescriptionModel>>? prescriptions,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return PrescriptionsState(
      prescriptions: prescriptions ?? this.prescriptions,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

final prescriptionsVmProvider = NotifierProvider<PrescriptionsViewModel, PrescriptionsState>(() {
  return PrescriptionsViewModel();
});

class PrescriptionsViewModel extends Notifier<PrescriptionsState> {
  @override
  PrescriptionsState build() {
    Future.microtask(() => fetchFirstPage());
    return PrescriptionsState(prescriptions: const AsyncValue.loading());
  }

  IPrescriptionsRepository get _repository => ref.read(prescriptionsRepositoryProvider);

  Future<void> fetchFirstPage() async {
    state = state.copyWith(prescriptions: const AsyncValue.loading(), currentPage: 1, hasMore: true);
    final result = await _repository.getPrescriptions(page: 1);

    result.when(
      success: (paginated) {
        state = state.copyWith(
          prescriptions: AsyncValue.data(paginated.data),
          currentPage: 1,
          hasMore: paginated.hasMore,
        );
      },
      failure: (error) {
        state = state.copyWith(
          prescriptions: AsyncValue.error(error.message, StackTrace.current),
        );
      },
    );
  }

  Future<void> fetchNextPage() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);
    final nextPage = state.currentPage + 1;
    final result = await _repository.getPrescriptions(page: nextPage);

    result.when(
      success: (paginated) {
        final currentItems = state.prescriptions.value ?? [];
        state = state.copyWith(
          prescriptions: AsyncValue.data([...currentItems, ...paginated.data]),
          currentPage: nextPage,
          hasMore: paginated.hasMore,
          isLoadingMore: false,
        );
      },
      failure: (error) {
        state = state.copyWith(isLoadingMore: false);
      },
    );
  }

  Future<void> deletePrescription(int id) async {
    final currentItems = state.prescriptions.value ?? [];
    // Optimistic UI updates
    state = state.copyWith(
      prescriptions: AsyncValue.data(currentItems.where((p) => p.id != id).toList()),
    );

    final result = await _repository.deletePrescription(id);

    result.when(
      success: (_) {
        // Confirmed deleted
      },
      failure: (error) {
        // Rollback on failure
        state = state.copyWith(prescriptions: AsyncValue.data(currentItems));
      },
    );
  }

  Future<bool> editPrescription(int id, {required String newNote, required String currentImagePath, XFile? newImageFile}) async {
    final currentItems = state.prescriptions.value ?? [];

    final result = await _repository.updatePrescription(
      id,
      newImageFile: newImageFile,
      currentImagePath: currentImagePath,
      note: newNote,
    );

    return result.when(
      success: (updated) {
        state = state.copyWith(
          prescriptions: AsyncValue.data(
            currentItems.map((p) => p.id == id ? updated : p).toList(),
          ),
        );
        return true;
      },
      failure: (error) {
        return false;
      },
    );
  }

  void addPrescriptionLocally(PrescriptionModel prescription) {
    final currentItems = state.prescriptions.value ?? [];
    state = state.copyWith(
      prescriptions: AsyncValue.data([prescription, ...currentItems]),
    );
  }
}

// ─── Upload Prescription State Notifier ────────────────────────────────

class UploadPrescriptionState {
  final XFile? pickedFile;
  final double uploadProgress;
  final bool isUploading;
  final bool success;
  final String? errorMessage;

  UploadPrescriptionState({
    this.pickedFile,
    this.uploadProgress = 0.0,
    this.isUploading = false,
    this.success = false,
    this.errorMessage,
  });

  UploadPrescriptionState copyWith({
    XFile? pickedFile,
    double? uploadProgress,
    bool? isUploading,
    bool? success,
    String? errorMessage,
  }) {
    return UploadPrescriptionState(
      pickedFile: pickedFile ?? this.pickedFile,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      isUploading: isUploading ?? this.isUploading,
      success: success ?? this.success,
      errorMessage: errorMessage,
    );
  }
}

final uploadPrescriptionVmProvider =
    NotifierProvider<UploadPrescriptionViewModel, UploadPrescriptionState>(() {
  return UploadPrescriptionViewModel();
});

class UploadPrescriptionViewModel extends Notifier<UploadPrescriptionState> {
  @override
  UploadPrescriptionState build() {
    return UploadPrescriptionState();
  }

  void setPickedFile(XFile? file) {
    state = state.copyWith(pickedFile: file, success: false, uploadProgress: 0.0);
  }

  Future<void> upload({required String note}) async {
    final file = state.pickedFile;
    if (file == null) {
      state = state.copyWith(errorMessage: 'برجاء اختيار صورة أولاً');
      return;
    }

    state = state.copyWith(isUploading: true, uploadProgress: 0.0, success: false);

    try {
      // Send the image file with the prescription in a single request
      final repository = ref.read(prescriptionsRepositoryProvider);
      final result = await repository.createPrescription(
        imageFile: file,
        note: note,
        onProgress: (progress) {
          state = state.copyWith(uploadProgress: progress);
        },
      );

      result.when(
        success: (prescription) {
          // Add to local list of prescriptions to show instantly
          ref.read(prescriptionsVmProvider.notifier).addPrescriptionLocally(prescription);
          state = state.copyWith(isUploading: false, success: true, uploadProgress: 1.0);
        },
        failure: (error) {
          state = state.copyWith(isUploading: false, errorMessage: error.message);
        },
      );
    } catch (e) {
      state = state.copyWith(isUploading: false, errorMessage: e.toString());
    }
  }

  void reset() {
    state = UploadPrescriptionState();
  }
}
