import 'package:frontend/app.dart';
import 'package:frontend/controller/auth_controller.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? _localEmailError;

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
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  onPressed: () {
                    authController.clearMessages();
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 60),
              Image.asset(
                AppAssets.logoicon,
                height: 80,
              ),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Enter your email address and we will send you a code to reset your password.",
                style: TextStyle(color: hintColor),
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
                  "Email",
                  hintColor: hintColor,
                  fillColor: fillColor,
                  error: _localEmailError ?? authController.fieldErrors?['email']?.toString(),
                ),
              ),
              const SizedBox(height: 25),
              if (authController.errorMessage != null)
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
                  onPressed: authController.isLoading || !authController.canResend
                      ? null
                      : () async {
                          setState(() {
                            _localEmailError = null;
                          });

                          final email = _emailController.text.trim();

                          if (email.isEmpty) {
                            setState(() => _localEmailError = "Email is required");
                            return;
                          } else if (!_isValidEmail(email)) {
                            setState(() => _localEmailError = "Enter a valid email");
                            return;
                          }

                          bool success = await authController.forgotPassword(email);

                          if (success && mounted) {
                            Navigator.pushNamed(context, AppRoutes.verifyCode);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: authController.canResend ? AppColors.primary : Colors.grey.shade400,
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
                          "Send Code",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                ),
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
}
