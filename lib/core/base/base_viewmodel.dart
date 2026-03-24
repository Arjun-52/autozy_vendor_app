import 'package:flutter/foundation.dart';


abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Execute an async operation with common loading and error handling
  ///
  /// [operation] - The async operation to execute
  /// [onSuccess] - Optional callback when operation succeeds
  /// [onError] - Optional custom error message, defaults to exception message
  Future<void> executeOperation(
    Future<void> Function() operation, {
    String? onError,
    void Function()? onSuccess,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await operation();
      onSuccess?.call();
    } catch (e) {
      _setError(onError ?? e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Execute an async operation with return value and common error handling
  ///
  /// [operation] - The async operation to execute
  /// [onError] - Optional custom error message, defaults to exception message
  /// Returns the result of the operation or null if failed
  Future<T?> executeOperationWithResult<T>(
    Future<T> Function() operation, {
    String? onError,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await operation();
      return result;
    } catch (e) {
      _setError(onError ?? e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Set loading state
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// Set error message
  void setError(String? error) {
    if (_errorMessage != error) {
      _errorMessage = error;
      notifyListeners();
    }
  }

  /// Set error message (protected method for subclasses)
  void _setError(String? error) {
    setError(error);
  }

  /// Clear error message
  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Public method to clear error
  void clearError() {
    _clearError();
  }

  /// Reset all common state
  void resetBaseState() {
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
