import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';

class NotificationsCubit extends Cubit<List<AppNotification>> {
  NotificationsCubit(this._repository) : super(const []) {
    emit(_repository.getNotifications());
  }

  final NotificationsRepository _repository;
}
