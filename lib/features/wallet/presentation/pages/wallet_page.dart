import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/wallet_data.dart';
import '../cubit/wallet_cubit.dart';
import '../widgets/wallet_tiles.dart';

/// Wallet tab: balance card, payment methods and recent transactions.
class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<WalletCubit, WalletData?>(
        builder: (context, wallet) {
          if (wallet == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 12, 22, 14),
                  child: Text(AppStrings.wallet, style: AppTextStyles.h3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    20, 0, 20, AppDimens.bottomNavSafe),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BalanceCard(balance: wallet.balance),
                    const SizedBox(height: 24),
                    Text(AppStrings.paymentMethods,
                        style: AppTextStyles.listTitle.copyWith(fontSize: 14)),
                    const SizedBox(height: 12),
                    _SectionCard(
                      child: Column(
                        children: [
                          for (final card in wallet.cards)
                            WalletCardTile(card: card),
                          const AddCardTile(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(AppStrings.recentTransactions,
                        style: AppTextStyles.listTitle.copyWith(fontSize: 14)),
                    const SizedBox(height: 12),
                    _SectionCard(
                      child: Column(
                        children: [
                          for (var i = 0;
                              i < wallet.transactions.length;
                              i++)
                            WalletTransactionTile(
                              txn: wallet.transactions[i],
                              showDivider:
                                  i != wallet.transactions.length - 1,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.3),
            blurRadius: 26,
            offset: const Offset(0, 10),
            spreadRadius: -20,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.balance});

  final String balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.brandSweep,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 36,
            offset: const Offset(0, 18),
            spreadRadius: -16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.availableBalance,
              style: AppTextStyles.bodySm
                  .copyWith(color: Colors.white.withOpacity(0.85))),
          const SizedBox(height: 6),
          Text(balance,
              style: AppTextStyles.display.copyWith(
                  color: Colors.white, fontSize: 36, letterSpacing: -1)),
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(
                child: _BalanceAction(
                  label: AppStrings.addFunds,
                  filled: true,
                  icon: Icons.add_rounded,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _BalanceAction(label: AppStrings.send),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceAction extends StatelessWidget {
  const _BalanceAction({
    required this.label,
    this.filled = false,
    this.icon,
  });

  final String label;
  final bool filled;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: filled ? Colors.white : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: AppColors.primaryDark),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.listTitle.copyWith(
                  color: filled ? AppColors.primaryDark : Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}
