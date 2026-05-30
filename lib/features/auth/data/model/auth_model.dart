import 'package:hackathon/features/auth/domain/entity/user_entity.dart';
import 'package:hackathon/globals/models/user_model.dart';

class AuthResponseModel extends AuthResponseEntity {
  AuthResponseModel({required String token, required UserModel userModel})
      : super(token: token, userEntity: userModel);
}
