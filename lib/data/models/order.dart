import 'package:freezed_annotation/freezed_annotation.dart';

import 'cart_item.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
abstract class Orders with _$Orders {
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  factory Orders(
      {String? uid,
      required List<CartItem> products,
      required double total,
      required String orderId,
      bool? isAccepted,
      bool? isCancelled,
      bool? isActivity,
      required DateTime date}) = _Orders;
  factory Orders.fromJson(Map<String, dynamic> json) => _$OrdersFromJson(json);
}
