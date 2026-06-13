import 'package:frontend/app.dart';
import 'package:frontend/controller/auth_controller.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  String? _localError;

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
    _codeController.dispose();
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
              const SizedBox(height: 60),
              Image.asset(AppAssets.logoicon, height: 80),
              const SizedBox(height: 50),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Verify Code",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: textColor),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter the 6-digit code sent to your email.",
                  style: TextStyle(color: hintColor),
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                style: TextStyle(color: textColor, fontSize: 24, letterSpacing: 8),
                textAlign: TextAlign.center,
                onChanged: (_) {
                  authController.clearMessages();
                  if (_localError != null) setState(() => _localError = null);
                },
                decoration: _inputDecoration(
                  "000000",
                  hintColor: hintColor,
                  fillColor: fillColor,
                  error: _localError,
                ),
              ),
              const SizedBox(height: 25),
              if (authController.errorMessage != null)
                Text(authController.errorMessage!, style: TextStyle(color: theme.colorScheme.error)),
              if (authController.successMessage != null)
                Text(authController.successMessage!, style: TextStyle(color: AppColors.success)),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: authController.isLoading
                      ? null
                      : () async {
                          final code = _codeController.text.trim();
                          if (code.length != 6) {
                            setState(() => _localError = "Enter the 6-digit code");
                            return;
                          }

                          bool success = await authController.verifyCode(code);
                          if (success && mounted) {
                            Navigator.pushNamed(context, AppRoutes.resetPassword);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: authController.isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.blueGrey, strokeWidth: 2))
                      : const Text("Verify Code", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: TextStyle(color: textColor),
                  ),
                  GestureDetector(
                    onTap: authController.isLoading || !authController.canResend
                        ? null
                        : () async {
                            await authController.forgotPassword("");
                          },
                    child: Text(
                      "Resend",
                      style: TextStyle(
                        color: authController.canResend ? AppColors.primary : theme.colorScheme.onSurface.withOpacity(0.6),
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
      errorText: error,
      counterText: "",
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
    );
  }
}
