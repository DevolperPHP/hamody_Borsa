import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gold_price_provider.dart';
import '../models/gold_price.dart';

class CalculatorWidget extends StatefulWidget {
  const CalculatorWidget({super.key});

  @override
  State<CalculatorWidget> createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  final TextEditingController _gramController = TextEditingController();
  final TextEditingController _additionalPriceController = TextEditingController();
  final TextEditingController _exchangeRateController = TextEditingController();

  @override
  void dispose() {
    _gramController.dispose();
    _additionalPriceController.dispose();
    _exchangeRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Modern Header Card
          _buildModernHeader(),
          const SizedBox(height: 20),

          // Carat Selection Card
          _buildModernCaratSelection(),
          const SizedBox(height: 20),

          // Exchange Rate Card
          Consumer<GoldPriceProvider>(
            builder: (context, provider, child) {
              return _buildModernExchangeRateCard(provider);
            },
          ),
          const SizedBox(height: 20),

          // Current Price Display
          Consumer<GoldPriceProvider>(
            builder: (context, provider, child) {
              return _buildModernPriceDisplay(provider);
            },
          ),
          const SizedBox(height: 20),

          // Input Fields
          _buildModernInputFields(),
          const SizedBox(height: 20),

          // Final Price Display
          Consumer<GoldPriceProvider>(
            builder: (context, provider, child) {
              return _buildModernFinalPriceDisplay(provider);
            },
          ),

          // Detailed Breakdown
          Consumer<GoldPriceProvider>(
            builder: (context, provider, child) {
              if (provider.userGramAmount <= 0) return const SizedBox.shrink();
              return _buildModernBreakdown(provider);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModernHeader() {
    return Consumer<GoldPriceProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.04),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calculate_rounded,
                      color: Color(0xFF007AFF),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'حاسبة الذهب',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,

                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showExchangeRateDialog(context, provider),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F2F7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.settings_outlined,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: provider.isAutoRefreshEnabled
                      ? const Color(0xFF34C759).withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: provider.isAutoRefreshEnabled
                          ? const Color(0xFF34C759)
                          : Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      provider.getAutoRefreshStatus(),
                      style: TextStyle(
                        fontSize: 12,
                        color: provider.isAutoRefreshEnabled
                            ? const Color(0xFF34C759)
                            : Colors.grey,

                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernCaratSelection() {
    return Consumer<GoldPriceProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.04),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'اختر العيار',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,

                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildModernCaratButton(CaratType.k24, provider.selectedCarat, provider),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildModernCaratButton(CaratType.k21, provider.selectedCarat, provider),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildModernCaratButton(CaratType.k18, provider.selectedCarat, provider),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildModernCaratInfo(provider.selectedCarat),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernCaratButton(CaratType carat, CaratType selectedCarat, GoldPriceProvider provider) {
    final bool isSelected = carat == selectedCarat;

    return GestureDetector(
      onTap: () => provider.updateSelectedCarat(carat),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF007AFF) : const Color(0xFFF2F2F7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF007AFF) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              _getCaratIcon(carat),
              color: isSelected ? Colors.white : Colors.black,
              size: 20,
            ),
            const SizedBox(height: 8),
            Text(
              carat.displayName,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black,

              ),
            ),
            const SizedBox(height: 4),
            Text(
              carat.arabicName,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.white.withValues(alpha: 0.8) : Colors.black.withValues(alpha: 0.6),

              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernCaratInfo(CaratType selectedCarat) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: Colors.black.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'نقاء: ${_getPurityPercentage(selectedCarat)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,

                ),
              ),
              Text(
                _getCaratDescription(selectedCarat),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black.withValues(alpha: 0.6),

                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernExchangeRateCard(GoldPriceProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.04),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9500).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.currency_exchange,
              color: Color(0xFFFF9500),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'سعر الصرف الحالي',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,

                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.getExchangeRateDisplay(),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,

                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showExchangeRateDialog(context, provider),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'تغيير',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF007AFF),

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernPriceDisplay(GoldPriceProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.04),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.attach_money,
                  color: Color(0xFFFFD700),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سعر ${provider.selectedCarat.arabicName} الحالي',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,

                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_getPurityPercentage(provider.selectedCarat)} نقاء',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black.withValues(alpha: 0.6),

                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الدولار الأمريكي',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black.withValues(alpha: 0.6),

                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${provider.getCurrentCaratPriceUSD().toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,

                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.black.withValues(alpha: 0.1),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'دينار عراقي',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black.withValues(alpha: 0.6),

                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${provider.getCurrentCaratPriceIQD().toStringAsFixed(0)} د.ع',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,

                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernInputFields() {
    return Column(
      children: [
        // Gram Input
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.04),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'الكمية',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,

                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _gramController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,

                ),
                decoration: const InputDecoration(
                  hintText: 'أدخل الكمية بالجرام',
                  suffixText: 'جرام',
                  prefixIcon: Icon(
                    Icons.scale_outlined,
                    color: Color(0xFF007AFF),
                  ),
                ),
                onChanged: (value) {
                  context.read<GoldPriceProvider>().updateUserGramAmount(value);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Additional Price Input
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.04),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'سعر إضافي (مصنعية)',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,

                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _additionalPriceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,

                ),
                decoration: const InputDecoration(
                  hintText: 'أدخل السعر الإضافي لكل جرام',
                  suffixText: 'د.ع',
                  prefixIcon: Icon(
                    Icons.add_circle_outline,
                    color: Color(0xFF007AFF),
                  ),
                ),
                onChanged: (value) {
                  context.read<GoldPriceProvider>().updateAdditionalPricePerGram(value);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernFinalPriceDisplay(GoldPriceProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF007AFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF007AFF).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calculate_rounded,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'السعر النهائي',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,

                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            provider.formatPrice(provider.finalPrice),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,

              letterSpacing: -0.5,
            ),
          ),
          if (provider.userGramAmount > 0) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    '${provider.userGramAmount.toStringAsFixed(2)} جرام × ${provider.getCurrentCaratPriceIQD().toStringAsFixed(0)} د.ع',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withValues(alpha: 0.9),

                    ),
                  ),
                  if (provider.additionalPricePerGram > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      '+ ${provider.formatPrice(provider.additionalPricePerGram)} مصنعية',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.8),

                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModernBreakdown(GoldPriceProvider provider) {
    final double basePrice = provider.getCurrentCaratPriceIQD() * provider.userGramAmount;
    final double additionalPrice = provider.additionalPricePerGram * provider.userGramAmount;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.04),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                color: Colors.black.withValues(alpha: 0.6),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'تفصيل الحساب',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,

                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildModernBreakdownRow('عيار الذهب:', '${provider.selectedCarat.displayName} (${_getPurityPercentage(provider.selectedCarat)})'),
          const SizedBox(height: 12),
          _buildModernBreakdownRow('الكمية:', '${provider.userGramAmount.toStringAsFixed(2)} جرام'),
          const SizedBox(height: 12),
          _buildModernBreakdownRow('سعر الصرف:', provider.getExchangeRateDisplay()),
          const SizedBox(height: 12),
          _buildModernBreakdownRow('سعر الجرام:', '${provider.getCurrentCaratPriceIQD().toStringAsFixed(0)} د.ع'),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          _buildModernBreakdownRow('السعر الأساسي:', provider.formatPrice(basePrice)),
          if (additionalPrice > 0) ...[
            const SizedBox(height: 12),
            _buildModernBreakdownRow('السعر الإضافي (مصنعية):', provider.formatPrice(additionalPrice)),
          ],
          const SizedBox(height: 16),
          const Divider(height: 2),
          const SizedBox(height: 12),
          _buildModernBreakdownRow('الإجمالي النهائي:', provider.formatPrice(basePrice + additionalPrice), isTotal: true),
        ],
      ),
    );
  }

  Widget _buildModernBreakdownRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 17 : 15,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              color: Colors.black,

            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 17 : 15,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: isTotal ? const Color(0xFF007AFF) : Colors.black,

          ),
        ),
      ],
    );
  }

  IconData _getCaratIcon(CaratType carat) {
    switch (carat) {
      case CaratType.k24:
        return Icons.star_rounded;
      case CaratType.k21:
        return Icons.star_half_rounded;
      case CaratType.k18:
        return Icons.star_outline_rounded;
    }
  }

  String _getPurityPercentage(CaratType carat) {
    switch (carat) {
      case CaratType.k24:
        return '99.9%';
      case CaratType.k21:
        return '87.5%';
      case CaratType.k18:
        return '75%';
    }
  }

  String _getCaratDescription(CaratType carat) {
    switch (carat) {
      case CaratType.k24:
        return 'الذهب الخالص';
      case CaratType.k21:
        return 'ذهبية عادية';
      case CaratType.k18:
        return 'ذهبية مستعملة';
    }
  }

  void _showExchangeRateDialog(BuildContext context, GoldPriceProvider provider) {
    _exchangeRateController.text = provider.exchangeRate.toStringAsFixed(0);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(24),
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9500).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.currency_exchange,
                    color: Color(0xFFFF9500),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'تغيير سعر الصرف',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,

                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'أدخل سعر الصرف الجديد (الدينار العراقي لكل دولار أمريكي)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black.withValues(alpha: 0.6),

                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _exchangeRateController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,

                  ),
                  decoration: const InputDecoration(
                    labelText: 'سعر الصرف',
                    hintText: '1480',
                    suffixText: 'د.ع/\$',
                    prefixIcon: Icon(
                      Icons.attach_money,
                      color: Color(0xFF007AFF),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Color(0xFFFF9500),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'هذا يؤثر على جميع أسعار الذهب المحسوبة بالدينار العراقي',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black.withValues(alpha: 0.6),

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,

                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final value = _exchangeRateController.text.trim();
                if (value.isNotEmpty) {
                  context.read<GoldPriceProvider>().updateExchangeRate(value);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'تم تحديث سعر الصرف بنجاح',
                        style: TextStyle(
                          fontSize: 17,

                        ),
                      ),
                      backgroundColor: const Color(0xFF007AFF),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'حفظ',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,

                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
