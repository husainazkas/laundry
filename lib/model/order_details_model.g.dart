// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetails _$OrderDetailsFromJson(Map<String, dynamic> json) {
  return OrderDetails(
    service: json['service'] as String,
    price: json['price'] as int,
    status: json['status'] as String,
    startDate: OrderDetails._timestampFormatter(json['start_date']),
    endDate: OrderDetails._timestampFormatter(json['end_date']),
  );
}

Map<String, dynamic> _$OrderDetailsToJson(OrderDetails instance) =>
    <String, dynamic>{
      'service': instance.service,
      'status': instance.status,
      'price': instance.price,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
    };
