import 'package:frontend/app.dart';
import 'package:frontend/controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _localEmailError;
  String? _localPasswordError;

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Keep success message if we just redirected from reset password
        Provider.of<AuthController>(context, listen: false).clearMessages(keepSuccess: true);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;
    final hintColor = theme.colorScheme.onSurface.withOpacity(0.7);
    final surfaceColor = theme.colorScheme.surface;

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
              Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  themeController.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: AppColors.primary,
                ),
                onPressed: themeController.toggleTheme,
              ),
            ),

              const SizedBox(height: 20),
              Image.asset(
                AppAssets.logoicon,
                height: 80,
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Login to your Account",
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
                style: TextStyle(color: textColor),
                onChanged: (_) {
                  authController.clearMessages();
                  if (_localEmailError != null) {
                    setState(() => _localEmailError = null);
                  }
                },
                decoration: _inputDecoration(
                  context,
                  "Email",
                  hintColor: hintColor,
                  fillColor: surfaceColor,
                  error: _localEmailError ?? authController.fieldErrors?['email']?.toString(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: textColor),
                onChanged: (_) {
                  authController.clearMessages();
                  if (_localPasswordError != null) {
                    setState(() => _localPasswordError = null);
                  }
                },
                decoration: _inputDecoration(
                  context,
                  "Password",
                  hintColor: hintColor,
                  fillColor: surfaceColor,
                  error: _localPasswordError ?? authController.fieldErrors?['password']?.toString(),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    authController.clearMessages();
                    Navigator.pushNamed(context, AppRoutes.forgetPassword);
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              if (authController.errorMessage != null && authController.fieldErrors == null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    authController.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (authController.successMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    authController.successMessage!,
                    style: const TextStyle(color: Colors.green),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: authController.isLoading
                      ? null
                      : () async {
                          setState(() {
                            _localEmailError = null;
                            _localPasswordError = null;
                          });

                          final email = _emailController.text.trim();
                          final password = _passwordController.text;

                          bool hasError = false;

                          if (email.isEmpty) {
                            setState(() => _localEmailError = "Email is required");
                            hasError = true;
                          } else if (!_isValidEmail(email)) {
                            setState(() => _localEmailError = "Enter a valid email");
                            hasError = true;
                          }

                          if (password.isEmpty) {
                            setState(() => _localPasswordError = "Password is required");
                            hasError = true;
                          } else if (password.length < 8) {
                            setState(() => _localPasswordError = "Password must be at least 8 characters");
                            hasError = true;
                          }

                          if (hasError) return;

                          bool success = await authController.login(email, password);

                          if (!context.mounted) return;

                          if (success) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.home,
                              (route) => false,
                            );
                          }
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
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 80),
              const Text(
                "- Or sign in with -",
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
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.black),
                  ),
                  GestureDetector(
                    onTap: () {
                      authController.clearMessages();
                      Navigator.pushNamed(
                        context,
                        AppRoutes.register,
                      );
                    },
                    child: const Text(
                      "Sign Up",
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
    BuildContext context,
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
