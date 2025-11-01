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
  AuthBloc(
      {required SignUpUsecase signUpUsecase,
      required SignInUsecase signInUsecase,
      required GetTokenUsecase getTokenUsecase})
      : _signUpUsecase = signUpUsecase,
        _signInUsecase = signInUsecase,
        _getTokenUsecase = getTokenUsecase,
        super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(AuthLoading());
    });
    on<SignUpEvent>((event, emit) async {
      final resolve = await _signUpUsecase.call(event.signUpParams);
      resolve.fold((l) => emit(AuthFailure(message: l.message)),
          (r) => emit(AuthSignUpSuccess(user: r)));
    });
    on<SignInEvent>((event, emit) async {
      final resolve = await _signInUsecase.call(event.signInParams);
      resolve.fold((l) => emit(AuthFailure(message: l.message)),
          (r) => emit(AuthSignInSuccess(user: r)));
    });
    on<GetTokenEvent>((event, emit) async {
      final resolve = await _getTokenUsecase.call(null);
      resolve.fold((l) => emit(AuthFailure(message: l.message)),
          (r) => emit(AuthGetTokenSuccess(token: r)));
    });
  }
}
