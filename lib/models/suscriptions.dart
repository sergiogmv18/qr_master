import 'package:floor/floor.dart';
import 'package:qr_master/models/model_base.dart';

@Entity(tableName: 'subscription_purchases')
class SubscriptionPurchase extends ModelBase {
  final String? productId;              // ID del producto en Store (Google Play/App Store)
  final String? purchaseToken;          // Token único de la compra
  final String? orderId;                // ID de la orden
  final DateTime? purchaseDate;         // Fecha de compra
  final DateTime? expiryDate;         // Fecha de expiración (null si es vitalicia)
  final String? status;     // Estado actual
  final bool? autoRenewing;             // Si se renueva automáticamente
  final String? packageName;            // Nombre del paquete de la app
  final String? obfuscatedAccountId;   // ID enmascarado de la cuenta
  final String? obfuscatedProfileId;   // ID enmascarado del perfil
  final String? purchaseType;     // Tipo de compra
  final String? originalJson;          // JSON original de la respuesta
  final String? verificationData;      // Datos para verificar la compra
  final String? userId;                // ID de usuario en tu sistema
  final int quantity;                  // Cantidad (normalmente 1)

  SubscriptionPurchase({
    required super.serverId,
    super.id,
    super.needToSynchronize,
    super.uuid,
    this.productId,
    this.purchaseToken,
    this.orderId,
    this.purchaseDate,
    this.expiryDate,
    this.status,
    this.autoRenewing,
    this.packageName,
    this.obfuscatedAccountId,
    this.obfuscatedProfileId,
    this.purchaseType,
    this.originalJson,
    this.verificationData,
    this.userId,
    this.quantity = 1,
  });

 

  // CopyWith method
  SubscriptionPurchase copyWith({
    int? serverId,
    int? id,
    bool? needToSynchronize,
    String? uuid,
    String? productId,
    String? purchaseToken,
    String? orderId,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    String? status,
    bool? autoRenewing,
    String? packageName,
    String? obfuscatedAccountId,
    String? obfuscatedProfileId,
    String? purchaseType,
    String? originalJson,
    String? verificationData,
    String? userId,
    int? quantity,
  }) {
    return SubscriptionPurchase(
      serverId: serverId ?? this.serverId,
      id: id ?? this.id,
      needToSynchronize: needToSynchronize ?? this.needToSynchronize,
      uuid: uuid ?? this.uuid,
      productId: productId ?? this.productId,
      purchaseToken: purchaseToken ?? this.purchaseToken,
      orderId: orderId ?? this.orderId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      status: status ?? this.status,
      autoRenewing: autoRenewing ?? this.autoRenewing,
      packageName: packageName ?? this.packageName,
      obfuscatedAccountId: obfuscatedAccountId ?? this.obfuscatedAccountId,
      obfuscatedProfileId: obfuscatedProfileId ?? this.obfuscatedProfileId,
      purchaseType: purchaseType ?? this.purchaseType,
      originalJson: originalJson ?? this.originalJson,
      verificationData: verificationData ?? this.verificationData,
      userId: userId ?? this.userId,
      quantity: quantity ?? this.quantity,
    );
  }

  // Helper methods
  bool get isActive => status == SubscriptionStatus.active;
  bool get isExpired => status == SubscriptionStatus.xpired;
  bool get isCancelled => status == SubscriptionStatus.cancelled;
  bool get willAutoRenew => autoRenewing?? true  && isActive;
  
  // Equality comparison
  @override
  bool operator ==(Object other) => identical(this, other) ||
      other is SubscriptionPurchase &&
          runtimeType == other.runtimeType &&
          serverId == other.serverId &&
          id == other.id &&
          needToSynchronize == other.needToSynchronize &&
          uuid == other.uuid &&
          productId == other.productId &&
          purchaseToken == other.purchaseToken &&
          orderId == other.orderId &&
          purchaseDate == other.purchaseDate &&
          expiryDate == other.expiryDate &&
          status == other.status &&
          autoRenewing == other.autoRenewing &&
          packageName == other.packageName &&
          obfuscatedAccountId == other.obfuscatedAccountId &&
          obfuscatedProfileId == other.obfuscatedProfileId &&
          purchaseType == other.purchaseType &&
          userId == other.userId &&
          quantity == other.quantity;

