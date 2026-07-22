import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/card_item.dart';
import '../theme/app_theme.dart';

class PurchaseModal extends StatefulWidget {
  final CardItem card;
  final Future<bool> Function(String receiver, String pin) onPurchase;

  const PurchaseModal({super.key, required this.card, required this.onPurchase});

  @override
  State<PurchaseModal> createState() => _PurchaseModalState();
}

class _PurchaseModalState extends State<PurchaseModal> {
  final _receiverController = TextEditingController();
  final _pinController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _receiverController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _handlePurchase() async {
    final receiver = _receiverController.text.trim();
    final pin = _pinController.text.trim();

    if (receiver.isEmpty || receiver.length < 11) {
      _showSnackBar('برجاء إدخال رقم صحيح');
      return;
    }
    if (pin.isEmpty || pin.length < 6) {
      _showSnackBar('برجاء إدخال الرقم السري (6 أرقام)');
      return;
    }

    setState(() => _isLoading = true);

    final success = await widget.onPurchase(receiver, pin);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      _showSnackBar('تم الشحن بنجاح ✅');
      Navigator.of(context).pop();
    } else {
      _showSnackBar('فشل الشحن، حاول مرة أخرى ❌');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: AppTheme.darkText,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.card;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'شراء ${card.name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.darkText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            const Text(
              'ادخل رقم المستلم والرقم السري',
              style: TextStyle(fontSize: 13, color: AppTheme.greyText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // رقم المستلم
            const Align(
              alignment: Alignment.centerRight,
              child: Text('📱 رقم المستلم', style: TextStyle(fontSize: 13, color: Color(0xFF4B5563))),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _receiverController,
              keyboardType: TextInputType.phone,
              maxLength: 11,
              textDirection: TextDirection.ltr,
              decoration: const InputDecoration(
                hintText: '01xxxxxxxxx',
                counterText: '',
              ),
            ),
            const SizedBox(height: 12),

            // الرقم السري
            const Align(
              alignment: Alignment.centerRight,
              child: Text('🔐 الرقم السري (6 أرقام)', style: TextStyle(fontSize: 13, color: Color(0xFF4B5563))),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              obscureText: true,
              textDirection: TextDirection.ltr,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: '******',
                counterText: '',
              ),
            ),
            const SizedBox(height: 8),

            // الأزرار
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFE5E7EB),
                      foregroundColor: const Color(0xFF374151),
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('إلغاء', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handlePurchase,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryRed,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppTheme.lightRed,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('شحن', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
