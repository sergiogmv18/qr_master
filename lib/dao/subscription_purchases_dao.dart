import 'package:floor/floor.dart';
import 'package:qr_master/dao/repository_base_dao.dart';
import 'package:qr_master/models/suscriptions.dart';

@dao
abstract class SubscriptionPurchasesDao extends RepositoryBaseDao<SubscriptionPurchase> {
  @Query('SELECT * FROM subscription_purchases')
  Future<List<SubscriptionPurchase>> fetchAll();

  @Query('SELECT * FROM subscription_purchases WHERE id = :id')
  Future<SubscriptionPurchase?> fetchById(int id);

  @Query('DELETE FROM subscription_purchases')
  Future<void> deleteAll();

  @Query('SELECT * FROM subscription_purchases WHERE uuid = :uuid')
  Future<SubscriptionPurchase?> getSubscriptionByUuid(String uuid);

  @Query('SELECT * FROM subscription_purchases WHERE product_id = :productId')
  Future<List<SubscriptionPurchase>> getSubscriptionsByProductId(String productId);

  @Query('SELECT * FROM subscription_purchases WHERE user_id = :userId')
  Future<List<SubscriptionPurchase>> getSubscriptionsByUserId(String userId);

 @Query('''
    SELECT * FROM subscription_purchases 
    WHERE status = 1 AND expiry_date > :currentDate
    ORDER BY purchase_date DESC
    LIMIT 1
  ''')
  Future<SubscriptionPurchase?> getActiveSubscription(int currentDate);

  @Query('''
    UPDATE subscription_purchases 
    SET status = :newStatus, updated_at = :updatedAt 
    WHERE uuid = :uuid
  ''')
  Future<void> updateSubscriptionStatus(
    String uuid, 
    int newStatus, 
    int updatedAt
  );

  @Query('''
    SELECT COUNT(*) FROM subscription_purchases 
    WHERE status = 1 AND expiry_date > :currentDate
  ''')
  Future<int?> countActiveSubscriptions(int currentDate);
}