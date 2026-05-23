/// CustomerOrder model for shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

/// An order placed by an authenticated customer.
final class CustomerOrder {
  const CustomerOrder({
    required this.id,
    required this.name,
    required this.orderNumber,
    required this.totalPrice,
    required this.currencyCode,
    required this.processedAt,
    required this.financialStatus,
    required this.fulfillmentStatus,
    this.statusUrl,
    this.lineItems = const [],
  });

  factory CustomerOrder.fromJson(Map<String, dynamic> json) {
    final totalRaw = json['totalPriceV2'] as Map<String, dynamic>? ?? {};
    final lineEdges =
        (json['lineItems'] as Map<String, dynamic>?)?['edges'] as List<dynamic>? ?? [];

    return CustomerOrder(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      orderNumber: json['orderNumber'] as int? ?? 0,
      totalPrice:
          double.tryParse(totalRaw['amount']?.toString() ?? '0') ?? 0,
      currencyCode: totalRaw['currencyCode'] as String? ?? 'USD',
      processedAt:
          DateTime.tryParse(json['processedAt'] as String? ?? '') ??
              DateTime.now(),
      financialStatus: json['financialStatus'] as String? ?? '',
      fulfillmentStatus: json['fulfillmentStatus'] as String? ?? '',
      statusUrl: json['statusUrl'] as String?,
      lineItems: lineEdges
          .map(
            (e) => OrderLineItem.fromJson(
              (e as Map<String, dynamic>)['node'] as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  final String id;
  final String name;
  final int orderNumber;
  final double totalPrice;
  final String currencyCode;
  final DateTime processedAt;
  final String financialStatus;
  final String fulfillmentStatus;
  final String? statusUrl;
  final List<OrderLineItem> lineItems;

  bool get isPaid => financialStatus.toUpperCase() == 'PAID';
  bool get isFulfilled => fulfillmentStatus.toUpperCase() == 'FULFILLED';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'orderNumber': orderNumber,
        'totalPriceV2': {
          'amount': totalPrice.toStringAsFixed(2),
          'currencyCode': currencyCode,
        },
        'processedAt': processedAt.toIso8601String(),
        'financialStatus': financialStatus,
        'fulfillmentStatus': fulfillmentStatus,
        if (statusUrl != null) 'statusUrl': statusUrl,
      };
}

/// A single line item within a customer order.
final class OrderLineItem {
  const OrderLineItem({
    required this.title,
    required this.quantity,
    required this.currentTotalPrice,
    required this.currencyCode,
    this.variantTitle,
    this.imageUrl,
  });

  factory OrderLineItem.fromJson(Map<String, dynamic> json) {
    final priceRaw =
        json['currentTotalPrice'] as Map<String, dynamic>? ?? {};
    return OrderLineItem(
      title: json['title'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      currentTotalPrice:
          double.tryParse(priceRaw['amount']?.toString() ?? '0') ?? 0,
      currencyCode: priceRaw['currencyCode'] as String? ?? 'USD',
      variantTitle:
          (json['variant'] as Map<String, dynamic>?)?['title'] as String?,
      imageUrl: ((json['variant'] as Map<String, dynamic>?)?['image']
              as Map<String, dynamic>?)?['url'] as String?,
    );
  }

  final String title;
  final int quantity;
  final double currentTotalPrice;
  final String currencyCode;
  final String? variantTitle;
  final String? imageUrl;
}
