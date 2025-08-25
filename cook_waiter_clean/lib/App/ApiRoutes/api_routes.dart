class ApiRoutes {
  // static const String baseUrl = 'https://dev.biteqr.in';
    static const String baseUrl = 'https://qa.biteqr.in'; // demo

  static const String login = '/API/LoginAPI/Login';
  static const String orders = '/API/OrderInfo/getAllOrderApp';
  static const String getAllTabel = '/API/OrderInfo/getAllOrder';

  // static const String updateOrderPrepare = '/API/OrderInfo/UpdateOrderPrepare';
  static const String updateOrder = '/API/OrderInfo/UpdateOrderStatus';
  // static const String markDelivered = '/API/OrderInfo/MarkDelivered';
  static const String changeOrderStatus = '/API/OrderInfo/UndoOrderStatus';
  static const String cancelOrder = '/API/OrderInfo/CancelOrder';
  static const String updateOrderDelay = '/API/OrderInfo/UpdateOrderDelay';
  static const String orderDetailAPi = '/API/OrderInfo/GetOrderDetails';
  static const String notificationApi = '/API/OrderInfo/getPaymentInfoApp';

}
