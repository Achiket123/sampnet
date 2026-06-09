import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/auth/domain/entity/user_entity.dart';
import 'package:hackathon/features/auth/domain/usecase/auth_params.dart';
import 'package:hackathon/features/auth/domain/usecase/auth_usecase.dart';

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
    on<AuthEvent>((event, emit) {
      emit(AuthLoading());
    });
    on<SignUpEvent>((event, emit) async {
      final resolve = await _signUpUsecase.call(event.signUpParams);
      resolve.fold((l) => emit(AuthFailure(message: l.message)), (r) {
        emit(AuthSignUpSuccess(auth: r));
        _saveTokenUsecase.call(r.token);
      });
    });
    on<SignInEvent>((event, emit) async {
      final resolve = await _signInUsecase.call(event.signInParams);
      resolve.fold((l) => emit(AuthFailure(message: l.message)), (r) {
        emit(AuthSignInSuccess(auth: r));
        _saveTokenUsecase.call(r.token);
      });
    });
    on<GetTokenEvent>((event, emit) async {
      final resolve = _getTokenUsecase.call(null);
      resolve.fold((l) => emit(AuthFailure(message: l.message)),
          (r) => emit(AuthGetTokenSuccess(token: r)));
    });
    on<SendVerificationEmailEvent>((event, emit) async {
      final resolve = await _sendVerificationEmailUsecase.call(null);
      resolve.fold(
        (l) => emit(AuthFailure(message: l.message)),
        (r) => emit(AuthVerificationEmailSent()),
      );
    });
    on<VerifyEmailEvent>((event, emit) async {
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
              meRes.fold(
                (l) => emit(AuthFailure(message: l.message)),
                (res) {
                  _saveTokenUsecase.call(res.token);
                  emit(AuthVerifyEmailSuccess());
                },
              );
            },
          );
        },
      );
    });
    on<GetMeEvent>((event, emit) async {
      final resolve = await _getMeUsecase.call(null);
      resolve.fold(
        (l) => emit(AuthFailure(message: l.message)),
        (r) {
          _saveTokenUsecase.call(r.token);
          emit(AuthGetMeSuccess(auth: r));
        },
      );
    });
  }
}
