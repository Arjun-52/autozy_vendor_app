# GoRouter + MVVM Integration Guide

## Architecture Overview

This project integrates **GoRouter** for navigation with strict **MVVM architecture**, ensuring clean separation of concerns and scalable, maintainable code.

```
┌─────────────────────────────────┐
│  UI Layer (Views/Screens)       │
│  - Displays UI                  │
│  - Listens to ViewModel state   │
│  - Handles navigation           │
│  - Calls ViewModel methods      │
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│  ViewModel Layer                │
│  (Auth, Role, Dashboard)        │
│  - Exposes state (isOtpSent)    │
│  - Handles business logic       │
│  - NO DIRECT NAVIGATION         │
└──────────────┬──────────────────┘
               │
               ▼
┌─────────────────────────────────┐
│  Data Layer                     │
│  - Models, Services, Repos      │
│  - API calls, Database calls    │
└─────────────────────────────────┘
```

## Key Principles

### 1. **ViewModels DO NOT Handle Navigation**

❌ **WRONG** - Don't do this in ViewModel:
```dart
void sendOtp(String phone) {
  // ... API call ...
  // NEVER do this:
  context.go('/otp');  // ❌ Navigation in ViewModel
}
```

✅ **RIGHT** - Expose state instead:
```dart
Future<void> sendOtp(String phone) async {
  _isLoading = true;
  notifyListeners();
  
  try {
    // ... API call ...
    _isOtpSent = true;  // ✅ Just update state
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
```

### 2. **UI Listens to ViewModel State and Triggers Navigation**

```dart
Consumer<AuthViewModel>(
  builder: (context, authViewModel, child) {
    // ✅ Listen to state change
    if (authViewModel.isOtpSent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/otp');  // ✅ Navigation in UI
      });
    }
    
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // ✅ Call ViewModel method from UI
              authViewModel.sendOtp(_phoneNumber);
            },
            child: const Text('Send OTP'),
          ),
        ],
      ),
    );
  },
)
```

### 3. **Use context.go() for Main Navigation**

- `context.go()` - Replace current route (recommended for main flows)
- `context.push()` - Push route onto stack (use only if stacking is needed)

```dart
// Main flow - use go() to replace route
context.go('/otp');        // LoginScreen → OtpScreen
context.go('/role');       // OtpScreen → RoleScreen
context.go('/dashboard');  // RoleScreen → Dashboard

// Stack if needed
context.push('/otp');      // Keep history if back button needed
```

## Project Structure

```
lib/
├── main.dart                          # App entry point with MultiProvider
├── core/
│   └── navigation/
│       └── app_router.dart            # Central GoRouter configuration
├── viewmodels/
│   ├── auth_viewmodel.dart            # Auth logic (login, OTP)
│   ├── role_viewmodel.dart            # Role selection logic
│   └── dashboard_viewmodel.dart       # Dashboard logic
├── views/
│   ├── auth/
│   │   ├── login_screen.dart          # Phone → Send OTP
│   │   └── otp_screen.dart            # OTP → Verify
│   ├── role/
│   │   └── select_role_screen.dart    # Role selection
│   ├── dashboard/
│   │   └── detailer_dashboard.dart    # Main dashboard
│   └── widgets/
│       └── (shared components)
├── data/
│   ├── models/                        # Data models
│   ├── services/                      # API services
│   └── repositories/                  # Data repositories
└── core/
    ├── constants/
    ├── theme/
    └── utils/
```

## Navigation Flow Walkthrough

### Flow 1: Login → OTP → Role → Dashboard

#### Step 1: LoginScreen - Send OTP
```dart
// UI: User enters phone number and clicks "Send OTP"
ElevatedButton(
  onPressed: () {
    authViewModel.sendOtp(_phoneController.text);
  },
)

// ViewModel: Process
Future<void> sendOtp(String phone) async {
  _isLoading = true;
  notifyListeners();
  
  try {
    // API call to send OTP
    _phoneNumber = phone;
    _isOtpSent = true;  // ← Key state change
  } finally {
    _isLoading = false;
    notifyListeners();  // ← Triggers rebuild
  }
}

// UI: Listens to state change and navigates
Consumer<AuthViewModel>(
  builder: (context, authViewModel, child) {
    if (authViewModel.isOtpSent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/otp');  // ← Navigate
      });
    }
    // ... rest of UI
  },
)
```

#### Step 2: OtpScreen - Verify OTP
```dart
// UI: User enters OTP and clicks "Verify"
ElevatedButton(
  onPressed: () {
    authViewModel.verifyOtp(_otpController.text);
  },
)

// ViewModel: Process
Future<void> verifyOtp(String otp) async {
  _isLoading = true;
  notifyListeners();
  
  try {
    // Validate OTP with backend
    _isOtpVerified = true;  // ← Key state change
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

// UI: Listens and navigates
if (authViewModel.isOtpVerified) {
  context.go('/role');
}
```

