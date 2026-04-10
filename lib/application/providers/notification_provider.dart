import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:owndo/data/notifications/notification_service.dart';

part 'notification_provider.g.dart';

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  return NotificationService();
}