  @override
  int get hashCode =>
      serverId.hashCode ^
      id.hashCode ^
      needToSynchronize.hashCode ^
      uuid.hashCode ^
      productId.hashCode ^
      purchaseToken.hashCode ^
      orderId.hashCode ^
      purchaseDate.hashCode ^
      expiryDate.hashCode ^
      status.hashCode ^
      autoRenewing.hashCode ^
      packageName.hashCode ^
      obfuscatedAccountId.hashCode ^
      obfuscatedProfileId.hashCode ^
      purchaseType.hashCode ^
      userId.hashCode ^
      quantity.hashCode;

  @override
  String toString() {
    return 'SubscriptionPurchase{serverId: $serverId, productId: $productId, status: $status, purchaseDate: $purchaseDate, expiryDate: $expiryDate, autoRenewing: $autoRenewing}';
  }

  // Serialization
  factory SubscriptionPurchase.fromJson(Map<String, dynamic> json) {
    return SubscriptionPurchase(
      serverId: json['id'] as int,
      productId: json['product_id'] as String,
      purchaseToken: json['purchase_token'] as String,
      orderId: json['order_id'] as String,
      purchaseDate: DateTime.parse(json['purchase_date'] as String),
      expiryDate: json['expiry_date'] != null 
          ? DateTime.parse(json['expiry_date'] as String)
          : null,
      status: json['status'],
      autoRenewing: json['auto_renewing'] as bool,
      packageName: json['package_name'] as String,
      obfuscatedAccountId: json['obfuscated_account_id']?.toString(),
      obfuscatedProfileId: json['obfuscated_profile_id']?.toString(),
      purchaseType: json['purchase_type'],
      originalJson: json['original_json']?.toString(),
      verificationData: json['verification_data']?.toString(),
      userId: json['user_id']?.toString(),
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': serverId,
      'product_id': productId,
      'purchase_token': purchaseToken,
      'order_id': orderId,
      'purchase_date': purchaseDate?.toIso8601String(),
      'expiry_date': expiryDate?.toIso8601String(),
      'status': status,
      'auto_renewing': autoRenewing,
      'package_name': packageName,
      'obfuscated_account_id': obfuscatedAccountId,
      'obfuscated_profile_id': obfuscatedProfileId,
      'purchase_type': purchaseType,
      'original_json': originalJson,
      'verification_data': verificationData,
      'user_id': userId,
      'quantity': quantity,
    };
  }

  // Factory para nuevas compras
  factory SubscriptionPurchase.createNew({
    String? productId,
    String? purchaseToken,
    String? orderId,
    String? packageName,
    String? userId,
    String purchaseType = PurchaseType.subscription,
  }) {
    return SubscriptionPurchase(
      serverId: 0,
      productId: productId,
      purchaseToken: purchaseToken,
      orderId: orderId,
      purchaseDate: DateTime.now(),
      status: SubscriptionStatus.pending,
      autoRenewing: false,
      packageName: packageName,
      purchaseType: purchaseType,
      userId: userId,
    );
  }

  
}

 // Enums para estados y tipos
 class SubscriptionStatus {
  static const String pending = "pending";        // Pendiente de confirmación
  static const String active = "active";         // Activa
  static const String xpired = "xpired";        // Expirada
  static const String cancelled = "cancelled";      // Cancelada
  static const String inGracePeriod = "inGracePeriod";  // En período de gracia
  static const String paused = "paused";         // Pausada
  static const String onHold = "onHold";         // En espera
  static const String refunded = "refunded";        // Reembolsada
}
  class PurchaseType {
  static const String subscription    = "subscription";
  static const String oneTimePurchase = "oneTimePurchase";
  static const String consumable      = "consumable";
  }