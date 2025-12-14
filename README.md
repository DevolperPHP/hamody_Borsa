# 🏆 حمودي بورصة - Gold Price Calculator

**حمودي بورصة** is a professional gold price calculator application designed specifically for the Iraqi market. It provides real-time gold prices, accurate calculations, and seamless currency conversion from USD to IQD.

![App Icon](assets/images/icon.png)

## ✨ Features

### 💰 Real-Time Gold Pricing
- **Live gold prices** fetched from premium APIs every 60 seconds automatically
- **Manual refresh** options with visual indicators
- **Automatic fallback** to mock data if API fails
- **Live status indicators** showing connection status

### 🧮 Advanced Calculator
- **Multiple carat options**: 24K (99.9%), 21K (87.5%), 18K (75%)
- **Automatic price calculation** with purity percentages
- **User-configurable exchange rates** (default: 1420 IQD per USD)
- **Additional price per gram** for manufacturing costs
- **Real-time calculation updates** as user types

### 💱 Currency Conversion
- **Accurate USD to IQD conversion** with user-adjustable rates
- **Price display** in both USD and IQD
- **Real-time rate updates** across all calculations

### 🎨 Professional UI/UX
- **Modern iOS-inspired design** with clean cards and shadows
- **Tajwal Arabic font** for premium typography
- **Complete RTL (right-to-left) support**
- **Professional color scheme** with blue accents (#007AFF)
- **Responsive design** optimized for mobile devices

### 🔄 Auto-Refresh System
- **Automatic price updates** every 60 seconds when enabled
- **Toggle control** to enable/disable auto-refresh
- **Visual indicators** showing live status
- **Manual refresh** options in header

## 🛠️ Technical Stack

- **Framework**: Flutter 3.9.2+
- **Language**: Dart
- **State Management**: Provider Pattern
- **Architecture**: Clean Architecture with separated concerns
- **API Integration**: HTTP requests with fallback system
- **Fonts**: Tajwal Arabic Font Family

## 📱 Supported Platforms

- ✅ **Android** (API Level 21+)
- ✅ **iOS** (iOS 13.0+)
- ✅ **Web** (Future support)
- ✅ **Desktop** (Future support)

## 🚀 Installation

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / Xcode
- Git

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd hamoudi_borsa
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

#### Android
```bash
flutter build apk --release
# or for App Bundle
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

## 📊 API Integration

The app uses a premium gold price API with the following configuration:

```dart
final config = {
  method: 'get',
  url: 'https://gold.g.apised.com/v1/latest',
  params: {
    'metals': 'XAU,XAG,XPT,XPD',
    'base_currency': 'KWD',
    'currencies': 'EUR,KWD,GBP,USD',
    'weight_unit': 'gram'
  },
  headers: {
    'x-api-key': 'sk_9d2cb75D088A4fBE2ED25d3698Ac2bCd06dE146b0cBfC00f'
  }
};
```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point and theme configuration
├── models/
│   └── gold_price.dart       # Data models and carat pricing logic
├── providers/
│   └── gold_price_provider.dart  # State management and auto-refresh
├── services/
│   └── gold_price_service.dart   # API integration and data fetching
├── screens/
│   └── gold_calculator_screen.dart # Main app interface
└── widgets/
    ├── gold_price_card.dart      # Professional price display component
    └── calculator_widget.dart    # Interactive calculator interface
```

## 🧮 Calculation Logic

The app follows this calculation flow:

```
1. Fetch gold price in ounces (USD) from API
2. Convert ounce price to gram price
3. Apply carat purity percentage (24K: 100%, 21K: 87.5%, 18K: 75%)
4. Convert USD to IQD using configurable exchange rate
5. Calculate final price:
   Final Price = (Gold Price per Gram × User Gram Amount) + 
                (Additional Price per Gram × User Gram Amount)
```

## 🎯 Default Configuration

- **Default Carat**: 21K (87.5% purity) - most commonly used in Iraq
- **Default Exchange Rate**: 1420 IQD per USD
- **Auto-refresh**: Enabled (60-second intervals)
- **Language**: Arabic (RTL)
- **Currency Display**: IQD (Iraqi Dinar)

## 🔧 Customization

### Exchange Rate Configuration
Users can adjust the USD to IQD exchange rate through the settings dialog, which updates all calculations in real-time.

### Carat Selection
The app supports three carat types with automatic purity calculations:
- **24K**: 99.9% purity (Gold Standard)
- **21K**: 87.5% purity (Common in Iraq)
- **18K**: 75% purity (Jewelry Grade)

### Auto-Refresh Settings
- **Enable/Disable**: Toggle automatic price updates
- **Interval**: 60 seconds (configurable)
- **Status Indicators**: Visual feedback for connection status

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Contact: [Your Contact Information]

## 🙏 Acknowledgments

- **Tajwal Font**: For beautiful Arabic typography
- **Flutter Team**: For the amazing cross-platform framework
- **Gold Price API**: For providing reliable market data
- **Iraqi Gold Market**: For inspiring this specialized tool

---

**حمودي بورصة** - Professional gold price calculator for Iraq 🇮🇶

Built with ❤️ using Flutter
