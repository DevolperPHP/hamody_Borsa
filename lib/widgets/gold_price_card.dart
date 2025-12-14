import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/gold_price.dart';
import '../providers/gold_price_provider.dart';

class GoldPriceCard extends StatelessWidget {
  final GoldPrice goldPrice;

  const GoldPriceCard({super.key, required this.goldPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Modern Header
          _buildModernHeader(context),
          const SizedBox(height: 16),

          // Price Content
          if (goldPrice.isLoading) ...[
            _buildModernLoadingState()
          ] else if (goldPrice.error != null) ...[
            _buildModernErrorState(goldPrice.error!)
          ] else ...[
            _buildModernPriceContent()
          ]
        ],
      ),
    );
  }

  Widget _buildModernHeader(BuildContext context) {
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
              color: const Color(0xFFFFD700).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.currency_exchange_rounded,
              color: Color(0xFFFFD700),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'أسعار الذهب الحالية',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                letterSpacing: -0.5,
              ),
            ),
          ),
          Consumer<GoldPriceProvider>(
            builder: (context, provider, child) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  provider.getExchangeRateDisplay(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModernLoadingState() {
    return Container(
      padding: const EdgeInsets.all(40),
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
          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007AFF)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'جاري تحميل الأسعار...',
            style: TextStyle(
              fontSize: 17,
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernErrorState(String error) {
    return Container(
      padding: const EdgeInsets.all(40),
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B30).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: Color(0xFFFF3B30),
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            error,
            style: TextStyle(
              fontSize: 17,
              color: Colors.black.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildModernPriceContent() {
    return Column(
      children: [
        // 24K Gold Price
        _buildModernPriceCard(
          title: 'عيار ٢٤',
          subtitle: 'الذهب الخالص',
          usdPrice: goldPrice.goldPricePerGram24KUSD,
          iqdPrice: goldPrice.goldPricePerGram24KIQD,
          icon: Icons.star_rounded,
          color: const Color(0xFFFF9500),
          iconColor: const Color(0xFFFF9500),
        ),
        const SizedBox(height: 12),

        // 21K Gold Price
        _buildModernPriceCard(
          title: 'عيار ٢١',
          subtitle: 'ذهبية عادية',
          usdPrice: goldPrice.goldPricePerGram21KUSD,
          iqdPrice: goldPrice.goldPricePerGram21KIQD,
          icon: Icons.star_half_rounded,
          color: const Color(0xFF007AFF),
          iconColor: const Color(0xFF007AFF),
        ),
        const SizedBox(height: 12),

        // 18K Gold Price
        _buildModernPriceCard(
          title: 'عيار ١٨',
          subtitle: 'ذهبية مستعملة',
          usdPrice: goldPrice.goldPricePerGram18KUSD,
          iqdPrice: goldPrice.goldPricePerGram18KIQD,
          icon: Icons.star_outline_rounded,
          color: const Color(0xFF34C759),
          iconColor: const Color(0xFF34C759),
        ),
        const SizedBox(height: 12),

        // Ounce Price
        _buildModernPriceCard(
          title: 'الأونصة',
          subtitle: 'السعر العالمي',
          usdPrice: goldPrice.goldPricePerOunceUSD,
          iqdPrice: goldPrice.goldPricePerOunceUSD * 1420, // Quick conversion for display
          icon: Icons.trending_up_rounded,
          color: const Color(0xFF5856D6),
          iconColor: const Color(0xFF5856D6),
        ),
        const SizedBox(height: 16),

        // Timestamp
        _buildModernTimestamp(goldPrice.timestamp),
      ],
    );
  }

  Widget _buildModernPriceCard({
    required String title,
    required String subtitle,
    required double usdPrice,
    required double iqdPrice,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
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
          const SizedBox(height: 16),
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
                      '\$${usdPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: color,
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
                      '${iqdPrice.toStringAsFixed(0)} د.ع',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: color,
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

  Widget _buildModernTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    String timeText;
    if (difference.inMinutes < 1) {
      timeText = 'الآن';
    } else if (difference.inHours < 1) {
      timeText = '${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      timeText = '${difference.inHours} ساعة';
    } else {
      timeText = '${difference.inDays} يوم';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time_outlined,
            size: 16,
            color: Colors.black.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 8),
          Text(
            'آخر تحديث: $timeText',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
