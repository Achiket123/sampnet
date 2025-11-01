import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/dashboards/data/models/emp_model.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/constants/strings.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_io/jwt_io.dart';

abstract class ValidateEmpDataSource {
  Future<Either<ErrorModel, bool>> validateEmployee(String token);
}

class ValidateEmpDataSourceImpl with Strings implements ValidateEmpDataSource {
  final http.Client client;
  ValidateEmpDataSourceImpl({required this.client});
  @override
  Future<Either<ErrorModel, bool>> validateEmployee(String token) async {
    try {
      final url = Uri.parse(ApiConstants.validateEmployee);
      final response = await client.get(url, headers: {
        'Authorization': token,
      });
      if (response.statusCode == 200) {
        final empToken = response.headers['authorization'];

        Hive.box(Strings.authBox).put(Strings.employeeTokenKey, empToken);
        User.employeeToken = empToken!;
        User.employee =
            EmpModel.fromJson(JwtToken.payload(empToken)['employee']);
        return right(true);
      }
      return left(ErrorModel(message: response.body));
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }
}