#### Step 3: SelectRoleScreen - Choose Role
```dart
// UI: User taps a role card
GestureDetector(
  onTap: () {
    roleViewModel.selectRole(role);
  },
)

// ViewModel: Process
Future<void> selectRole(String role) async {
  _selectedRole = role;  // ← Key state change
  notifyListeners();
}

// UI: Listens and navigates
if (roleViewModel.selectedRole != null) {
  context.go('/dashboard');
}
```

#### Step 4: DetailerDashboard - Main App
- Dashboard loads user data
- User can logout → goes back to login

## Using Provider for State Access

### Option 1: Using `Consumer` (UI reacts to changes)
```dart
Consumer<AuthViewModel>(
  builder: (context, authViewModel, child) {
    return Text(authViewModel.phoneNumber ?? 'No phone');
  },
)
```

### Option 2: Using `context.watch<>()` (Watch specific ViewModel)
```dart
final authViewModel = context.watch<AuthViewModel>();
```

### Option 3: Using `context.read<>()` (Get reference, no listening)
```dart
final authViewModel = context.read<AuthViewModel>();
authViewModel.sendOtp(phone);  // No rebuild
```

## Adding New Routes

### Step 1: Add route to `app_router.dart`
```dart
GoRoute(
  path: '/new-route',
  name: 'newRoute',
  builder: (context, state) => const NewScreen(),
),
```

### Step 2: Add navigation extension method (optional)
```dart
extension GoRouterExtension on GoRouter {
  void goToNewRoute() => go('/new-route');
  void pushNewRoute() => push('/new-route');
}
```

### Step 3: Create ViewModel for the screen
```dart
class NewViewModel extends ChangeNotifier {
  // State variables
  // Business logic methods
}
```

### Step 4: Provide ViewModel in main.dart
```dart
MultiProvider(
  providers: [
    // ... existing
    ChangeNotifierProvider(create: (_) => NewViewModel()),
  ],
)
```

### Step 5: Navigate from UI
```dart
ElevatedButton(
  onPressed: () {
    context.go('/new-route');  // or context.goToNewRoute()
  },
)
```

## Best Practices

### 1. **Always Reset State When Navigating**
```dart
// Before navigating back to login on logout
authViewModel.resetOtp();
roleViewModel.resetRole();
context.go('/');
```

### 2. **Handle Loading and Error States**
```dart
Consumer<AuthViewModel>(
  builder: (context, vm, _) {
    if (vm.isLoading) return const LoadingIndicator();
    if (vm.errorMessage != null) return ErrorWidget(vm.errorMessage!);
    return MainContent();
  },
)
```

### 3. **Use Route Names for Type-Safe Navigation**
```dart
// Instead of hardcoding paths
context.goNamed('otp');  // Named route
// Define in app_router.dart: name: 'otp'
```

### 4. **Pass Parameters to Routes (if needed)**
```dart
// In app_router.dart
GoRoute(
  path: '/detail/:itemId',
  builder: (context, state) {
    final itemId = state.pathParameters['itemId']!;
    return DetailScreen(itemId: itemId);
  },
),

// Navigate with parameters
context.go('/detail/123');
```

### 5. **Prevent Sequential Navigation Issues**
```dart
// Use mounted check after async operations
if (context.mounted) {
  context.go('/next-route');
}

// Or use addPostFrameCallback
WidgetsBinding.instance.addPostFrameCallback((_) {
  context.go('/next-route');
});
```

## Common Mistakes to Avoid

| ❌ Wrong | ✅ Correct |
|---------|-----------|
| Navigation in ViewModel | Navigation in UI layer |
| Mixing go() and push() inconsistently | Use go() for main flows, push() only when needed |
| ViewModel depends on BuildContext | ViewModel has no BuildContext |
| Navigating before state is ready | Listen to state changes, navigate after |
| Not handling widget lifecycle | Use mounted check or addPostFrameCallback |
| Creating new ViewModels each build | Use ChangeNotifierProvider(create: ) |

## Testing Navigation

```dart
void main() {
  testWidgets('Navigation flow', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Find and tap send OTP button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    
    // Verify navigation to OTP screen
    expect(find.byType(OtpScreen), findsOneWidget);
  });
}
```

## Summary

| Aspect | Rule |
|--------|------|
| **Navigation** | Only in UI (Views) |
| **State Exposure** | In ViewModel as variables |
| **UI Listening** | Using Consumer or context.watch() |
| **Routing Config** | Centralized in app_router.dart |
| **Main Navigation** | Use context.go() |
| **Stack Navigation** | Use context.push() only when needed |
| **Provider Setup** | MultiProvider in main.dart |

This architecture ensures clean separation, easy testing, and scalable navigation management!
