import 'package:flutter/foundation.dart';
import '../models/card_item.dart';

class CardsService extends ChangeNotifier {
  List<CardItem> _fakkaCards = [];
  List<CardItem> _maredCards = [];
  bool _isLoading = true;

  List<CardItem> get fakkaCards => _fakkaCards;
  List<CardItem> get maredCards => _maredCards;
  bool get isLoading => _isLoading;

  Future<void> fetchCards() async {
    _isLoading = true;
    notifyListeners();

    try {
      // بيانات تجريبية - استبدل ده بالـ API call الفعلي
      await Future.delayed(const Duration(milliseconds: 800));

      _fakkaCards = [
        CardItem(id: '1', name: 'كرت 10 جنيه', icon: '💳', price: 10, type: 'fakka', badge: 'فودافون'),
        CardItem(id: '2', name: 'كرت 20 جنيه', icon: '💳', price: 20, type: 'fakka', badge: 'فودافون'),
        CardItem(id: '3', name: 'كرت 50 جنيه', icon: '💳', price: 50, type: 'fakka', badge: 'فودافون'),
        CardItem(id: '4', name: 'كرت 100 جنيه', icon: '💳', price: 100, type: 'fakka', badge: 'فودافون'),
      ];

      _maredCards = [
        CardItem(id: 'm1', name: 'مارد 5 جنيه', icon: '🧞', price: 5, type: 'mared', badge: 'مارد'),
        CardItem(id: 'm2', name: 'مارد 10 جنيه', icon: '🧞', price: 10, type: 'mared', badge: 'مارد'),
        CardItem(id: 'm3', name: 'مارد 15 جنيه', icon: '🧞', price: 15, type: 'mared', badge: 'مارد'),
        CardItem(id: 'm4', name: 'مارد 25 جنيه', icon: '🧞', price: 25, type: 'mared', badge: 'مارد'),
      ];
    } catch (e) {
      debugPrint('Error fetching cards: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> purchaseCard({
    required CardItem card,
    required String receiverNumber,
    required String pin,
  }) async {
    try {
      // محاكاة عملية الشراء - استبدل ده بالـ API call الفعلي
      await Future.delayed(const Duration(seconds: 2));
      return true;
    } catch (e) {
      debugPrint('Purchase error: $e');
      return false;
    }
  }
}
