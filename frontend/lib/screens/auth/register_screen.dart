import 'package:frontend/app.dart';
import 'package:frontend/controller/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _localEmailError;
  String? _localPasswordError;
  String? _localConfirmPasswordError;

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<AuthController>(context, listen: false).clearMessages();
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;
    final hintColor = theme.colorScheme.onSurface.withOpacity(0.7);
    final fillColor = theme.colorScheme.surface;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Image.asset(
                AppAssets.logoicon,
                height: 80,
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Create your Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) {
                  authController.clearMessages();
                  setState(() => _localEmailError = null);
                },
                decoration: _inputDecoration(
                  "Email",
                  hintColor: hintColor,
                  fillColor: fillColor,
                  error: _localEmailError ?? authController.fieldErrors?['email']?.toString(),
                ),
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: true,
                onChanged: (_) {
                  authController.clearMessages();
                  setState(() => _localPasswordError = null);
                },
                decoration: _inputDecoration(
                  "Password",
                  hintColor: hintColor,
                  fillColor: fillColor,
                  error: _localPasswordError ?? authController.fieldErrors?['password']?.toString(),
                ),
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                onChanged: (_) {
                  authController.clearMessages();
                  setState(() => _localConfirmPasswordError = null);
                },
                decoration: _inputDecoration(
                  "Confirm Password",
                  hintColor: hintColor,
                  fillColor: fillColor,
                  error: _localConfirmPasswordError,
                ),
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 25),
              if (authController.errorMessage != null && authController.fieldErrors == null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    authController.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: authController.isLoading ? null : () async {
                    setState(() {
                      _localEmailError = null;
                      _localPasswordError = null;
                      _localConfirmPasswordError = null;
                    });

                    final email = _emailController.text.trim();
                    final password = _passwordController.text;
                    final confirmPassword = _confirmPasswordController.text;

                    bool hasError = false;

                    if (email.isEmpty) {
                      setState(() => _localEmailError = "Email is required");
                      hasError = true;
                    } else if (!_isValidEmail(email)) {
                      setState(() => _localEmailError = "Enter a valid email (e.g. name@example.com)");
                      hasError = true;
                    }

                    if (password.isEmpty) {
                      setState(() => _localPasswordError = "Password is required");
                      hasError = true;
                    } else if (password.length < 8) {
                      setState(() => _localPasswordError = "Password must be at least 8 characters");
                      hasError = true;
                    }

                    if (confirmPassword.isEmpty) {
                      setState(() => _localConfirmPasswordError = "Please confirm your password");
                      hasError = true;
                    } else if (password != confirmPassword) {
                      setState(() => _localConfirmPasswordError = "Passwords do not match");
                      hasError = true;
                    }

                    if (hasError) return;

                    final exists = await authController.checkEmailExists(email);
                    if (!mounted) return;
                    if (exists) {
                      setState(() {
                        _localEmailError = "This email is already registered";
                      });
                      return;
                    }

                    authController.setRegistrationData(email, password);

                    if (!context.mounted) return;
                    Navigator.pushNamed(context, AppRoutes.username);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: authController.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.blueGrey,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 80),
              const Text(
                "- Or sign up with -",
                style: TextStyle(
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _socialButton(AppAssets.google),
                  _socialButton(AppAssets.facebook),
                  _socialButton("assets/icons/twitter.png"),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.black),
                  ),
                  GestureDetector(
                    onTap: () {
                      authController.clearMessages();
                      Navigator.pushNamed(
                        context,
                        AppRoutes.login,
                      );
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String hint, {
    required Color hintColor,
    required Color fillColor,
    String? error,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: hintColor),
      filled: true,
      fillColor: fillColor,
      errorText: error,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
    );
  }

  Widget _socialButton(String imagePath) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 90,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.border,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: imagePath.toLowerCase().endsWith('.svg')
              ? SvgPicture.asset(
                  imagePath,
                  height: 24,
                )
              : Image.asset(
                  imagePath,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error_outline, size: 24);
                  },
                ),
        ),
      ),
    );
  }
}
