import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/wallet_data.dart';
import '../../domain/repositories/wallet_repository.dart';

/// Exposes the wallet view-model to the wallet page.
class WalletCubit extends Cubit<WalletData?> {
  WalletCubit(this._repository) : super(null) {
    emit(_repository.getWallet());
  }

  final WalletRepository _repository;
}
