import '../../domain/entities/wallet_data.dart';
import '../../domain/repositories/wallet_repository.dart';

/// Dummy wallet data matching the design.
class WalletRepositoryImpl implements WalletRepository {
  @override
  WalletData getWallet() => const WalletData(
        balance: 'EGP 340.00',
        cards: [
          WalletCard(
            type: WalletCardType.visa,
            title: 'Visa ·· 4291',
            subtitle: 'Expires 08/27',
            isDefault: true,
          ),
          WalletCard(
            type: WalletCardType.cash,
            title: 'Cash',
            subtitle: 'Pay driver directly',
          ),
        ],
      );
}
