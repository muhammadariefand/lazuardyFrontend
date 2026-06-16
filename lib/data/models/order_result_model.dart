import '../../domain/entities/order_result_entity.dart';

class OrderResultModel extends OrderResultEntity {
  OrderResultModel({
    required super.orderId,
    required super.checkoutUrl,
  });

  factory OrderResultModel.fromJson(Map<String, dynamic> json) {
    return OrderResultModel(
      orderId: json['order_id'] as int,
      checkoutUrl: json['checkout_url'] as String,
    );
  }
}
