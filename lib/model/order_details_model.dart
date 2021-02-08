import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_details_model.g.dart';

@JsonSerializable()
class OrderDetails {
  String service, status;
  int price;
  @JsonKey(name: 'start_date', fromJson: _timestampFormatter)
  DateTime startDate;
  @JsonKey(name: 'end_date', fromJson: _timestampFormatter)
  DateTime endDate;

  static DateTime _timestampFormatter(Timestamp value) => value.toDate();

  OrderDetails(
      {this.service, this.price, this.status, this.startDate, this.endDate});

  factory OrderDetails.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailsToJson(this);
}

enum Sort { asc, desc }
