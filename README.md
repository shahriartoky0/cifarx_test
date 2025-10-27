# CifarX Test - Flutter E-Commerce Application

A modern Flutter e-commerce application built with clean architecture, Riverpod state management, and beautiful UI/UX.

---

## 🌐 API Used

### **DummyJSON API** - `https://dummyjson.com`

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/products?limit=10&skip=0` | GET | Fetch paginated products |
| `/products/search?q=phone&limit=10&skip=0` | GET | Search products |

**Example Response:**
```json
{
  "products": [
    {
      "id": 1,
      "title": "iPhone 9",
      "price": 549,
      "discountPercentage": 12.96,
      "rating": 4.69,
      "stock": 94,
      "brand": "Apple",
      "thumbnail": "https://...",
      "description": "..."
    }
  ],
  "total": 100,
  "skip": 0,
  "limit": 10
}
```

**Features Implemented:**
- ✅ Pagination (10 items per page)
- ✅ Real-time search
- ✅ Local caching with GetStorage
- ✅ Pull-to-refresh
- ✅ Infinite scroll at 85% scroll position

---

## 📝 Assumptions

### **API**
- DummyJSON API is always available
- Product data structure remains consistent
- No authentication required for product endpoints

### **User Flow**
- Login required to access home screen
- Users can scroll infinitely to load more products
- Search clears on refresh or navigation back
- Products are cached for offline viewing

### **UI/UX**
- iOS-style smooth scrolling preferred
- Skeleton loading over spinners
- Pull-to-refresh with no visible indicator
- Real-time search without search button
- Immediate visual feedback on interactions

### **Technical**
- 10 items per page optimal for performance
- 85% scroll position triggers load more
- Email requires standard format (regex validation)
- Passwords must be at least 6 characters
- Login simulates 2-second API call

---

## 📌 Additional Notes

### **Architecture**
```
lib/
├── core/               # Config, design, network, utils, routes
└── features/
    ├── home/           # Product listing with pagination & search
    │   ├── data/       # API calls & repository
    │   └── presentation/
    │       ├── models/      # State & domain models
    │       ├── providers/   # Riverpod state management
    │       └── screens/     # UI
    └── auth/login/     # Login with validation & animations
```

### **State Management**
- **Riverpod** for all state management
- No `setState` - all logic in providers
- Immutable state with `copyWith` pattern
- Status-based state: `initial`, `loading`, `success`, `error`

### **Design System**
- **Colors:** Blue gradient (`#002454 → #4A90E2`), purple accent, green success
- **Effects:** Glassmorphism, backdrop blur, smooth gradients
- **Animations:** Fade-in, slide-up, shimmer loading
- **Spacing:** Consistent sizing system via `AppSizes`

### **Key Features**
- 🎨 Modern gradient UI with glassmorphism
- 🔍 Sticky search bar with real-time results
- 📜 Infinite scroll with skeleton loading
- 🔄 Pull-to-refresh (invisible indicator)
- 💫 Smooth animations throughout
- 🔐 Form validation with error messages
- 🌐 Social login UI (Google, Apple)

### **Performance Optimizations**
- Image caching with `cacheWidth: 800`
- ValueKey on list items prevents rebuilds
- Local storage caching for offline support
- Debounced search to reduce API calls
- Early load trigger (85% vs 90%)

### **Known Limitations**
- DummyJSON has fixed dataset (~100 products)
- No real authentication (simulated)
- No product detail page
- No cart/checkout functionality
- No filters or sorting

### **Error Handling**
- Toast notifications for user actions
- Error states with retry buttons
- Empty states with helpful messages
- Graceful image error handling

---

## 🚀 Setup

```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Build for production
flutter build apk --release    # Android
flutter build ios --release    # iOS
```

### **Dependencies**
```yaml
flutter_riverpod: ^2.4.0
go_router: ^13.0.0
get_storage: ^2.1.1
http: ^1.1.0
```

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── config/app_sizes.dart
│   ├── design/app_colors.dart
│   ├── network/network_caller.dart
│   ├── utils/get_storage_model.dart
│   └── routes/app_routes.dart
├── features/
│   ├── home/
│   │   ├── data/product_repository.dart
│   │   └── presentation/
│   │       ├── models/home_state_model.dart
│   │       ├── providers/home_provider.dart
│   │       └── screens/home_screen.dart
│   └── auth/login/
│       ├── models/login_state_model.dart
│       ├── providers/login_provider.dart
│       └── screens/login_screen.dart
└── main.dart
```

---
** APK link : "https://drive.google.com/file/d/1yuXwUFDaROo1tG3u5Wj4MkFrd5bJibb8/view?usp=sharing"
**Built with ❤️ using Flutter & Riverpod**