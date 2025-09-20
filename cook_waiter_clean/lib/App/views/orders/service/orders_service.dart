import 'package:cook_waiter/App/ApiRoutes/api_routes.dart';
import 'package:cook_waiter/App/Storage/session_storage.dart';
import 'package:cook_waiter/App/service/app_service.dart';
import 'package:cook_waiter/App/views/orders/data/common_request_data.dart';
import 'package:cook_waiter/App/views/orders/data/notification_response_data.dart';
import 'package:cook_waiter/App/views/orders/data/orders_data.dart';
import 'package:cook_waiter/App/views/orders/data/orders_detail_response.dart';
import 'package:cook_waiter/App/views/orders/data/payment_history_data.dart';
import 'package:cook_waiter/App/views/orders/data/update_payment_response_data.dart';

Future<OrderListResponseData> callOrdersApi(
  String companyId,
  int orderStatus,
) async {
  final userSession = SessionStorage.getUserSession();
  if (userSession == null) {
    throw Exception("No user session found. Please log in again.");
  }

  return await ApiService.get<OrderListResponseData>(
    endpoint: ApiRoutes.orders,
    fromJson: (json) => OrderListResponseData.fromJson(json),
    token: "",
    queryParams: {
      "Company_Id": userSession.companyId,
      "orderstatus": orderStatus.toString(),
    },
  );
}

Future<StatusUpdateResponseData> callStatusUpdateApi(
  String companyId,
  String sno,
  String curOrderStatus,
) async {
  print("DEBUG : ORDER STATUS $curOrderStatus");

  // Get logged-in user session
  final userSession = SessionStorage.getUserSession();
  if (userSession == null) {
    throw Exception("No user session found. Please log in again.");
  }

  return await ApiService.post<StatusUpdateResponseData>(
    endpoint: ApiRoutes.updateOrder,
    fromJson: (json) => StatusUpdateResponseData.fromJson(json),
    token: "",
    data: StatusUpdateRequestData(
      curOrderStatus: curOrderStatus,
      sno: sno,
      chefId: userSession.sno, // ✅ Pass logged-in user's sno
    ).toJson(),
    queryParams: {"Company_Id": userSession.companyId},
  );
}

Future<StatusUpdateResponseData> changeOrderStatusApi(
  String companyId,
  String orderId,
  String sno,
) async {
  final userSession = SessionStorage.getUserSession();
  if (userSession == null) {
    throw Exception("No user session found. Please log in again.");
  }
  return await ApiService.post<StatusUpdateResponseData>(
    endpoint: ApiRoutes.changeOrderStatus,
    fromJson: (json) => StatusUpdateResponseData.fromJson(json),
    token: "",
    data: StatusUpdateRequestData(
            curOrderStatus: orderId, sno: sno, chefId: userSession.sno)
        .toJson(),
    queryParams: {"Company_Id": companyId},
  );
}

Future<StatusUpdateResponseData> orderDelayApi(
  String companyId,
  String orderId,
  String sno,
) async {
    final userSession = SessionStorage.getUserSession();
  if (userSession == null) {
    throw Exception("No user session found. Please log in again.");
  }

  return await ApiService.post<StatusUpdateResponseData>(
    endpoint: ApiRoutes.updateOrderDelay,
    fromJson: (json) => StatusUpdateResponseData.fromJson(json),
    token: "",
    data: OrderDelayRequestData(orderId: orderId, sno: sno ,      chefId: userSession.sno, // ✅ Pass logged-in user's sno
).toJson(),
    queryParams: {"Company_Id": userSession.companyId ,},
  );
}

Future<NotificationResponseData> notificationApi(
  String companyId,
) async {
    final userSession = SessionStorage.getUserSession();
  if (userSession == null) {
    throw Exception("No user session found. Please log in again.");
  }

  return await ApiService.get<NotificationResponseData>(
    endpoint: ApiRoutes.notificationApi,
    fromJson: (json) => NotificationResponseData.fromJson(json),
    token: "",
    queryParams: {"Company_Id": userSession.companyId},
  );
}

Future<OrderDetailResponseData> orderDetailAPi(
  // String companyId,
  String orderId,
) async {
  return await ApiService.get<OrderDetailResponseData>(
    endpoint: ApiRoutes.orderDetailAPi,
    fromJson: (json) => OrderDetailResponseData.fromJson(json),
    token: "",
    queryParams: {
      // "Company_Id": companyId,
      "orderId": orderId.toString(),
    },
  );
}


Future<PaymentHistoryResponseData> getRecentPayment(
  // String companyId,
  String companyId,
) async {
  return await ApiService.get<PaymentHistoryResponseData>(
    endpoint: ApiRoutes.paymentHistory,
    fromJson: (json) => PaymentHistoryResponseData.fromJson(json),
    token: "",
    queryParams: {
      "Company_Id": companyId,
    },
  );
}


Future<UpdatePaymentResponseData> updatePaymentAPi(
  // String companyId,
  String orderId,
) async {
  return await ApiService.get<UpdatePaymentResponseData>(
    endpoint: ApiRoutes.paymentUpdate,
    fromJson: (json) => UpdatePaymentResponseData.fromJson(json),
    token: "",
    queryParams: {
      // "Company_Id": companyId,
      "orderId": orderId.toString(),
    },
  );
}