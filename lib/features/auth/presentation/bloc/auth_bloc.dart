import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/auth/domain/entity/user_entity.dart';
import 'package:hackathon/features/auth/domain/usecase/auth_params.dart';
import 'package:hackathon/features/auth/domain/usecase/auth_usecase.dart';
import 'package:hackathon/globals/constants/user.dart' as app_user;
import 'package:hackathon/services/token_manager.dart';
import 'package:hackathon/dependency_injection.g.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUsecase _signUpUsecase;
  final SignInUsecase _signInUsecase;
  final GetTokenUsecase _getTokenUsecase;
  final SaveTokenUsecase _saveTokenUsecase;
  final SendVerificationEmailUsecase _sendVerificationEmailUsecase;
  final VerifyEmailUsecase _verifyEmailUsecase;
  final GetMeUsecase _getMeUsecase;

  AuthBloc({
    required SignUpUsecase signUpUsecase,
    required SignInUsecase signInUsecase,
    required GetTokenUsecase getTokenUsecase,
    required SaveTokenUsecase saveTokenUsecase,
    required SendVerificationEmailUsecase sendVerificationEmailUsecase,
    required VerifyEmailUsecase verifyEmailUsecase,
    required GetMeUsecase getMeUsecase,
  })  : _signUpUsecase = signUpUsecase,
        _signInUsecase = signInUsecase,
        _getTokenUsecase = getTokenUsecase,
        _saveTokenUsecase = saveTokenUsecase,
        _sendVerificationEmailUsecase = sendVerificationEmailUsecase,
        _verifyEmailUsecase = verifyEmailUsecase,
        _getMeUsecase = getMeUsecase,
        super(AuthInitial()) {
    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      final resolve = await _signUpUsecase.call(event.signUpParams);
      await resolve.fold((l) async => emit(AuthFailure(message: l.message)),
          (r) async {
        emit(AuthSignUpSuccess(auth: r));
        await _saveTokenUsecase.call(r.token);
      });
    });
    on<SignInEvent>((event, emit) async {
      emit(AuthLoading());
      final resolve = await _signInUsecase.call(event.signInParams);
      await resolve.fold((l) async => emit(AuthFailure(message: l.message)),
          (r) async {
        emit(AuthSignInSuccess(auth: r));
        await _saveTokenUsecase.call(r.token);
      });
    });
    on<GetTokenEvent>((event, emit) async {
      emit(AuthLoading());
      final resolve = _getTokenUsecase.call(null);
      resolve.fold((l) => emit(AuthFailure(message: l.message)),
          (r) => emit(AuthGetTokenSuccess(token: r)));
    });
    on<SendVerificationEmailEvent>((event, emit) async {
      emit(AuthLoading());
      final resolve = await _sendVerificationEmailUsecase.call(null);
      resolve.fold(
        (l) => emit(AuthFailure(message: l.message)),
        (r) => emit(AuthVerificationEmailSent()),
      );
    });
    on<VerifyEmailEvent>((event, emit) async {
      emit(AuthLoading());
      final resolve = await _verifyEmailUsecase.call(event.token);
      await resolve.fold(
        (l) async => emit(AuthFailure(message: l.message)),
        (r) async {
          final tokenRes = _getTokenUsecase.call(null);
          await tokenRes.fold(
            (l) async {
              emit(AuthVerifyEmailSuccess());
            },
            (token) async {
              final meRes = await _getMeUsecase.call(null);
              await meRes.fold(
                (l) async => emit(AuthFailure(message: l.message)),
                (res) async {
                  await _saveTokenUsecase.call(res.token);
                  emit(AuthVerifyEmailSuccess());
                },
              );
            },
          );
        },
      );
    });
    on<GetMeEvent>((event, emit) async {
      emit(AuthLoading());
      final resolve = await _getMeUsecase.call(null);
      await resolve.fold(
        (l) async => emit(AuthFailure(message: l.message)),
        (r) async {
          await _saveTokenUsecase.call(r.token);
          emit(AuthGetMeSuccess(auth: r));
        },
      );
    });
    on<SignOutEvent>((event, emit) async {
      emit(AuthLoading());
      getIt<TokenManager>().clearTokens();
      final user = getIt<app_user.User>();
      user.user = null;
      user.token = null;
      user.organisation = null;
      user.employee = null;
      user.employeeToken = null;
      emit(AuthSignOutSuccess(message: 'Signed out'));
    });
  }
}
