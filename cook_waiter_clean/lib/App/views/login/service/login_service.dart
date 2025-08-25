import 'package:cook_waiter/App/ApiRoutes/api_routes.dart';
import 'package:cook_waiter/App/service/app_service.dart';
import 'package:cook_waiter/App/views/login/data/login_data.dart';

Future<LoginResponseData> login(LoginRequestData request) async {
  return await ApiService.post<LoginResponseData>(
    endpoint: ApiRoutes.login,
    fromJson: (json) => LoginResponseData.fromJson(json),
    data: request.toJson(),
  );
}
