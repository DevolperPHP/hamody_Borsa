import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gold_price.dart';

class GoldPriceService {
  // Update this to your backend URL
  // For local development: 'http://localhost:3000'
  // For production: 'https://your-backend-domain.com'
  static const String _baseUrl = 'http://localhost:3000';

  Future<GoldPrice> fetchGoldPrice() async {
    final Uri uri = Uri.parse('$_baseUrl/api/gold-price');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      // Check if response is successful and has the expected structure
      if (data['success'] == true &&
          data.containsKey('data') &&
          data['data'].containsKey('goldPricePerOunceUSD')) {

        // Backend returns price in USD per ounce
        final double goldPricePerOunceUSD = data['data']['goldPricePerOunceUSD'].toDouble();
        final double goldPricePerGram24KUSD = GoldPrice.convertOunceToGram(goldPricePerOunceUSD);
        final double goldPricePerGram21KUSD = GoldPrice.calculate21KPrice(goldPricePerGram24KUSD);
        final double goldPricePerGram18KUSD = GoldPrice.calculate18KPrice(goldPricePerGram24KUSD);

        // Convert to IQD
        final double goldPricePerGram24KIQD = GoldPrice.convertUSDtoIQD(goldPricePerGram24KUSD);
        final double goldPricePerGram21KIQD = GoldPrice.convertUSDtoIQD(goldPricePerGram21KUSD);
        final double goldPricePerGram18KIQD = GoldPrice.convertUSDtoIQD(goldPricePerGram18KUSD);
        final double goldPricePerGramIQD = goldPricePerGram24KIQD; // Default to 24K for general display

        return GoldPrice(
          goldPricePerOunceUSD: goldPricePerOunceUSD,
          goldPricePerGramUSD: goldPricePerGram24KUSD,
          goldPricePerGramIQD: goldPricePerGramIQD,
          goldPricePerGram24KUSD: goldPricePerGram24KUSD,
          goldPricePerGram24KIQD: goldPricePerGram24KIQD,
          goldPricePerGram21KUSD: goldPricePerGram21KUSD,
          goldPricePerGram21KIQD: goldPricePerGram21KIQD,
          goldPricePerGram18KUSD: goldPricePerGram18KUSD,
          goldPricePerGram18KIQD: goldPricePerGram18KIQD,
          timestamp: DateTime.now(),
        );
      } else {
        throw Exception('بيانات غير صحيحة من API');
      }
    } else {
      throw Exception('فشل في جلب أسعار الذهب: ${response.statusCode}');
    }
  }

  // Fallback method using mock data for demonstration
  Future<GoldPrice> getMockGoldPrice() async {
    // Mock gold price data (can be used when API is unavailable)
    await Future.delayed(const Duration(seconds: 1));
    
    const double mockGoldPricePerOunceUSD = 2000.0; // Example price
    final double mockGoldPricePerGram24KUSD = GoldPrice.convertOunceToGram(mockGoldPricePerOunceUSD);
    final double mockGoldPricePerGram21KUSD = GoldPrice.calculate21KPrice(mockGoldPricePerGram24KUSD);
    final double mockGoldPricePerGram18KUSD = GoldPrice.calculate18KPrice(mockGoldPricePerGram24KUSD);
    
    final double mockGoldPricePerGram24KIQD = GoldPrice.convertUSDtoIQD(mockGoldPricePerGram24KUSD);
    final double mockGoldPricePerGram21KIQD = GoldPrice.convertUSDtoIQD(mockGoldPricePerGram21KUSD);
    final double mockGoldPricePerGram18KIQD = GoldPrice.convertUSDtoIQD(mockGoldPricePerGram18KUSD);

    return GoldPrice(
      goldPricePerOunceUSD: mockGoldPricePerOunceUSD,
      goldPricePerGramUSD: mockGoldPricePerGram24KUSD,
      goldPricePerGramIQD: mockGoldPricePerGram24KIQD,
      goldPricePerGram24KUSD: mockGoldPricePerGram24KUSD,
      goldPricePerGram24KIQD: mockGoldPricePerGram24KIQD,
      goldPricePerGram21KUSD: mockGoldPricePerGram21KUSD,
      goldPricePerGram21KIQD: mockGoldPricePerGram21KIQD,
      goldPricePerGram18KUSD: mockGoldPricePerGram18KUSD,
      goldPricePerGram18KIQD: mockGoldPricePerGram18KIQD,
      timestamp: DateTime.now(),
    );
  }
}