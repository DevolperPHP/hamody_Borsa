class GoldPrice {
  final double goldPricePerOunceUSD;
  final double goldPricePerGramUSD;
  final double goldPricePerGramIQD;
  final double goldPricePerGram24KUSD;
  final double goldPricePerGram24KIQD;
  final double goldPricePerGram21KUSD;
  final double goldPricePerGram21KIQD;
  final double goldPricePerGram18KUSD;
  final double goldPricePerGram18KIQD;
  final DateTime timestamp;
  final bool isLoading;
  final String? error;

  GoldPrice({
    required this.goldPricePerOunceUSD,
    required this.goldPricePerGramUSD,
    required this.goldPricePerGramIQD,
    required this.goldPricePerGram24KUSD,
    required this.goldPricePerGram24KIQD,
    required this.goldPricePerGram21KUSD,
    required this.goldPricePerGram21KIQD,
    required this.goldPricePerGram18KUSD,
    required this.goldPricePerGram18KIQD,
    required this.timestamp,
    this.isLoading = false,
    this.error,
  });

  factory GoldPrice.loading() {
    return GoldPrice(
      goldPricePerOunceUSD: 0.0,
      goldPricePerGramUSD: 0.0,
      goldPricePerGramIQD: 0.0,
      goldPricePerGram24KUSD: 0.0,
      goldPricePerGram24KIQD: 0.0,
      goldPricePerGram21KUSD: 0.0,
      goldPricePerGram21KIQD: 0.0,
      goldPricePerGram18KUSD: 0.0,
      goldPricePerGram18KIQD: 0.0,
      timestamp: DateTime.now(),
      isLoading: true,
    );
  }

  factory GoldPrice.error(String error) {
    return GoldPrice(
      goldPricePerOunceUSD: 0.0,
      goldPricePerGramUSD: 0.0,
      goldPricePerGramIQD: 0.0,
      goldPricePerGram24KUSD: 0.0,
      goldPricePerGram24KIQD: 0.0,
      goldPricePerGram21KUSD: 0.0,
      goldPricePerGram21KIQD: 0.0,
      goldPricePerGram18KUSD: 0.0,
      goldPricePerGram18KIQD: 0.0,
      timestamp: DateTime.now(),
      error: error,
    );
  }

  GoldPrice copyWith({
    double? goldPricePerOunceUSD,
    double? goldPricePerGramUSD,
    double? goldPricePerGramIQD,
    double? goldPricePerGram24KUSD,
    double? goldPricePerGram24KIQD,
    double? goldPricePerGram21KUSD,
    double? goldPricePerGram21KIQD,
    double? goldPricePerGram18KUSD,
    double? goldPricePerGram18KIQD,
    DateTime? timestamp,
    bool? isLoading,
    String? error,
  }) {
    return GoldPrice(
      goldPricePerOunceUSD: goldPricePerOunceUSD ?? this.goldPricePerOunceUSD,
      goldPricePerGramUSD: goldPricePerGramUSD ?? this.goldPricePerGramUSD,
      goldPricePerGramIQD: goldPricePerGramIQD ?? this.goldPricePerGramIQD,
      goldPricePerGram24KUSD: goldPricePerGram24KUSD ?? this.goldPricePerGram24KUSD,
      goldPricePerGram24KIQD: goldPricePerGram24KIQD ?? this.goldPricePerGram24KIQD,
      goldPricePerGram21KUSD: goldPricePerGram21KUSD ?? this.goldPricePerGram21KUSD,
      goldPricePerGram21KIQD: goldPricePerGram21KIQD ?? this.goldPricePerGram21KIQD,
      goldPricePerGram18KUSD: goldPricePerGram18KUSD ?? this.goldPricePerGram18KUSD,
      goldPricePerGram18KIQD: goldPricePerGram18KIQD ?? this.goldPricePerGram18KIQD,
      timestamp: timestamp ?? this.timestamp,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  // Convert ounce price to gram price
  static double convertOunceToGram(double ouncePrice) {
    const double gramsPerOunce = 31.1034768;
    return ouncePrice / gramsPerOunce;
  }

  // Convert USD to IQD (multiply by 1480 as specified)
  static double convertUSDtoIQD(double usdPrice) {
    return usdPrice * 1480;
  }

  // Calculate carat prices
  static double calculate21KPrice(double pureGoldPrice) {
    return pureGoldPrice * 0.875; // 21K is 87.5% pure (21/24 = 0.875)
  }

  static double calculate18KPrice(double pureGoldPrice) {
    return pureGoldPrice * 0.75; // 18K is 75% pure (18/24 = 0.75)
  }

  // Get price for specific carat
  double getPriceForCarat(int carat) {
    switch (carat) {
      case 24:
        return goldPricePerGram24KUSD;
      case 21:
        return goldPricePerGram21KUSD;
      case 18:
        return goldPricePerGram18KUSD;
      default:
        return goldPricePerGram24KUSD;
    }
  }

  // Get IQD price for specific carat
  double getIQDPriceForCarat(int carat) {
    switch (carat) {
      case 24:
        return goldPricePerGram24KIQD;
      case 21:
        return goldPricePerGram21KIQD;
      case 18:
        return goldPricePerGram18KIQD;
      default:
        return goldPricePerGram24KIQD;
    }
  }
}

enum CaratType {
  k24('24K', 'عيار ٢٤'),
  k21('21K', 'عيار ٢١'),
  k18('18K', 'عيار ١٨');

  const CaratType(this.displayName, this.arabicName);

  final String displayName;
  final String arabicName;
}
