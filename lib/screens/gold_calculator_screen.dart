import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/gold_price_provider.dart';
import '../models/gold_price.dart';
import '../widgets/gold_price_card.dart';
import '../widgets/calculator_widget.dart';

class GoldCalculatorScreen extends StatefulWidget {
  const GoldCalculatorScreen({super.key});

  @override
  State<GoldCalculatorScreen> createState() => _GoldCalculatorScreenState();
}

class _GoldCalculatorScreenState extends State<GoldCalculatorScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch gold price when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GoldPriceProvider>().fetchGoldPrice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F7),
        appBar: AppBar(
          title: const Text(
            'حمودي بورصة',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          actions: [
            Consumer<GoldPriceProvider>(
              builder: (context, provider, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Auto-refresh indicator
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                            size: 6,
                            color: provider.isAutoRefreshEnabled
                                ? const Color(0xFF34C759)
                                : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            provider.isAutoRefreshEnabled ? 'مباشر' : 'متوقف',
                            style: TextStyle(
                              fontSize: 10,
                              color: provider.isAutoRefreshEnabled
                                  ? const Color(0xFF34C759)
                                  : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Auto-refresh toggle
                    IconButton(
                      icon: Icon(
                        provider.isAutoRefreshEnabled
                            ? Icons.autorenew_rounded
                            : Icons.autorenew_outlined,
                        color: const Color(0xFF007AFF),
                        size: 20,
                      ),
                      onPressed: () {
                        provider.toggleAutoRefresh();
                      },
                      tooltip: provider.isAutoRefreshEnabled
                          ? 'إيقاف التحديث التلقائي'
                          : 'تفعيل التحديث التلقائي',
                    ),
                    
                    // Manual refresh
                    IconButton(
                      icon: const Icon(
                        Icons.refresh_rounded,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        provider.fetchGoldPrice();
                      },
                      tooltip: 'تحديث فوري',
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          color: const Color(0xFF007AFF),
          backgroundColor: Colors.white,
          onRefresh: () async {
            await context.read<GoldPriceProvider>().fetchGoldPrice();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    
                    // Modern Gold Price Card
                    Consumer<GoldPriceProvider>(
                      builder: (context, provider, child) {
                        return GoldPriceCard(
                          goldPrice: provider.currentGoldPrice ?? GoldPrice.loading(),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Modern Calculator Widget
                    const CalculatorWidget(),
                    
                    const SizedBox(height: 20),
                    
                    // Modern Info Card
                    _buildModernInfoCard(),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFF007AFF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'معلومات مهمة',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildModernInfoItem(
            '• الأسعار محدثة من السوق العالمي للذهب',
            Icons.trending_up_rounded,
            const Color(0xFF34C759),
          ),
          const SizedBox(height: 12),
          _buildModernInfoItem(
            '• يتم تحويل السعر من الدولار إلى الدينار بمعدل قابل للتعديل',
            Icons.currency_exchange_rounded,
            const Color(0xFFFF9500),
          ),
          const SizedBox(height: 12),
          _buildModernInfoItem(
            '• يمكن إضافة سعر إضافي للجرام حسب المصنعية',
            Icons.add_circle_outline_rounded,
            const Color(0xFF007AFF),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B30).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFF3B30).withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFFF3B30),
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'استشر متخصص قبل اتخاذ أي قرار استثماري',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFF3B30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernInfoItem(String text, IconData icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}