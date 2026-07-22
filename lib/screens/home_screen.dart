import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/auth_service.dart';
import '../services/cards_service.dart';
import '../widgets/card_widget.dart';
import '../widgets/purchase_modal.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthService>().login();
      context.read<CardsService>().fetchCards();
    });
  }

  void _showPurchaseModal(BuildContext context, dynamic card) {
    showDialog(
      context: context,
      builder: (ctx) => PurchaseModal(
        card: card,
        onPurchase: (receiver, pin) {
          return context.read<CardsService>().purchaseCard(
                card: card,
                receiverNumber: receiver,
                pin: pin,
              );
        },
      ),
    );
  }

  Future<void> _openTelegram() async {
    final uri = Uri.parse('https://t.me/ESIAM_HACKER');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthService>(
        builder: (context, auth, _) {
          if (auth.isLoading) {
            return _buildLoadingScreen(auth.statusText);
          }

          return SafeArea(
            child: Column(
              children: [
                _buildHeader(auth),
                Expanded(
                  child: Consumer<CardsService>(
                    builder: (context, cardsService, _) {
                      if (cardsService.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: AppTheme.primaryRed),
                        );
                      }

                      return ListView(
                        padding: const EdgeInsets.only(bottom: 40),
                        children: [
                          _buildSection(
                            title: '🏷️ كروت الفكة',
                            cards: cardsService.fakkaCards,
                          ),
                          _buildSection(
                            title: '🧞 كروت المارد',
                            cards: cardsService.maredCards,
                          ),
                          _buildTelegramButton(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingScreen(String status) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: AppTheme.primaryRed,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            status,
            style: const TextStyle(fontSize: 14, color: AppTheme.greyText),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AuthService auth) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.primaryRed,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🪙 Cards Fakka',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'مرحباً، ${auth.msisdn}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.lightRed,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  auth.logout();
                  auth.login();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '🚪 خروج',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            auth.statusText,
            style: const TextStyle(fontSize: 13, color: AppTheme.lightRed),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List cards}) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.darkText,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: cards.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final card = cards[index];
                return CardWidget(
                  card: card,
                  onBuy: () => _showPurchaseModal(context, card),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelegramButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Center(
        child: InkWell(
          onTap: _openTelegram,
          borderRadius: BorderRadius.circular(99),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              border: Border.all(color: const Color(0xFF06B6D4)),
              borderRadius: BorderRadius.circular(99),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '📢 اشترك في قناة التليجرام  ',
                  style: TextStyle(fontSize: 14, color: AppTheme.cyan),
                ),
                Text(
                  '@ESIAM_HACKER',
                  style: TextStyle(fontSize: 12, color: AppTheme.darkCyan),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
