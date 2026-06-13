import 'package:frontend/app.dart';
import 'package:frontend/controller/auth_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _passwordError;
  String? _confirmError;

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
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(AppAssets.logoicon, height: 80),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Reset Password",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: textColor),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter your new password below.",
                  style: TextStyle(color: hintColor),
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: textColor),
                onChanged: (_) {
                  authController.clearMessages();
                  if (_passwordError != null) setState(() => _passwordError = null);
                },
                decoration: _inputDecoration(
                  "New Password",
                  hintColor: hintColor,
                  fillColor: fillColor,
                  error: _passwordError,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                style: TextStyle(color: textColor),
                onChanged: (_) {
                  authController.clearMessages();
                  if (_confirmError != null) setState(() => _confirmError = null);
                },
                decoration: _inputDecoration(
                  "Confirm Password",
                  hintColor: hintColor,
                  fillColor: fillColor,
                  error: _confirmError,
                ),
              ),
              const SizedBox(height: 25),
              if (authController.errorMessage != null)
                Text(authController.errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: authController.isLoading
                      ? null
                      : () async {
                          final pass = _passwordController.text;
                          final confirm = _confirmPasswordController.text;

                          if (pass.length < 8) {
                            setState(() => _passwordError = "Password must be 8+ characters");
                            return;
                          }
                          if (pass != confirm) {
                            setState(() => _confirmError = "Passwords do not match");
                            return;
                          }

                          bool success = await authController.resetPassword(pass);
                          if (success && mounted) {
                            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: authController.isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Reset Password", style: TextStyle(color: Colors.white, fontSize: 16)),
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
      errorText: error,
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
    );
  }
}
