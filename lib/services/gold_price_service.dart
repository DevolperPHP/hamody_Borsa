import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/gold_price.dart';

class GoldPriceService {
  // Update this to your backend URL
  // For local development: 'http://localhost:3000'
  // For production: 'https://gold-price-backend-production.up.railway.app'
  static const String _baseUrl = 'http://localhost:3000';

  Future<GoldPrice> fetchGoldPrice() async {
    try {
      // Check connectivity first
      print('🔌 Checking internet connectivity...');
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isEmpty || result[0].rawAddress.isEmpty) {
          throw Exception('No internet connection');
        }
        print('✅ Internet connection OK');
      } catch (e) {
        print('❌ No internet connection: $e');
        throw Exception('لا يوجد اتصال بالإنترنت');
      }

      final Uri uri = Uri.parse('$_baseUrl/api/gold-price');

      print('🌐 Fetching gold price from: $uri');
      print('⏰ Request time: ${DateTime.now()}');

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout - server is not responding');
        },
      );

      print('📡 Response status: ${response.statusCode}');
      print('📄 Response body (first 500 chars): ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('✅ JSON parsed successfully');
        print('🔍 Raw API data: $data');

        // Check if response is successful and has the expected structure
        if (data['success'] == true &&
            data.containsKey('data') &&
            data['data'].containsKey('goldPricePerOunceUSD')) {

          print('✅ Data structure is valid');
          print('💰 Gold price: ${data['data']['goldPricePerOunceUSD']}');

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

          print('💵 Prices calculated:');
          print('  - 24K USD: $goldPricePerGram24KUSD');
          print('  - 24K IQD: $goldPricePerGram24KIQD');

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
          print('❌ Invalid data structure');
          print('  - success: ${data['success']}');
          print('  - has data: ${data.containsKey('data')}');
          print('  - has goldPricePerOunceUSD: ${data.containsKey('data') ? data['data'].containsKey('goldPricePerOunceUSD') : false}');
          throw Exception('بيانات غير صحيحة من API');
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        throw Exception('فشل في جلب أسعار الذهب: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('💥 Exception caught: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Test if the API is reachable
  Future<bool> testConnection() async {
    try {
      print('🔗 Testing connection to backend...');
      final Uri healthUri = Uri.parse('$_baseUrl/health');
      final response = await http.get(
        healthUri,
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 5));

      print('🔗 Health check status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('✅ Backend is reachable!');
        return true;
      } else {
        print('⚠️ Backend returned status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Cannot reach backend: $e');
      return false;
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