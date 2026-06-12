import '../entities/wallet_data.dart';

abstract class WalletRepository {
  WalletData getWallet();
}
