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
        transactions: [
          WalletTransaction(
            type: WalletTxnType.trip,
            title: 'Trip to Cairo Festival City',
            date: 'Today · 18:24',
            amount: '– EGP 86',
            isCredit: false,
          ),
          WalletTransaction(
            type: WalletTxnType.topUp,
            title: 'Wallet top-up',
            date: 'Yesterday · 09:10',
            amount: '+ EGP 200',
            isCredit: true,
          ),
          WalletTransaction(
            type: WalletTxnType.trip,
            title: 'Trip to Zamalek',
            date: 'Mar 8 · 14:02',
            amount: '– EGP 74',
            isCredit: false,
          ),
        ],
      );
}
