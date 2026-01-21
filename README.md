# 🏆 الصايغ - Gold Price Calculator

**الصايغ** is a professional gold price calculator application designed specifically for the Iraqi market. It provides real-time gold prices, accurate calculations, and seamless currency conversion from USD to IQD.

![App Icon](assets/images/icon.png)

## ✨ Features

### 💰 Real-Time Gold Pricing
- **Live gold prices** fetched from backend API every 60 seconds automatically
- **Cached data** served to all users to reduce API calls
- **Manual refresh** options with visual indicators
- **Automatic fallback** to mock data if API fails
- **Live status indicators** showing connection status

### 🧮 Advanced Calculator
- **Multiple carat options**: 24K (99.9%), 21K (87.5%), 18K (75%)
- **Automatic price calculation** with purity percentages
- **User-configurable exchange rates** (default: 1480 IQD per USD)
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
- Node.js 16+ (for backend)
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

3. **Start the backend server** (in a new terminal)
   ```bash
   cd backend
   npm install
   npm start
   ```

4. **Run the Flutter app** (in another terminal)
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

## 🖥️ Backend Architecture

The app uses a **Node.js backend service** to cache gold price data:

### Backend Features
- **Single API Call**: Fetches from Yahoo Finance once every 5 minutes
- **Serves All Users**: Cached data served to unlimited clients
- **Auto-Update**: Cron job updates prices every 5 minutes
- **Fast Response**: Returns cached data in ~10ms
- **Rate Limit Protection**: Avoids API blocking

### API Integration (Flutter → Backend)

```dart
final config = {
  method: 'get',
  url: 'http://localhost:3000/api/gold-price', // Your backend URL
  params: {},
  headers: {}
};
```

### Backend Endpoints
- `GET /api/gold-price` - Get current gold price
- `GET /api/status` - Service status
- `GET /health` - Health check
- `POST /api/gold-price/update` - Force update (admin)

📖 **See [backend/README.md](../backend/README.md) for full backend documentation**

## 🏗️ Project Structure

```
gold_app/
├── lib/                          # Flutter app
│   ├── main.dart
│   ├── models/
│   │   └── gold_price.dart       # Data models and carat pricing logic
│   ├── providers/
│   │   └── gold_price_provider.dart  # State management and auto-refresh
│   ├── services/
│   │   └── gold_price_service.dart   # Backend API integration
│   ├── screens/
│   │   └── gold_calculator_screen.dart # Main app interface
│   └── widgets/
│       ├── gold_price_card.dart      # Professional price display component
│       └── calculator_widget.dart    # Interactive calculator interface
└── backend/                       # Node.js backend service
    ├── server.js                  # Express server and cron jobs
    ├── goldPriceService.js        # Yahoo Finance integration & caching
    ├── package.json               # Dependencies
    ├── .env.example               # Configuration template
    └── README.md                  # Backend documentation
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
- **Default Exchange Rate**: 1480 IQD per USD
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
- **Node.js & Express**: For backend caching infrastructure
- **Yahoo Finance API**: For providing reliable free market data
- **Iraqi Gold Market**: For inspiring this specialized tool

---

**الصايغ** - Professional gold price calculator for Iraq 🇮🇶

Built with ❤️ using Flutter
