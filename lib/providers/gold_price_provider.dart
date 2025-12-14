import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/gold_price.dart';
import '../services/gold_price_service.dart';

class GoldPriceProvider with ChangeNotifier {
  final GoldPriceService _goldPriceService = GoldPriceService();
  GoldPrice? _currentGoldPrice;
  double _userGramAmount = 0.0;
  double _additionalPricePerGram = 0.0;
  double _finalPrice = 0.0;
  double _exchangeRate = 1420.0; // Default USD to IQD rate
  CaratType _selectedCarat = CaratType.k21;
  Timer? _priceUpdateTimer;
  bool _isAutoRefreshEnabled = true;

  GoldPrice? get currentGoldPrice => _currentGoldPrice;
  double get userGramAmount => _userGramAmount;
  double get additionalPricePerGram => _additionalPricePerGram;
  double get finalPrice => _finalPrice;
  double get exchangeRate => _exchangeRate;
  CaratType get selectedCarat => _selectedCarat;
  bool get isAutoRefreshEnabled => _isAutoRefreshEnabled;

  GoldPriceProvider() {
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _priceUpdateTimer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    // Fetch initial price
    fetchGoldPrice();
    
    // Set up automatic refresh every 60 seconds
    _priceUpdateTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (_isAutoRefreshEnabled) {
        fetchGoldPrice();
      }
    });
  }

  void toggleAutoRefresh() {
    _isAutoRefreshEnabled = !_isAutoRefreshEnabled;
    notifyListeners();
  }

  Future<void> fetchGoldPrice() async {
    try {
      // Only show loading if we don't have any data yet
      if (_currentGoldPrice == null) {
        _currentGoldPrice = GoldPrice.loading();
        notifyListeners();
      }

      // Try to fetch from API first, fallback to mock data
      GoldPrice goldPrice;
      try {
        goldPrice = await _goldPriceService.fetchGoldPrice();
      } catch (e) {
        // If API fails, use mock data
        goldPrice = await _goldPriceService.getMockGoldPrice();
      }

      _currentGoldPrice = goldPrice;
      _calculateFinalPrice();
      notifyListeners();
    } catch (e) {
      _currentGoldPrice = GoldPrice.error('فشل في جلب أسعار الذهب');
      notifyListeners();
    }
  }

  void updateUserGramAmount(String value) {
    _userGramAmount = double.tryParse(value) ?? 0.0;
    _calculateFinalPrice();
    notifyListeners();
  }

  void updateAdditionalPricePerGram(String value) {
    _additionalPricePerGram = double.tryParse(value) ?? 0.0;
    _calculateFinalPrice();
    notifyListeners();
  }

  void updateExchangeRate(String value) {
    _exchangeRate = double.tryParse(value) ?? 1420.0;
    // Recalculate gold prices with new exchange rate
    _recalculateGoldPrices();
    _calculateFinalPrice();
    notifyListeners();
  }

  void updateSelectedCarat(CaratType carat) {
    _selectedCarat = carat;
    _calculateFinalPrice();
    notifyListeners();
  }

  void _recalculateGoldPrices() {
    if (_currentGoldPrice != null) {
      // Recalculate IQD prices with new exchange rate
      final double new24KIQD = _currentGoldPrice!.goldPricePerGram24KUSD * _exchangeRate;
      final double new21KIQD = _currentGoldPrice!.goldPricePerGram21KUSD * _exchangeRate;
      final double new18KIQD = _currentGoldPrice!.goldPricePerGram18KUSD * _exchangeRate;
      final double newGeneralIQD = _currentGoldPrice!.goldPricePerGramUSD * _exchangeRate;

      _currentGoldPrice = _currentGoldPrice!.copyWith(
        goldPricePerGramIQD: newGeneralIQD,
        goldPricePerGram24KIQD: new24KIQD,
        goldPricePerGram21KIQD: new21KIQD,
        goldPricePerGram18KIQD: new18KIQD,
      );
    }
  }

  void _calculateFinalPrice() {
    if (_currentGoldPrice != null && 
        _currentGoldPrice!.getIQDPriceForCarat(_getCaratValue(_selectedCarat)) > 0 && 
        _userGramAmount > 0) {
      
      final int caratValue = _getCaratValue(_selectedCarat);
      final double basePricePerGramIQD = _currentGoldPrice!.getIQDPriceForCarat(caratValue);
      final double basePrice = basePricePerGramIQD * _userGramAmount;
      final double additionalPrice = _additionalPricePerGram * _userGramAmount;
      _finalPrice = basePrice + additionalPrice;
    } else {
      _finalPrice = 0.0;
    }
  }

  int _getCaratValue(CaratType carat) {
    switch (carat) {
      case CaratType.k24:
        return 24;
      case CaratType.k21:
        return 21;
      case CaratType.k18:
        return 18;
    }
  }

  String formatPrice(double price) {
    if (price == 0) return '0 د.ع';
    // For IQD prices, use integer (no decimal places)
    final formatted = price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$formatted د.ع';
  }

  String formatGoldPrice(double price) {
    if (price == 0) return '0 \$';
    // For USD prices, use 2 decimal places
    final formatted = price.toStringAsFixed(2);
    return '$formatted \$';
  }

  String formatIQDPrice(double price) {
    if (price == 0) return '0 د.ع';
    // For IQD prices, use integer (no decimal places)
    final formatted = price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$formatted د.ع';
  }

  // Get current price for selected carat
  double getCurrentCaratPriceUSD() {
    if (_currentGoldPrice == null) return 0.0;
    return _currentGoldPrice!.getPriceForCarat(_getCaratValue(_selectedCarat));
  }

  double getCurrentCaratPriceIQD() {
    if (_currentGoldPrice == null) return 0.0;
    return _currentGoldPrice!.getIQDPriceForCarat(_getCaratValue(_selectedCarat));
  }

  // Get conversion rate display
  String getExchangeRateDisplay() {
    return '1\$ = ${_exchangeRate.toStringAsFixed(0)} د.ع';
  }

  // Get auto-refresh status display
  String getAutoRefreshStatus() {
    if (_isAutoRefreshEnabled) {
      return 'محدث تلقائياً كل دقيقة';
    } else {
      return 'التحديث التلقائي معطل';
    }
  }
}