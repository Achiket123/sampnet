import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';
import '../../../domain/use_cases/get_onboarding_progress_usecase.dart';
import '../../../domain/use_cases/update_onboarding_progress_usecase.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final GetOnboardingProgressUseCase getOnboardingProgressUseCase;
  final UpdateOnboardingProgressUseCase updateOnboardingProgressUseCase;

  OnboardingBloc({
    required this.getOnboardingProgressUseCase,
    required this.updateOnboardingProgressUseCase,
  }) : super(OnboardingInitial()) {
    on<LoadOnboardingProgress>((event, emit) async {
      emit(OnboardingLoading());
      try {
        final progress = await getOnboardingProgressUseCase(event.userId);
        emit(OnboardingLoaded(progress));
      } catch (e) {
        debugPrint("ONBOARDING ERROR: ${e.toString()}");
        emit(OnboardingError(e.toString()));
      }
    });

    on<UpdateOnboardingStep>((event, emit) async {
      try {
        await updateOnboardingProgressUseCase(event.progress);
        emit(OnboardingLoaded(event.progress));
      } catch (e) {
        debugPrint("ONBOARDING ERROR: ${e.toString()}");
        emit(OnboardingError(e.toString()));
      }
    });
  }
}
