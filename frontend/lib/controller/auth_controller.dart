import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/app.dart';
import 'package:http/http.dart' as http;


class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _token;
  String? get token => _token;

  bool get isAuthenticated => _token != null;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  Map<String, dynamic>? _fieldErrors;
  Map<String, dynamic>? get fieldErrors => _fieldErrors;

  int _resendSeconds = 0;
  Timer? _resendTimer;

  int get resendSeconds => _resendSeconds;
  bool get canResend => _resendSeconds == 0;

  // Temporary storage for multi-step registration
  String? _email;
  String? _password;

  void setRegistrationData(String email, String password) {
    _email = email;
    _password = password;
    _errorMessage = null;
    _fieldErrors = null;
    Logger.info("Registration data staged: $email");
    notifyListeners();
  }

  void clearMessages({bool keepSuccess = false}) {
    _errorMessage = null;
    _fieldErrors = null;
    if (!keepSuccess) {
      _successMessage = null;
    }
    notifyListeners();
  }

  String _extractErrorMessage(Map<String, dynamic> body, {String fallback = 'Registration failed.'}) {
    if (body['errors'] is Map<String, dynamic>) {
      _fieldErrors = body['errors'] as Map<String, dynamic>;
    }

    if (body['message'] != null) {
      return body['message'].toString();
    }

    if (_fieldErrors != null && _fieldErrors!.isNotEmpty) {
      final firstError = _fieldErrors!.values.first;
      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }
      return firstError.toString();
    }

    return fallback;
  }
  String _handleException(dynamic e) {
    Logger.error("Auth Exception: $e");
    if (e.toString().contains('SocketException') || e.toString().contains('Connection refused')) {
      return 'Server unreachable. Please check your connection or try again later.';
    }
    return 'Something went wrong. Please try again.';
  }

  void _startResendTimer([int seconds = 60]) {
    _resendTimer?.cancel();
    _resendSeconds = seconds;
    notifyListeners();

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds <= 0) {
        timer.cancel();
        _resendTimer = null;
        notifyListeners();
        return;
      }

      _resendSeconds -= 1;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  Future<bool> checkEmailExists(String email) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/check-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['exists'] == true;
      }

      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = _handleException(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> checkUsernameExists(String username) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/check-username'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
        }),
      );

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['exists'] == true;
      }

      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = _handleException(e);
      notifyListeners();
      return false;
    }
  }

  Future<String?> register(String username) async {
    if (_email == null || _password == null) {
      Logger.error("Registration failed: Missing staged email or password");
      return 'Email or password data is missing.';
    }

    _isLoading = true;
    _errorMessage = null;
    _fieldErrors = null;
    _successMessage = null;
    notifyListeners();

    Logger.api("Attempting registration for username: $username");

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _email,
          'password': _password,
          'password_confirmation': _password,
          'username': username,
        }),
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode == 201 || response.statusCode == 200) {
        _token = body['token'];
        _successMessage = body['message']?.toString() ?? 'Registration successful.';
        _errorMessage = null;
        _fieldErrors = null;
        _isLoading = false;
        Logger.success("Registration successful for $username");
        notifyListeners();
        return null;
      }

      _errorMessage = body is Map<String, dynamic>
          ? _extractErrorMessage(body, fallback: 'Registration failed with status ${response.statusCode}.')
          : 'Registration failed with status ${response.statusCode}.';
      
      _successMessage = null;
      Logger.error("Registration failed [${response.statusCode}]: $_errorMessage");
      
      _isLoading = false;
      notifyListeners();
      return _errorMessage;
    } catch (e) {
      _errorMessage = _handleException(e);
      _successMessage = null;
      _fieldErrors = null;
      _isLoading = false;
      notifyListeners();
      return _errorMessage;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    _fieldErrors = null;
    _successMessage = null;
    notifyListeners();

    Logger.api("Attempting login for email: $email");

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode == 200) {
        _token = body['token'];
        await _saveToken(_token);
        _successMessage = body['message']?.toString() ?? 'Login successful.';
        _errorMessage = null;
        _fieldErrors = null;
        _isLoading = false;
        Logger.success("Login successful for $email");
        notifyListeners();
        return true;
      } else {
        _errorMessage = body is Map<String, dynamic>
            ? _extractErrorMessage(body, fallback: 'Login failed. Check your credentials.')
            : 'Login failed. Check your credentials.';
        _successMessage = null;
        Logger.error("Login failed for $email [Status: ${response.statusCode}]: $_errorMessage");
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = _handleException(e);
      _successMessage = null;
      _fieldErrors = null;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Map<String, String> get authHeaders {
    final headers = {'Content-Type': 'application/json'};
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<void> _saveToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token == null) {
      await prefs.remove('auth_token');
      return;
    }
    await prefs.setString('auth_token', token);
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('auth_token');
    if (savedToken != null && _token == null) {
      _token = savedToken;
      notifyListeners();
    }
  }

  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    
    // If an email is provided, store it. Otherwise use the previously stored email.
    if (email.isNotEmpty) {
      _email = email;
    }
    
    if (_email == null || _email!.isEmpty) {
      _errorMessage = "Email is required.";
      _isLoading = false;
      notifyListeners();
      return false;
    }

    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': _email}),
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode == 200) {
        _successMessage = body['message'] ?? 'Verification code sent.';
        _startResendTimer();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = body['message'] ?? 'Failed to send code.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = _handleException(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyCode(String code) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _email,
          'code': code,
        }),
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode == 200) {
        _successMessage = body['message'] ?? 'Code verified.';
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = body['message'] ?? 'Invalid code.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = _handleException(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword(String password) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _email,
          'password': password,
          'password_confirmation': password,
        }),
      );

      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode == 200) {
        _successMessage = body['message'] ?? 'Password reset successfully.';
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = body['message'] ?? 'Failed to reset password.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = _handleException(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    // Attempt to revoke token on server (best-effort)
    if (_token != null) {
      try {
        await http.post(
          Uri.parse('${ApiConfig.baseUrl}/logout'),
          headers: authHeaders,
        );
      } catch (e) {
        Logger.error('Logout API failed: $e');
      }
    }

    // Clear local auth state
    _token = null;
    _email = null;
    _password = null;
    _errorMessage = null;
    _successMessage = null;
    _fieldErrors = null;
    await _saveToken(null);
    notifyListeners();
  }
}
